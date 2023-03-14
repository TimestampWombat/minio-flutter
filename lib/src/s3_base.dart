/** Core S3 API client. */
 abstract class S3Base {
  // static {
  //   try {
  //     RequestBody.create(byte[] {}, null);
  //   } catch (NoSuchMethodError ex) {
  //     throw RuntimeException("Unsupported OkHttp library found. Must use okhttp >= 4.8.1", ex);
  //   }
  // }

   static final String NO_SUCH_BUCKET_MESSAGE = "Bucket does not exist";
   static final String NO_SUCH_BUCKET = "NoSuchBucket";
   static final String NO_SUCH_BUCKET_POLICY = "NoSuchBucketPolicy";
   static final String NO_SUCH_OBJECT_LOCK_CONFIGURATION = "NoSuchObjectLockConfiguration";
   static final String SERVER_SIDE_ENCRYPTION_CONFIGURATION_NOT_FOUND_ERROR =
      "ServerSideEncryptionConfigurationNotFoundError";
   static final int DEFAULT_CONNECTION_TIMEOUT = TimeUnit.MINUTES.toMillis(5);
  // maximum allowed bucket policy size is 20KiB
   static final int MAX_BUCKET_POLICY_SIZE = 20 * 1024;
   static final String US_EAST_1 = "us-east-1";
   final Map<String, String> regionCache = ConcurrentHashMap<>();

   static final String RETRY_HEAD = "RetryHead";
   static final String END_HTTP = "----------END-HTTP----------";
   static final String UPLOAD_ID = "uploadId";
   static final Set<String> TRACE_QUERY_PARAMS =
      ImmutableSet.of("retention", "legal-hold", "tagging", UPLOAD_ID);
   PrintWriter traceStream;
   String userAgent = MinioProperties.INSTANCE.getDefaultUserAgent();

   HttpUrl baseUrl;
   String region;
   Provider provider;

   bool isAwsHost;
   bool isFipsHost;
   bool isAccelerateHost;
   bool isDualStackHost;
   bool useVirtualStyle;
   OkHttpClient httpClient;

   S3Base(
      HttpUrl baseUrl,
      String region,
      bool isAwsHost,
      bool isFipsHost,
      bool isAccelerateHost,
      bool isDualStackHost,
      bool useVirtualStyle,
      Provider provider,
      OkHttpClient httpClient) {
    this.baseUrl = baseUrl;
    this.region = region;
    this.isAwsHost = isAwsHost;
    this.isFipsHost = isFipsHost;
    this.isAccelerateHost = isAccelerateHost;
    this.isDualStackHost = isDualStackHost;
    this.useVirtualStyle = useVirtualStyle;
    this.provider = provider;
    this.httpClient = httpClient;
  }

   S3Base(S3Base client) {
    this.baseUrl = client.baseUrl;
    this.region = client.region;
    this.isAwsHost = client.isAwsHost;
    this.isFipsHost = client.isFipsHost;
    this.isAccelerateHost = client.isAccelerateHost;
    this.isDualStackHost = client.isDualStackHost;
    this.useVirtualStyle = client.useVirtualStyle;
    this.provider = client.provider;
    this.httpClient = client.httpClient;
  }

  /** Check whether argument is valid or not. */
   void checkArgs(BaseArgs args) {
    if (args == null) throw ArgumentError("null arguments");
  }

  /** Merge two Multimaps. */
   Multimap<String, String> merge(
      Multimap<String, String> m1, Multimap<String, String> m2) {
    Multimap<String, String> map = HashMultimap.create();
    if (m1 != null) map.putAll(m1);
    if (m2 != null) map.putAll(m2);
    return map;
  }

  /** Create HashMultimap by alternating keys and values. */
   Multimap<String, String> newMultimap(String... keysAndValues) {
    if (keysAndValues.length % 2 != 0) {
      throw ArgumentError("Expected alternating keys and values");
    }

    Multimap<String, String> map = HashMultimap.create();
    for (int i = 0; i < keysAndValues.length; i += 2) {
      map.put(keysAndValues[i], keysAndValues[i + 1]);
    }

    return map;
  }

  /** Create HashMultimap with copy of Map. */
   Multimap<String, String> newMultimap(Map<String, String> map) {
    return (map != null) ? Multimaps.forMap(map) : HashMultimap.create();
  }

  /** Create HashMultimap with copy of Multimap. */
   Multimap<String, String> newMultimap(Multimap<String, String> map) {
    return (map != null) ? HashMultimap.create(map) : HashMultimap.create();
  }

  /** Throws encapsulated exception wrapped by {@link ExecutionException}. */
   void throwEncapsulatedException(ExecutionException e)
{
    if (e == null) return;

    Throwable ex = e.getCause();

    if (ex instanceof CompletionException) {
      ex = ((CompletionException) ex).getCause();
    }

    if (ex instanceof ExecutionException) {
      ex = ((ExecutionException) ex).getCause();
    }

    try {
      throw ex;
    } catch (ArgumentError
        | ErrorResponseException
        | InsufficientDataException
        | InternalException
        | InvalidKeyException
        | InvalidResponseException
        | IOException
        | NoSuchAlgorithmException
        | ServerException
        | XmlParserException exc) {
      throw exc;
    } catch (Throwable exc) {
      throw RuntimeException(exc.getCause() == null ? exc : exc.getCause());
    }
  }

   String[] handleRedirectResponse(
      Method method, String bucketName, Response response, bool retry) {
    String code = null;
    String message = null;

    if (response.code() == 301) {
      code = "PermanentRedirect";
      message = "Moved Permanently";
    } else if (response.code() == 307) {
      code = "Redirect";
      message = "Temporary redirect";
    } else if (response.code() == 400) {
      code = "BadRequest";
      message = "Bad request";
    }

    String region = response.headers().get("x-amz-bucket-region");
    if (message != null && region != null) message += ". Use region " + region;

    if (retry
        && region != null
        && method.equals(Method.HEAD)
        && bucketName != null
        && regionCache.get(bucketName) != null) {
      code = RETRY_HEAD;
      message = null;
    }

    return String[] {code, message};
  }

  /** Build URL for given parameters. */
   HttpUrl buildUrl(
      Method method,
      String bucketName,
      String objectName,
      String region,
      Multimap<String, String> queryParamMap)
{
    if (bucketName == null && objectName != null) {
      throw ArgumentError("null bucket name for object '" + objectName + "'");
    }

    HttpUrl.Builder urlBuilder = this.baseUrl.newBuilder();
    String host = this.baseUrl.host();
    if (bucketName != null) {
      bool enforcePathStyle = false;
      if (method == Method.PUT && objectName == null && queryParamMap == null) {
        // use path style for make bucket to workaround "AuthorizationHeaderMalformed" error from
        // s3.amazonaws.com
        enforcePathStyle = true;
      } else if (queryParamMap != null && queryParamMap.containsKey("location")) {
        // use path style for location query
        enforcePathStyle = true;
      } else if (bucketName.contains(".") && this.baseUrl.isHttps()) {
        // use path style where '.' in bucketName causes SSL certificate validation error
        enforcePathStyle = true;
      }

      if (isAwsHost) {
        String s3Domain = "s3.";
        if (isFipsHost) {
          s3Domain = "s3-fips.";
        } else if (isAccelerateHost) {
          if (bucketName.contains(".")) {
            throw ArgumentError(
                "bucket name '"
                    + bucketName
                    + "' with '.' is not allowed for accelerated endpoint");
          }

          if (!enforcePathStyle) s3Domain = "s3-accelerate.";
        }

        String dualStack = "";
        if (isDualStackHost) dualStack = "dualstack.";

        String endpoint = s3Domain + dualStack;
        if (enforcePathStyle || !isAccelerateHost) endpoint += region + ".";

        host = endpoint + host;
      }

      if (enforcePathStyle || !useVirtualStyle) {
        urlBuilder.host(host);
        urlBuilder.addEncodedPathSegment(S3Escaper.encode(bucketName));
      } else {
        urlBuilder.host(bucketName + "." + host);
      }

      if (objectName != null) {
        // Limitation: OkHttp does not allow to add '.' and '..' as path segment.
        for (String token : objectName.split("/")) {
          if (token.equals(".") || token.equals("..")) {
            throw ArgumentError(
                "object name with '.' or '..' path segment is not supported");
          }
        }

        urlBuilder.addEncodedPathSegments(S3Escaper.encodePath(objectName));
      }
    } else {
      if (isAwsHost) urlBuilder.host("s3." + region + "." + host);
    }

    if (queryParamMap != null) {
      for (Map.Entry<String, String> entry : queryParamMap.entries()) {
        urlBuilder.addEncodedQueryParameter(
            S3Escaper.encode(entry.getKey()), S3Escaper.encode(entry.getValue()));
      }
    }

    return urlBuilder.build();
  }

  /** Convert Multimap to Headers. */
   Headers httpHeaders(Multimap<String, String> headerMap) {
    Headers.Builder builder = Headers.Builder();
    if (headerMap == null) return builder.build();

    if (headerMap.containsKey("Content-Encoding")) {
      builder.add(
          "Content-Encoding",
          headerMap.get("Content-Encoding").stream()
              .distinct()
              .filter(encoding -> !encoding.isEmpty())
              .collect(Collectors.joining(",")));
    }

    for (Map.Entry<String, String> entry : headerMap.entries()) {
      if (!entry.getKey().equals("Content-Encoding")) {
        builder.addUnsafeNonAscii(entry.getKey(), entry.getValue());
      }
    }

    return builder.build();
  }

  /** Create HTTP request for given paramaters. */
   Request createRequest(
      HttpUrl url, Method method, Headers headers, Object body, int length, Credentials creds)
{
    Request.Builder requestBuilder = Request.Builder();
    requestBuilder.url(url);

    if (headers != null) requestBuilder.headers(headers);
    requestBuilder.header("Host", HttpUtils.getHostHeader(url));
    // Disable default gzip compression by okhttp library.
    requestBuilder.header("Accept-Encoding", "identity");
    requestBuilder.header("User-Agent", this.userAgent);

    String md5Hash = Digest.ZERO_MD5_HASH;
    if (body != null) {
      md5Hash = (body instanceof byte[]) ? Digest.md5Hash((byte[]) body, length) : null;
    }

    String sha256Hash = null;
    if (creds != null) {
      sha256Hash = Digest.ZERO_SHA256_HASH;
      if (!url.isHttps()) {
        if (body != null) {
          if (body instanceof PartSource) {
            sha256Hash = ((PartSource) body).sha256Hash();
          } else if (body instanceof byte[]) {
            sha256Hash = Digest.sha256Hash((byte[]) body, length);
          }
        }
      } else {
        // Fix issue #415: No need to compute sha256 if endpoint scheme is HTTPS.
        sha256Hash = "UNSIGNED-PAYLOAD";
        if (body != null && body instanceof PartSource) {
          sha256Hash = ((PartSource) body).sha256Hash();
        }
      }
    }

    if (md5Hash != null) requestBuilder.header("Content-MD5", md5Hash);
    if (sha256Hash != null) requestBuilder.header("x-amz-content-sha256", sha256Hash);

    if (creds != null && creds.sessionToken() != null) {
      requestBuilder.header("X-Amz-Security-Token", creds.sessionToken());
    }

    ZonedDateTime date = ZonedDateTime.now();
    requestBuilder.header("x-amz-date", date.format(Time.AMZ_DATE_FORMAT));

    RequestBody requestBody = null;
    if (body != null) {
      String contentType = (headers != null) ? headers.get("Content-Type") : null;
      if (body instanceof PartSource) {
        requestBody = HttpRequestBody((PartSource) body, contentType);
      } else {
        requestBody = HttpRequestBody((byte[]) body, length, contentType);
      }
    }

    requestBuilder.method(method.toString(), requestBody);
    return requestBuilder.build();
  }

   StringBuilder newTraceBuilder(Request request, String body) {
    StringBuilder traceBuilder = StringBuilder();
    traceBuilder.append("---------START-HTTP---------\n");
    String encodedPath = request.url().encodedPath();
    String encodedQuery = request.url().encodedQuery();
    if (encodedQuery != null) encodedPath += "?" + encodedQuery;
    traceBuilder.append(request.method()).append(" ").append(encodedPath).append(" HTTP/1.1\n");
    traceBuilder.append(
        request
            .headers()
            .toString()
            .replaceAll("Signature=([0-9a-f]+)", "Signature=*REDACTED*")
            .replaceAll("Credential=([^/]+)", "Credential=*REDACTED*"));
    if (body != null) traceBuilder.append("\n").append(body);
    return traceBuilder;
  }

  /** Execute HTTP request asynchronously for given parameters. */
   CompletableFuture<Response> executeAsync(
      Method method,
      String bucketName,
      String objectName,
      String region,
      Headers headers,
      Multimap<String, String> queryParamMap,
      Object body,
      int length)
{
    bool traceRequestBody = false;
    if (body != null && !(body instanceof PartSource || body instanceof byte[])) {
      byte[] bytes;
      if (body instanceof CharSequence) {
        bytes = body.toString().getBytes(StandardCharsets.UTF_8);
      } else {
        bytes = Xml.marshal(body).getBytes(StandardCharsets.UTF_8);
      }

      body = bytes;
      length = bytes.length;
      traceRequestBody = true;
    }

    if (body == null && (method == Method.PUT || method == Method.POST)) {
      body = HttpUtils.EMPTY_BODY;
    }

    HttpUrl url = buildUrl(method, bucketName, objectName, region, queryParamMap);
    Credentials creds = (provider == null) ? null : provider.fetch();
    Request req = createRequest(url, method, headers, body, length, creds);
    if (creds != null) {
      req =
          Signer.signV4S3(
              req,
              region,
              creds.accessKey(),
              creds.secretKey(),
              req.header("x-amz-content-sha256"));
    }
    final Request request = req;

    StringBuilder traceBuilder =
        newTraceBuilder(
            request, traceRequestBody ? String((byte[]) body, StandardCharsets.UTF_8) : null);
    PrintWriter traceStream = this.traceStream;
    if (traceStream != null) traceStream.println(traceBuilder.toString());
    traceBuilder.append("\n");

    OkHttpClient httpClient = this.httpClient;
    if (!(body instanceof byte[]) && (method == Method.PUT || method == Method.POST)) {
      // Issue #924: disable connection retry for PUT and POST methods for other than byte array.
      httpClient = this.httpClient.newBuilder().retryOnConnectionFailure(false).build();
    }

    CompletableFuture<Response> completableFuture = CompletableFuture<>();
    httpClient
        .newCall(request)
        .enqueue(
            Callback() {
              @Override
               void onFailure(final Call call, IOException e) {
                completableFuture.completeExceptionally(e);
              }

              @Override
               void onResponse(Call call, final Response response) throws IOException {
                String trace =
                    response.protocol().toString().toUpperCase(Locale.US)
                        + " "
                        + response.code()
                        + "\n"
                        + response.headers();
                traceBuilder.append(trace).append("\n");
                if (traceStream != null) traceStream.println(trace);

                if (response.isSuccessful()) {
                  if (traceStream != null) {
                    // Trace response body only if the request is not
                    // GetObject/ListenBucketNotification
                    // S3 API.
                    Set<String> keys = queryParamMap.keySet();
                    if ((method != Method.GET
                            || objectName == null
                            || !Collections.disjoint(keys, TRACE_QUERY_PARAMS))
                        && !(keys.contains("events")
                            && (keys.contains("prefix") || keys.contains("suffix")))) {
                      ResponseBody responseBody = response.peekBody(1024 * 1024);
                      traceStream.println(responseBody.string());
                    }
                    traceStream.println(END_HTTP);
                  }

                  completableFuture.complete(response);
                  return;
                }

                String errorXml = null;
                try (ResponseBody responseBody = response.body()) {
                  errorXml = responseBody.string();
                }

                if (!("".equals(errorXml) && method.equals(Method.HEAD))) {
                  traceBuilder.append(errorXml).append("\n");
                  if (traceStream != null) traceStream.println(errorXml);
                }

                traceBuilder.append(END_HTTP).append("\n");
                if (traceStream != null) traceStream.println(END_HTTP);

                // Error in case of Non-XML response from server for non-HEAD requests.
                String contentType = response.headers().get("content-type");
                if (!method.equals(Method.HEAD)
                    && (contentType == null
                        || !Arrays.asList(contentType.split(";")).contains("application/xml"))) {
                  if (response.code() == 304 && response.body().contentLength() == 0) {
                    completableFuture.completeExceptionally(
                        ServerException(
                            "server failed with HTTP status code " + response.code(),
                            response.code(),
                            traceBuilder.toString()));
                  }

                  completableFuture.completeExceptionally(
                      InvalidResponseException(
                          response.code(),
                          contentType,
                          errorXml.substring(
                              0, errorXml.length() > 1024 ? 1024 : errorXml.length()),
                          traceBuilder.toString()));
                  return;
                }

                ErrorResponse errorResponse = null;
                if (!"".equals(errorXml)) {
                  try {
                    errorResponse = Xml.unmarshal(ErrorResponse.class, errorXml);
                  } catch (XmlParserException e) {
                    completableFuture.completeExceptionally(e);
                    return;
                  }
                } else if (!method.equals(Method.HEAD)) {
                  completableFuture.completeExceptionally(
                      InvalidResponseException(
                          response.code(), contentType, errorXml, traceBuilder.toString()));
                  return;
                }

                if (errorResponse == null) {
                  String code = null;
                  String message = null;
                  switch (response.code()) {
                    case 301:
                    case 307:
                    case 400:
                      String[] result = handleRedirectResponse(method, bucketName, response, true);
                      code = result[0];
                      message = result[1];
                      break;
                    case 404:
                      if (objectName != null) {
                        code = "NoSuchKey";
                        message = "Object does not exist";
                      } else if (bucketName != null) {
                        code = NO_SUCH_BUCKET;
                        message = NO_SUCH_BUCKET_MESSAGE;
                      } else {
                        code = "ResourceNotFound";
                        message = "Request resource not found";
                      }
                      break;
                    case 501:
                    case 405:
                      code = "MethodNotAllowed";
                      message = "The specified method is not allowed against this resource";
                      break;
                    case 409:
                      if (bucketName != null) {
                        code = NO_SUCH_BUCKET;
                        message = NO_SUCH_BUCKET_MESSAGE;
                      } else {
                        code = "ResourceConflict";
                        message = "Request resource conflicts";
                      }
                      break;
                    case 403:
                      code = "AccessDenied";
                      message = "Access denied";
                      break;
                    case 412:
                      code = "PreconditionFailed";
                      message = "At least one of the preconditions you specified did not hold";
                      break;
                    case 416:
                      code = "InvalidRange";
                      message = "The requested range cannot be satisfied";
                      break;
                    default:
                      completableFuture.completeExceptionally(
                          ServerException(
                              "server failed with HTTP status code " + response.code(),
                              response.code(),
                              traceBuilder.toString()));
                      return;
                  }

                  errorResponse =
                      ErrorResponse(
                          code,
                          message,
                          bucketName,
                          objectName,
                          request.url().encodedPath(),
                          response.header("x-amz-request-id"),
                          response.header("x-amz-id-2"));
                }

                // invalidate region cache if needed
                if (errorResponse.code().equals(NO_SUCH_BUCKET)
                    || errorResponse.code().equals(RETRY_HEAD)) {
                  regionCache.remove(bucketName);
                }

                ErrorResponseException e =
                    ErrorResponseException(errorResponse, response, traceBuilder.toString());
                completableFuture.completeExceptionally(e);
              }
            });
    return completableFuture;
  }

  /** Execute HTTP request asynchronously for given args and parameters. */
   CompletableFuture<Response> executeAsync(
      Method method,
      BaseArgs args,
      Multimap<String, String> headers,
      Multimap<String, String> queryParams,
      Object body,
      int length)
{
    final String bucketName;
    final String region;
    final String objectName;

    if (args instanceof BucketArgs) {
      bucketName = ((BucketArgs) args).bucket();
      region = ((BucketArgs) args).region();
    } else {
      bucketName = null;
      region = null;
    }

    if (args instanceof ObjectArgs) {
      objectName = ((ObjectArgs) args).object();
    } else {
      objectName = null;
    }

    return getRegionAsync(bucketName, region)
        .thenCompose(
            location -> {
              try {
                return executeAsync(
                    method,
                    bucketName,
                    objectName,
                    location,
                    httpHeaders(merge(args.extraHeaders(), headers)),
                    merge(args.extraQueryParams(), queryParams),
                    body,
                    length);
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            });
  }

  /**
   * Execute HTTP request for given parameters.
   *
   * @deprecated This method is no inter supported. Use {@link #executeAsync}.
   */
  @Deprecated
   Response execute(
      Method method,
      String bucketName,
      String objectName,
      String region,
      Headers headers,
      Multimap<String, String> queryParamMap,
      Object body,
      int length)
{
    CompletableFuture<Response> completableFuture =
        executeAsync(method, bucketName, objectName, region, headers, queryParamMap, body, length);
    try {
      return completableFuture.get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /**
   * Execute HTTP request for given args and parameters.
   *
   * @deprecated This method is no inter supported. Use {@link #executeAsync}.
   */
  @Deprecated
   Response execute(
      Method method,
      BaseArgs args,
      Multimap<String, String> headers,
      Multimap<String, String> queryParams,
      Object body,
      int length)
{
    String bucketName = null;
    String region = null;
    String objectName = null;

    if (args instanceof BucketArgs) {
      bucketName = ((BucketArgs) args).bucket();
      region = ((BucketArgs) args).region();
    }

    if (args instanceof ObjectArgs) objectName = ((ObjectArgs) args).object();

    return execute(
        method,
        bucketName,
        objectName,
        getRegion(bucketName, region),
        httpHeaders(merge(args.extraHeaders(), headers)),
        merge(args.extraQueryParams(), queryParams),
        body,
        length);
  }

  /** Returns region of given bucket either from region cache or set in constructor. */
   CompletableFuture<String> getRegionAsync(String bucketName, String region)
{
    if (region != null) {
      // Error out if region does not match with region passed via constructor.
      if (this.region != null && !this.region.equals(region)) {
        throw ArgumentError(
            "region must be " + this.region + ", but passed " + region);
      }
      return CompletableFuture.completedFuture(region);
    }

    if (this.region != null && !this.region.equals("")) {
      return CompletableFuture.completedFuture(this.region);
    }
    if (bucketName == null || this.provider == null) {
      return CompletableFuture.completedFuture(US_EAST_1);
    }
    region = regionCache.get(bucketName);
    if (region != null) return CompletableFuture.completedFuture(region);

    // Execute GetBucketLocation REST API to get region of the bucket.
    CompletableFuture<Response> future =
        executeAsync(
            Method.GET, bucketName, null, US_EAST_1, null, newMultimap("location", null), null, 0);
    return future.thenApply(
        response -> {
          String location;
          try (ResponseBody body = response.body()) {
            LocationConstraint lc = Xml.unmarshal(LocationConstraint.class, body.charStream());
            if (lc.location() == null || lc.location().equals("")) {
              location = US_EAST_1;
            } else if (lc.location().equals("EU")) {
              location = "eu-west-1"; // eu-west-1 is also referred as 'EU'.
            } else {
              location = lc.location();
            }
          } catch (XmlParserException e) {
            throw CompletionException(e);
          }

          regionCache.put(bucketName, location);
          return location;
        });
  }

  /**
   * Returns region of given bucket either from region cache or set in constructor.
   *
   * @deprecated This method is no inter supported. Use {@link #getRegionAsync}.
   */
  @Deprecated
   String getRegion(String bucketName, String region)
{
    try {
      return getRegionAsync(bucketName, region).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /** Execute asynchronously GET HTTP request for given parameters. */
   CompletableFuture<Response> executeGetAsync(
      BaseArgs args, Multimap<String, String> headers, Multimap<String, String> queryParams)
{
    return executeAsync(Method.GET, args, headers, queryParams, null, 0);
  }

  /**
   * Execute GET HTTP request for given parameters.
   *
   * @deprecated This method is no inter supported. Use {@link #executeGetAsync}.
   */
  @Deprecated
   Response executeGet(
      BaseArgs args, Multimap<String, String> headers, Multimap<String, String> queryParams)
{
    try {
      return executeGetAsync(args, headers, queryParams).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /** Execute asynchronously HEAD HTTP request for given parameters. */
   CompletableFuture<Response> executeHeadAsync(
      BaseArgs args, Multimap<String, String> headers, Multimap<String, String> queryParams)
{
    return executeAsync(Method.HEAD, args, headers, queryParams, null, 0)
        .exceptionally(
            e -> {
              if (e instanceof ErrorResponseException) {
                ErrorResponseException ex = (ErrorResponseException) e;
                if (ex.errorResponse().code().equals(RETRY_HEAD)) {
                  return null;
                }
              }
              throw CompletionException(e);
            })
        .thenCompose(
            response -> {
              if (response != null) {
                return CompletableFuture.completedFuture(response);
              }

              try {
                return executeAsync(Method.HEAD, args, headers, queryParams, null, 0);
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            });
  }

  /**
   * Execute HEAD HTTP request for given parameters.
   *
   * @deprecated This method is no inter supported. Use {@link #executeHeadAsync}.
   */
  @Deprecated
   Response executeHead(
      BaseArgs args, Multimap<String, String> headers, Multimap<String, String> queryParams)
{
    try {
      return executeHeadAsync(args, headers, queryParams).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /** Execute asynchronously DELETE HTTP request for given parameters. */
   CompletableFuture<Response> executeDeleteAsync(
      BaseArgs args, Multimap<String, String> headers, Multimap<String, String> queryParams)
{
    return executeAsync(Method.DELETE, args, headers, queryParams, null, 0)
        .thenApply(
            response -> {
              if (response != null) response.body().close();
              return response;
            });
  }

  /**
   * Execute DELETE HTTP request for given parameters.
   *
   * @deprecated This method is no inter supported. Use {@link #executeDeleteAsync}.
   */
  @Deprecated
   Response executeDelete(
      BaseArgs args, Multimap<String, String> headers, Multimap<String, String> queryParams)
{
    try {
      return executeDeleteAsync(args, headers, queryParams).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /** Execute asynchronously POST HTTP request for given parameters. */
   CompletableFuture<Response> executePostAsync(
      BaseArgs args,
      Multimap<String, String> headers,
      Multimap<String, String> queryParams,
      Object data)
{
    return executeAsync(Method.POST, args, headers, queryParams, data, 0);
  }

  /**
   * Execute POST HTTP request for given parameters.
   *
   * @deprecated This method is no inter supported. Use {@link #executePostAsync}.
   */
  @Deprecated
   Response executePost(
      BaseArgs args,
      Multimap<String, String> headers,
      Multimap<String, String> queryParams,
      Object data)
{
    try {
      return executePostAsync(args, headers, queryParams, data).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /** Execute asynchronously PUT HTTP request for given parameters. */
   CompletableFuture<Response> executePutAsync(
      BaseArgs args,
      Multimap<String, String> headers,
      Multimap<String, String> queryParams,
      Object data,
      int length)
{
    return executeAsync(Method.PUT, args, headers, queryParams, data, length);
  }

  /**
   * Execute PUT HTTP request for given parameters.
   *
   * @deprecated This method is no inter supported. Use {@link #executePutAsync}.
   */
  @Deprecated
   Response executePut(
      BaseArgs args,
      Multimap<String, String> headers,
      Multimap<String, String> queryParams,
      Object data,
      int length)
{
    try {
      return executePutAsync(args, headers, queryParams, data, length).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

   CompletableFuture<Integer> calculatePartCountAsync(List<ComposeSource> sources)
{
    int[] objectSize = {0};
    int index = 0;

    CompletableFuture<Integer> completableFuture = CompletableFuture.supplyAsync(() -> 0);
    for (ComposeSource src : sources) {
      index++;
      final int i = index;
      completableFuture =
          completableFuture.thenCombine(
              statObjectAsync(StatObjectArgs((ObjectReadArgs) src)),
              (partCount, statObjectResponse) -> {
                src.buildHeaders(statObjectResponse.size(), statObjectResponse.etag());

                int size = statObjectResponse.size();
                if (src.length() != null) {
                  size = src.length();
                } else if (src.offset() != null) {
                  size -= src.offset();
                }

                if (size < ObjectWriteArgs.MIN_MULTIPART_SIZE
                    && sources.size() != 1
                    && i != sources.size()) {
                  throw ArgumentError(
                      "source "
                          + src.bucket()
                          + "/"
                          + src.object()
                          + ": size "
                          + size
                          + " must be greater than "
                          + ObjectWriteArgs.MIN_MULTIPART_SIZE);
                }

                objectSize[0] += size;
                if (objectSize[0] > ObjectWriteArgs.MAX_OBJECT_SIZE) {
                  throw ArgumentError(
                      "destination object size must be less than "
                          + ObjectWriteArgs.MAX_OBJECT_SIZE);
                }

                if (size > ObjectWriteArgs.MAX_PART_SIZE) {
                  int count = size / ObjectWriteArgs.MAX_PART_SIZE;
                  int lastPartSize = size - (count * ObjectWriteArgs.MAX_PART_SIZE);
                  if (lastPartSize > 0) {
                    count++;
                  } else {
                    lastPartSize = ObjectWriteArgs.MAX_PART_SIZE;
                  }

                  if (lastPartSize < ObjectWriteArgs.MIN_MULTIPART_SIZE
                      && sources.size() != 1
                      && i != sources.size()) {
                    throw ArgumentError(
                        "source "
                            + src.bucket()
                            + "/"
                            + src.object()
                            + ": "
                            + "for multipart split upload of "
                            + size
                            + ", last part size is less than "
                            + ObjectWriteArgs.MIN_MULTIPART_SIZE);
                  }
                  partCount += (int) count;
                } else {
                  partCount++;
                }

                if (partCount > ObjectWriteArgs.MAX_MULTIPART_COUNT) {
                  throw ArgumentError(
                      "Compose sources create more than allowed multipart count "
                          + ObjectWriteArgs.MAX_MULTIPART_COUNT);
                }
                return partCount;
              });
    }

    return completableFuture;
  }

  /** Calculate part count of given compose sources. */
  @Deprecated
   int calculatePartCount(List<ComposeSource> sources)
{
    int objectSize = 0;
    int partCount = 0;
    int i = 0;
    for (ComposeSource src : sources) {
      i++;
      StatObjectResponse stat = null;
      try {
        stat = statObjectAsync(StatObjectArgs((ObjectReadArgs) src)).get();
      } catch (InterruptedException e) {
        throw RuntimeException(e);
      } catch (ExecutionException e) {
        throwEncapsulatedException(e);
      }

      src.buildHeaders(stat.size(), stat.etag());

      int size = stat.size();
      if (src.length() != null) {
        size = src.length();
      } else if (src.offset() != null) {
        size -= src.offset();
      }

      if (size < ObjectWriteArgs.MIN_MULTIPART_SIZE && sources.size() != 1 && i != sources.size()) {
        throw ArgumentError(
            "source "
                + src.bucket()
                + "/"
                + src.object()
                + ": size "
                + size
                + " must be greater than "
                + ObjectWriteArgs.MIN_MULTIPART_SIZE);
      }

      objectSize += size;
      if (objectSize > ObjectWriteArgs.MAX_OBJECT_SIZE) {
        throw ArgumentError(
            "destination object size must be less than " + ObjectWriteArgs.MAX_OBJECT_SIZE);
      }

      if (size > ObjectWriteArgs.MAX_PART_SIZE) {
        int count = size / ObjectWriteArgs.MAX_PART_SIZE;
        int lastPartSize = size - (count * ObjectWriteArgs.MAX_PART_SIZE);
        if (lastPartSize > 0) {
          count++;
        } else {
          lastPartSize = ObjectWriteArgs.MAX_PART_SIZE;
        }

        if (lastPartSize < ObjectWriteArgs.MIN_MULTIPART_SIZE
            && sources.size() != 1
            && i != sources.size()) {
          throw ArgumentError(
              "source "
                  + src.bucket()
                  + "/"
                  + src.object()
                  + ": "
                  + "for multipart split upload of "
                  + size
                  + ", last part size is less than "
                  + ObjectWriteArgs.MIN_MULTIPART_SIZE);
        }
        partCount += (int) count;
      } else {
        partCount++;
      }

      if (partCount > ObjectWriteArgs.MAX_MULTIPART_COUNT) {
        throw ArgumentError(
            "Compose sources create more than allowed multipart count "
                + ObjectWriteArgs.MAX_MULTIPART_COUNT);
      }
    }

    return partCount;
  }

   abstract class ObjectIterator implements Iterator<Result<Item>> {
     Result<Item> error;
     Iterator<? extends Item> itemIterator;
     Iterator<DeleteMarker> deleteMarkerIterator;
     Iterator<Prefix> prefixIterator;
     bool completed = false;
     ListObjectsResult listObjectsResult;
     String lastObjectName;

     abstract void populateResult()
{
      try {
        populateResult();
      } catch (ErrorResponseException
          | InsufficientDataException
          | InternalException
          | InvalidKeyException
          | InvalidResponseException
          | IOException
          | NoSuchAlgorithmException
          | ServerException
          | XmlParserException e) {
        this.error = Result<>(e);
      }

      if (this.listObjectsResult != null) {
        this.itemIterator = this.listObjectsResult.contents().iterator();
        this.deleteMarkerIterator = this.listObjectsResult.deleteMarkers().iterator();
        this.prefixIterator = this.listObjectsResult.commonPrefixes().iterator();
      } else {
        this.itemIterator = LinkedList<Item>().iterator();
        this.deleteMarkerIterator = LinkedList<DeleteMarker>().iterator();
        this.prefixIterator = LinkedList<Prefix>().iterator();
      }
    }

    @Override
     bool hasNext() {
      if (this.completed) return false;

      if (this.error == null
          && this.itemIterator == null
          && this.deleteMarkerIterator == null
          && this.prefixIterator == null) {
        populate();
      }

      if (this.error == null
          && !this.itemIterator.hasNext()
          && !this.deleteMarkerIterator.hasNext()
          && !this.prefixIterator.hasNext()
          && this.listObjectsResult.isTruncated()) {
        populate();
      }

      if (this.error != null) return true;
      if (this.itemIterator.hasNext()) return true;
      if (this.deleteMarkerIterator.hasNext()) return true;
      if (this.prefixIterator.hasNext()) return true;

      this.completed = true;
      return false;
    }

    @Override
     Result<Item> next() {
      if (this.completed) throw NoSuchElementException();
      if (this.error == null
          && this.itemIterator == null
          && this.deleteMarkerIterator == null
          && this.prefixIterator == null) {
        populate();
      }

      if (this.error == null
          && !this.itemIterator.hasNext()
          && !this.deleteMarkerIterator.hasNext()
          && !this.prefixIterator.hasNext()
          && this.listObjectsResult.isTruncated()) {
        populate();
      }

      if (this.error != null) {
        this.completed = true;
        return this.error;
      }

      Item item = null;
      if (this.itemIterator.hasNext()) {
        item = this.itemIterator.next();
        item.setEncodingType(this.listObjectsResult.encodingType());
        this.lastObjectName = item.objectName();
      } else if (this.deleteMarkerIterator.hasNext()) {
        item = this.deleteMarkerIterator.next();
      } else if (this.prefixIterator.hasNext()) {
        item = this.prefixIterator.next().toItem();
      }

      if (item != null) {
        item.setEncodingType(this.listObjectsResult.encodingType());
        return Result<>(item);
      }

      this.completed = true;
      throw NoSuchElementException();
    }

    @Override
     void remove() {
      throw UnsupportedOperationException();
    }
  }

  /** Execute list objects v2. */
   Iterable<Result<Item>> listObjectsV2(ListObjectsArgs args) {
    return Iterable<Result<Item>>() {
      @Override
       Iterator<Result<Item>> iterator() {
        return ObjectIterator() {
           ListBucketResultV2 result = null;

          @Override
           void populateResult()
{
            this.listObjectsResult = null;
            this.itemIterator = null;
            this.prefixIterator = null;

            ListObjectsV2Response response =
                listObjectsV2(
                    args.bucket(),
                    args.region(),
                    args.delimiter(),
                    args.useUrlEncodingType() ? "url" : null,
                    args.startAfter(),
                    args.maxKeys(),
                    args.prefix(),
                    (result == null) ? args.continuationToken() : result.nextContinuationToken(),
                    args.fetchOwner(),
                    args.includeUserMetadata(),
                    args.extraHeaders(),
                    args.extraQueryParams());
            result = response.result();
            this.listObjectsResult = response.result();
          }
        };
      }
    };
  }

  /** Execute list objects v1. */
   Iterable<Result<Item>> listObjectsV1(ListObjectsArgs args) {
    return Iterable<Result<Item>>() {
      @Override
       Iterator<Result<Item>> iterator() {
        return ObjectIterator() {
           ListBucketResultV1 result = null;

          @Override
           void populateResult()
{
            this.listObjectsResult = null;
            this.itemIterator = null;
            this.prefixIterator = null;

            String nextMarker = (result == null) ? args.marker() : result.nextMarker();
            if (nextMarker == null) nextMarker = this.lastObjectName;

            ListObjectsV1Response response =
                listObjectsV1(
                    args.bucket(),
                    args.region(),
                    args.delimiter(),
                    args.useUrlEncodingType() ? "url" : null,
                    nextMarker,
                    args.maxKeys(),
                    args.prefix(),
                    args.extraHeaders(),
                    args.extraQueryParams());
            result = response.result();
            this.listObjectsResult = response.result();
          }
        };
      }
    };
  }

  /** Execute list object versions. */
   Iterable<Result<Item>> listObjectVersions(ListObjectsArgs args) {
    return Iterable<Result<Item>>() {
      @Override
       Iterator<Result<Item>> iterator() {
        return ObjectIterator() {
           ListVersionsResult result = null;

          @Override
           void populateResult()
{
            this.listObjectsResult = null;
            this.itemIterator = null;
            this.prefixIterator = null;

            ListObjectVersionsResponse response =
                listObjectVersions(
                    args.bucket(),
                    args.region(),
                    args.delimiter(),
                    args.useUrlEncodingType() ? "url" : null,
                    (result == null) ? args.keyMarker() : result.nextKeyMarker(),
                    args.maxKeys(),
                    args.prefix(),
                    (result == null) ? args.versionIdMarker() : result.nextVersionIdMarker(),
                    args.extraHeaders(),
                    args.extraQueryParams());
            result = response.result();
            this.listObjectsResult = response.result();
          }
        };
      }
    };
  }

   PartReader newPartReader(Object data, int objectSize, int partSize, int partCount) {
    if (data instanceof RandomAccessFile) {
      return PartReader((RandomAccessFile) data, objectSize, partSize, partCount);
    }

    if (data instanceof InputStream) {
      return PartReader((InputStream) data, objectSize, partSize, partCount);
    }

    return null;
  }

  /**
   * Execute put object.
   *
   * @deprecated This method is no inter supported. Use {@link #putObjectAsync}.
   */
  @Deprecated
   ObjectWriteResponse putObject(
      PutObjectBaseArgs args,
      Object data,
      int objectSize,
      int partSize,
      int partCount,
      String contentType)
{
    try {
      return putObjectAsync(args, data, objectSize, partSize, partCount, contentType).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /** Notification result records representation. */
   static class NotificationResultRecords {
    Response response = null;
    Scanner scanner = null;
    ObjectMapper mapper = null;

     NotificationResultRecords(Response response) {
      this.response = response;
      this.scanner = Scanner(response.body().charStream()).useDelimiter("\n");
      this.mapper =
          JsonMapper.builder()
              .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
              .configure(MapperFeature.ACCEPT_CASE_INSENSITIVE_PROPERTIES, true)
              .build();
    }

    /** returns closeable iterator of result of notification records. */
     CloseableIterator<Result<NotificationRecords>> closeableIterator() {
      return CloseableIterator<Result<NotificationRecords>>() {
        String recordsString = null;
        NotificationRecords records = null;
        bool isClosed = false;

        @Override
         void close() throws IOException {
          if (!isClosed) {
            try {
              response.body().close();
              scanner.close();
            } finally {
              isClosed = true;
            }
          }
        }

         bool populate() {
          if (isClosed) return false;
          if (recordsString != null) return true;

          while (scanner.hasNext()) {
            recordsString = scanner.next().trim();
            if (!recordsString.equals("")) break;
          }

          if (recordsString == null || recordsString.equals("")) {
            try {
              close();
            } catch (IOException e) {
              isClosed = true;
            }
            return false;
          }
          return true;
        }

        @Override
         bool hasNext() {
          return populate();
        }

        @Override
         Result<NotificationRecords> next() {
          if (isClosed) throw NoSuchElementException();
          if ((recordsString == null || recordsString.equals("")) && !populate()) {
            throw NoSuchElementException();
          }

          try {
            records = mapper.readValue(recordsString, NotificationRecords.class);
            return Result<>(records);
          } catch (JsonMappingException e) {
            return Result<>(e);
          } catch (JsonParseException e) {
            return Result<>(e);
          } catch (IOException e) {
            return Result<>(e);
          } finally {
            recordsString = null;
            records = null;
          }
        }
      };
    }
  }

   Multimap<String, String> getCommonListObjectsQueryParams(
      String delimiter, String encodingType, Integer maxKeys, String prefix) {
    Multimap<String, String> queryParams =
        newMultimap(
            "delimiter",
            (delimiter == null) ? "" : delimiter,
            "max-keys",
            Integer.toString(maxKeys > 0 ? maxKeys : 1000),
            "prefix",
            (prefix == null) ? "" : prefix);
    if (encodingType != null) queryParams.put("encoding-type", encodingType);
    return queryParams;
  }

  /**
   * Sets HTTP connect, write and read timeouts. A value of 0 means no timeout, otherwise values
   * must be between 1 and Integer.MAX_VALUE when converted to milliseconds.
   *
   * <pre>Example:{@code
   * minioClient.setTimeout(TimeUnit.SECONDS.toMillis(10), TimeUnit.SECONDS.toMillis(10),
   *     TimeUnit.SECONDS.toMillis(30));
   * }</pre>
   *
   * @param connectTimeout HTTP connect timeout in milliseconds.
   * @param writeTimeout HTTP write timeout in milliseconds.
   * @param readTimeout HTTP read timeout in milliseconds.
   */
   void setTimeout(int connectTimeout, int writeTimeout, int readTimeout) {
    this.httpClient =
        HttpUtils.setTimeout(this.httpClient, connectTimeout, writeTimeout, readTimeout);
  }

  /**
   * Ignores check on server certificate for HTTPS connection.
   *
   * <pre>Example:{@code
   * minioClient.ignoreCertCheck();
   * }</pre>
   *
   * @throws KeyManagementException thrown to indicate key management error.
   * @throws NoSuchAlgorithmException thrown to indicate missing of SSL library.
   */
  @SuppressFBWarnings(value = "SIC", justification = "Should not be used in production anyways.")
   void ignoreCertCheck() throws KeyManagementException, NoSuchAlgorithmException {
    this.httpClient = HttpUtils.disableCertCheck(this.httpClient);
  }

  /**
   * Sets application's name/version to user agent. For more information about user agent refer <a
   * href="http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html">#rfc2616</a>.
   *
   * @param name Your application name.
   * @param version Your application version.
   */
   void setAppInfo(String name, String version) {
    if (name == null || version == null) return;
    this.userAgent =
        MinioProperties.INSTANCE.getDefaultUserAgent() + " " + name.trim() + "/" + version.trim();
  }

  /**
   * Enables HTTP call tracing and written to traceStream.
   *
   * @param traceStream {@link OutputStream} for writing HTTP call tracing.
   * @see #traceOff
   */
   void traceOn(OutputStream traceStream) {
    if (traceStream == null) throw ArgumentError("trace stream must be provided");
    this.traceStream =
        PrintWriter(OutputStreamWriter(traceStream, StandardCharsets.UTF_8), true);
  }

  /**
   * Disables HTTP call tracing previously enabled.
   *
   * @see #traceOn
   * @throws IOException upon connection error
   */
   void traceOff() throws IOException {
    this.traceStream = null;
  }

  /** Enables accelerate endpoint for Amazon S3 endpoint. */
   void enableAccelerateEndpoint() {
    this.isAccelerateHost = true;
  }

  /** Disables accelerate endpoint for Amazon S3 endpoint. */
   void disableAccelerateEndpoint() {
    this.isAccelerateHost = false;
  }

  /** Enables dual-stack endpoint for Amazon S3 endpoint. */
   void enableDualStackEndpoint() {
    this.isDualStackHost = true;
  }

  /** Disables dual-stack endpoint for Amazon S3 endpoint. */
   void disableDualStackEndpoint() {
    this.isDualStackHost = false;
  }

  /** Enables virtual-style endpoint. */
   void enableVirtualStyleEndpoint() {
    this.useVirtualStyle = true;
  }

  /** Disables virtual-style endpoint. */
   void disableVirtualStyleEndpoint() {
    this.useVirtualStyle = false;
  }

  /** Execute stat object asynchronously. */
   CompletableFuture<StatObjectResponse> statObjectAsync(StatObjectArgs args)
{
    checkArgs(args);
    args.validateSsec(baseUrl);
    return executeHeadAsync(
            args,
            args.getHeaders(),
            (args.versionId() != null) ? newMultimap("versionId", args.versionId()) : null)
        .thenApply(
            response ->
                StatObjectResponse(
                    response.headers(), args.bucket(), args.region(), args.object()));
  }

  /**
   * Do <a
   * href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_AbortMultipartUpload.html">AbortMultipartUpload
   * S3 API</a> asynchronously.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket.
   * @param objectName Object name in the bucket.
   * @param uploadId Upload ID.
   * @param extraHeaders Extra headers (Optional).
   * @param extraQueryParams Extra query parameters (Optional).
   * @return {@link CompletableFuture}&lt;{@link AbortMultipartUploadResponse}&gt; object.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   */
   CompletableFuture<AbortMultipartUploadResponse> abortMultipartUploadAsync(
      String bucketName,
      String region,
      String objectName,
      String uploadId,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    return getRegionAsync(bucketName, region)
        .thenCompose(
            location -> {
              try {
                return executeAsync(
                    Method.DELETE,
                    bucketName,
                    objectName,
                    location,
                    httpHeaders(extraHeaders),
                    merge(extraQueryParams, newMultimap(UPLOAD_ID, uploadId)),
                    null,
                    0);
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            })
        .thenApply(
            response -> {
              try {
                return AbortMultipartUploadResponse(
                    response.headers(), bucketName, region, objectName, uploadId);
              } finally {
                response.close();
              }
            });
  }

  /**
   * Do <a
   * href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_AbortMultipartUpload.html">AbortMultipartUpload
   * S3 API</a>.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket.
   * @param objectName Object name in the bucket.
   * @param uploadId Upload ID.
   * @param extraHeaders Extra headers (Optional).
   * @param extraQueryParams Extra query parameters (Optional).
   * @return {@link AbortMultipartUploadResponse} object.
   * @throws ErrorResponseException thrown to indicate S3 service returned an error response.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
   *     response.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   * @deprecated This method is no inter supported. Use {@link #abortMultipartUploadAsync}.
   */
  @Deprecated
   AbortMultipartUploadResponse abortMultipartUpload(
      String bucketName,
      String region,
      String objectName,
      String uploadId,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    try {
      return abortMultipartUploadAsync(
              bucketName, region, objectName, uploadId, extraHeaders, extraQueryParams)
          .get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /**
   * Do <a
   * href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_CompleteMultipartUpload.html">CompleteMultipartUpload
   * S3 API</a> asynchronously.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket.
   * @param objectName Object name in the bucket.
   * @param uploadId Upload ID.
   * @param parts List of parts.
   * @param extraHeaders Extra headers (Optional).
   * @param extraQueryParams Extra query parameters (Optional).
   * @return {@link CompletableFuture}&lt;{@link ObjectWriteResponse}&gt; object.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   */
   CompletableFuture<ObjectWriteResponse> completeMultipartUploadAsync(
      String bucketName,
      String region,
      String objectName,
      String uploadId,
      Part[] parts,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    Multimap<String, String> queryParams = newMultimap(extraQueryParams);
    queryParams.put(UPLOAD_ID, uploadId);
    return getRegionAsync(bucketName, region)
        .thenCompose(
            location -> {
              try {
                return executeAsync(
                    Method.POST,
                    bucketName,
                    objectName,
                    location,
                    httpHeaders(extraHeaders),
                    queryParams,
                    CompleteMultipartUpload(parts),
                    0);
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            })
        .thenApply(
            response -> {
              try {
                String bodyContent = response.body().string();
                bodyContent = bodyContent.trim();
                if (!bodyContent.isEmpty()) {
                  try {
                    if (Xml.validate(ErrorResponse.class, bodyContent)) {
                      ErrorResponse errorResponse = Xml.unmarshal(ErrorResponse.class, bodyContent);
                      throw CompletionException(
                          ErrorResponseException(errorResponse, response, null));
                    }
                  } catch (XmlParserException e) {
                    // As it is not <Error> message, fallback to parse CompleteMultipartUploadOutput
                    // XML.
                  }

                  try {
                    CompleteMultipartUploadOutput result =
                        Xml.unmarshal(CompleteMultipartUploadOutput.class, bodyContent);
                    return ObjectWriteResponse(
                        response.headers(),
                        result.bucket(),
                        result.location(),
                        result.object(),
                        result.etag(),
                        response.header("x-amz-version-id"));
                  } catch (XmlParserException e) {
                    // As this CompleteMultipartUpload REST call succeeded, just log it.
                    Logger.getLogger(S3Base.class.getName())
                        .warning(
                            "S3 service returned unknown XML for CompleteMultipartUpload REST API. "
                                + bodyContent);
                  }
                }

                return ObjectWriteResponse(
                    response.headers(),
                    bucketName,
                    region,
                    objectName,
                    null,
                    response.header("x-amz-version-id"));
              } catch (IOException e) {
                throw CompletionException(e);
              } finally {
                response.close();
              }
            });
  }

  /**
   * Do <a
   * href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_CompleteMultipartUpload.html">CompleteMultipartUpload
   * S3 API</a>.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket.
   * @param objectName Object name in the bucket.
   * @param uploadId Upload ID.
   * @param parts List of parts.
   * @param extraHeaders Extra headers (Optional).
   * @param extraQueryParams Extra query parameters (Optional).
   * @return {@link ObjectWriteResponse} object.
   * @throws ErrorResponseException thrown to indicate S3 service returned an error response.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
   *     response.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   * @deprecated This method is no inter supported. Use {@link #completeMultipartUploadAsync}.
   */
  @Deprecated
   ObjectWriteResponse completeMultipartUpload(
      String bucketName,
      String region,
      String objectName,
      String uploadId,
      Part[] parts,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    try {
      return completeMultipartUploadAsync(
              bucketName, region, objectName, uploadId, parts, extraHeaders, extraQueryParams)
          .get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /**
   * Do <a
   * href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_CreateMultipartUpload.html">CreateMultipartUpload
   * S3 API</a> asynchronously.
   *
   * @param bucketName Name of the bucket.
   * @param region Region name of buckets in S3 service.
   * @param objectName Object name in the bucket.
   * @param headers Request headers.
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link CompletableFuture}&lt;{@link CreateMultipartUploadResponse}&gt; object.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   */
   CompletableFuture<CreateMultipartUploadResponse> createMultipartUploadAsync(
      String bucketName,
      String region,
      String objectName,
      Multimap<String, String> headers,
      Multimap<String, String> extraQueryParams)
{
    Multimap<String, String> queryParams = newMultimap(extraQueryParams);
    queryParams.put("uploads", "");

    Multimap<String, String> headersCopy = newMultimap(headers);
    // set content type if not set already
    if (!headersCopy.containsKey("Content-Type")) {
      headersCopy.put("Content-Type", "application/octet-stream");
    }

    return getRegionAsync(bucketName, region)
        .thenCompose(
            location -> {
              try {
                return executeAsync(
                    Method.POST,
                    bucketName,
                    objectName,
                    location,
                    httpHeaders(headersCopy),
                    queryParams,
                    null,
                    0);
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            })
        .thenApply(
            response -> {
              try {
                InitiateMultipartUploadResult result =
                    Xml.unmarshal(
                        InitiateMultipartUploadResult.class, response.body().charStream());
                return CreateMultipartUploadResponse(
                    response.headers(), bucketName, region, objectName, result);
              } catch (XmlParserException e) {
                throw CompletionException(e);
              } finally {
                response.close();
              }
            });
  }

  /**
   * Do <a
   * href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_CreateMultipartUpload.html">CreateMultipartUpload
   * S3 API</a>.
   *
   * @param bucketName Name of the bucket.
   * @param region Region name of buckets in S3 service.
   * @param objectName Object name in the bucket.
   * @param headers Request headers.
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link CreateMultipartUploadResponse} object.
   * @throws ErrorResponseException thrown to indicate S3 service returned an error response.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
   *     response.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   * @deprecated This method is no inter supported. Use {@link #createMultipartUploadAsync}.
   */
  @Deprecated
   CreateMultipartUploadResponse createMultipartUpload(
      String bucketName,
      String region,
      String objectName,
      Multimap<String, String> headers,
      Multimap<String, String> extraQueryParams)
{
    try {
      return createMultipartUploadAsync(bucketName, region, objectName, headers, extraQueryParams)
          .get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /**
   * Do <a
   * href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_DeleteObjects.html">DeleteObjects S3
   * API</a> asynchronously.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket (Optional).
   * @param objectList List of object names.
   * @param quiet Quiet flag.
   * @param bypassGovernanceMode Bypass Governance retention mode.
   * @param extraHeaders Extra headers for request (Optional).
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link CompletableFuture}&lt;{@link DeleteObjectsResponse}&gt; object.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   */
   CompletableFuture<DeleteObjectsResponse> deleteObjectsAsync(
      String bucketName,
      String region,
      List<DeleteObject> objectList,
      bool quiet,
      bool bypassGovernanceMode,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    if (objectList == null) objectList = LinkedList<>();

    if (objectList.size() > 1000) {
      throw ArgumentError("list of objects must not be more than 1000");
    }

    Multimap<String, String> headers =
        merge(
            extraHeaders,
            bypassGovernanceMode ? newMultimap("x-amz-bypass-governance-retention", "true") : null);

    final List<DeleteObject> objects = objectList;
    return getRegionAsync(bucketName, region)
        .thenCompose(
            location -> {
              try {
                return executeAsync(
                    Method.POST,
                    bucketName,
                    null,
                    location,
                    httpHeaders(headers),
                    merge(extraQueryParams, newMultimap("delete", "")),
                    DeleteRequest(objects, quiet),
                    0);
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            })
        .thenApply(
            response -> {
              try {
                String bodyContent = response.body().string();
                try {
                  if (Xml.validate(DeleteError.class, bodyContent)) {
                    DeleteError error = Xml.unmarshal(DeleteError.class, bodyContent);
                    DeleteResult result = DeleteResult(error);
                    return DeleteObjectsResponse(
                        response.headers(), bucketName, region, result);
                  }
                } catch (XmlParserException e) {
                  // Ignore this exception as it is not <Error> message,
                  // but parse it as <DeleteResult> message below.
                }

                DeleteResult result = Xml.unmarshal(DeleteResult.class, bodyContent);
                return DeleteObjectsResponse(response.headers(), bucketName, region, result);
              } catch (IOException | XmlParserException e) {
                throw CompletionException(e);
              } finally {
                response.close();
              }
            });
  }

  /**
   * Do <a
   * href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_DeleteObjects.html">DeleteObjects S3
   * API</a>.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket (Optional).
   * @param objectList List of object names.
   * @param quiet Quiet flag.
   * @param bypassGovernanceMode Bypass Governance retention mode.
   * @param extraHeaders Extra headers for request (Optional).
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link DeleteObjectsResponse} object.
   * @throws ErrorResponseException thrown to indicate S3 service returned an error response.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
   *     response.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   * @deprecated This method is no inter supported. Use {@link #deleteObjectsAsync}.
   */
  @Deprecated
   DeleteObjectsResponse deleteObjects(
      String bucketName,
      String region,
      List<DeleteObject> objectList,
      bool quiet,
      bool bypassGovernanceMode,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    try {
      return deleteObjectsAsync(
              bucketName,
              region,
              objectList,
              quiet,
              bypassGovernanceMode,
              extraHeaders,
              extraQueryParams)
          .get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /**
   * Do <a href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListObjects.html">ListObjects
   * version 1 S3 API</a> asynchronously.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket (Optional).
   * @param delimiter Delimiter (Optional).
   * @param encodingType Encoding type (Optional).
   * @param startAfter Fetch listing after this key (Optional).
   * @param maxKeys Maximum object information to fetch (Optional).
   * @param prefix Prefix (Optional).
   * @param continuationToken Continuation token (Optional).
   * @param fetchOwner Flag to fetch owner information (Optional).
   * @param includeUserMetadata MinIO extension flag to include user metadata (Optional).
   * @param extraHeaders Extra headers for request (Optional).
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link CompletableFuture}&lt;{@link ListObjectsV2Response}&gt; object.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   */
   CompletableFuture<ListObjectsV2Response> listObjectsV2Async(
      String bucketName,
      String region,
      String delimiter,
      String encodingType,
      String startAfter,
      Integer maxKeys,
      String prefix,
      String continuationToken,
      bool fetchOwner,
      bool includeUserMetadata,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    Multimap<String, String> queryParams =
        merge(
            extraQueryParams,
            getCommonListObjectsQueryParams(delimiter, encodingType, maxKeys, prefix));
    queryParams.put("list-type", "2");
    if (continuationToken != null) queryParams.put("continuation-token", continuationToken);
    if (fetchOwner) queryParams.put("fetch-owner", "true");
    if (startAfter != null) queryParams.put("start-after", startAfter);
    if (includeUserMetadata) queryParams.put("metadata", "true");

    return getRegionAsync(bucketName, region)
        .thenCompose(
            location -> {
              try {
                return executeAsync(
                    Method.GET,
                    bucketName,
                    null,
                    location,
                    httpHeaders(extraHeaders),
                    queryParams,
                    null,
                    0);
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            })
        .thenApply(
            response -> {
              try {
                ListBucketResultV2 result =
                    Xml.unmarshal(ListBucketResultV2.class, response.body().charStream());
                return ListObjectsV2Response(response.headers(), bucketName, region, result);
              } catch (XmlParserException e) {
                throw CompletionException(e);
              } finally {
                response.close();
              }
            });
  }

  /**
   * Do <a href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListObjects.html">ListObjects
   * version 1 S3 API</a>.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket (Optional).
   * @param delimiter Delimiter (Optional).
   * @param encodingType Encoding type (Optional).
   * @param startAfter Fetch listing after this key (Optional).
   * @param maxKeys Maximum object information to fetch (Optional).
   * @param prefix Prefix (Optional).
   * @param continuationToken Continuation token (Optional).
   * @param fetchOwner Flag to fetch owner information (Optional).
   * @param includeUserMetadata MinIO extension flag to include user metadata (Optional).
   * @param extraHeaders Extra headers for request (Optional).
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link ListObjectsV2Response} object.
   * @throws ErrorResponseException thrown to indicate S3 service returned an error response.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
   *     response.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   * @deprecated This method is no inter supported. Use {@link #listObjectsV2Async}.
   */
  @Deprecated
   ListObjectsV2Response listObjectsV2(
      String bucketName,
      String region,
      String delimiter,
      String encodingType,
      String startAfter,
      Integer maxKeys,
      String prefix,
      String continuationToken,
      bool fetchOwner,
      bool includeUserMetadata,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    try {
      return listObjectsV2Async(
              bucketName,
              region,
              delimiter,
              encodingType,
              startAfter,
              maxKeys,
              prefix,
              continuationToken,
              fetchOwner,
              includeUserMetadata,
              extraHeaders,
              extraQueryParams)
          .get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /**
   * Do <a href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListObjects.html">ListObjects
   * version 1 S3 API</a> asynchronously.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket (Optional).
   * @param delimiter Delimiter (Optional).
   * @param encodingType Encoding type (Optional).
   * @param marker Marker (Optional).
   * @param maxKeys Maximum object information to fetch (Optional).
   * @param prefix Prefix (Optional).
   * @param extraHeaders Extra headers for request (Optional).
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link CompletableFuture}&lt;{@link ListObjectsV1Response}&gt; object.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   */
   CompletableFuture<ListObjectsV1Response> listObjectsV1Async(
      String bucketName,
      String region,
      String delimiter,
      String encodingType,
      String marker,
      Integer maxKeys,
      String prefix,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    Multimap<String, String> queryParams =
        merge(
            extraQueryParams,
            getCommonListObjectsQueryParams(delimiter, encodingType, maxKeys, prefix));
    if (marker != null) queryParams.put("marker", marker);

    return getRegionAsync(bucketName, region)
        .thenCompose(
            location -> {
              try {
                return executeAsync(
                    Method.GET,
                    bucketName,
                    null,
                    location,
                    httpHeaders(extraHeaders),
                    queryParams,
                    null,
                    0);
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            })
        .thenApply(
            response -> {
              try {
                ListBucketResultV1 result =
                    Xml.unmarshal(ListBucketResultV1.class, response.body().charStream());
                return ListObjectsV1Response(response.headers(), bucketName, region, result);
              } catch (XmlParserException e) {
                throw CompletionException(e);
              } finally {
                response.close();
              }
            });
  }

  /**
   * Do <a href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListObjects.html">ListObjects
   * version 1 S3 API</a>.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket (Optional).
   * @param delimiter Delimiter (Optional).
   * @param encodingType Encoding type (Optional).
   * @param marker Marker (Optional).
   * @param maxKeys Maximum object information to fetch (Optional).
   * @param prefix Prefix (Optional).
   * @param extraHeaders Extra headers for request (Optional).
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link ListObjectsV1Response} object.
   * @throws ErrorResponseException thrown to indicate S3 service returned an error response.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
   *     response.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   * @deprecated This method is no inter supported. Use {@link #listObjectsV1Async}.
   */
  @Deprecated
   ListObjectsV1Response listObjectsV1(
      String bucketName,
      String region,
      String delimiter,
      String encodingType,
      String marker,
      Integer maxKeys,
      String prefix,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    try {
      return listObjectsV1Async(
              bucketName,
              region,
              delimiter,
              encodingType,
              marker,
              maxKeys,
              prefix,
              extraHeaders,
              extraQueryParams)
          .get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /**
   * Do <a
   * href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListObjectVersions.html">ListObjectVersions
   * API</a> asynchronously.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket (Optional).
   * @param delimiter Delimiter (Optional).
   * @param encodingType Encoding type (Optional).
   * @param keyMarker Key marker (Optional).
   * @param maxKeys Maximum object information to fetch (Optional).
   * @param prefix Prefix (Optional).
   * @param versionIdMarker Version ID marker (Optional).
   * @param extraHeaders Extra headers for request (Optional).
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link CompletableFuture}&lt;{@link ListObjectVersionsResponse}&gt; object.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   */
   CompletableFuture<ListObjectVersionsResponse> listObjectVersionsAsync(
      String bucketName,
      String region,
      String delimiter,
      String encodingType,
      String keyMarker,
      Integer maxKeys,
      String prefix,
      String versionIdMarker,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    Multimap<String, String> queryParams =
        merge(
            extraQueryParams,
            getCommonListObjectsQueryParams(delimiter, encodingType, maxKeys, prefix));
    if (keyMarker != null) queryParams.put("key-marker", keyMarker);
    if (versionIdMarker != null) queryParams.put("version-id-marker", versionIdMarker);
    queryParams.put("versions", "");

    return getRegionAsync(bucketName, region)
        .thenCompose(
            location -> {
              try {
                return executeAsync(
                    Method.GET,
                    bucketName,
                    null,
                    location,
                    httpHeaders(extraHeaders),
                    queryParams,
                    null,
                    0);
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            })
        .thenApply(
            response -> {
              try {
                ListVersionsResult result =
                    Xml.unmarshal(ListVersionsResult.class, response.body().charStream());
                return ListObjectVersionsResponse(
                    response.headers(), bucketName, region, result);
              } catch (XmlParserException e) {
                throw CompletionException(e);
              } finally {
                response.close();
              }
            });
  }

  /**
   * Do <a
   * href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListObjectVersions.html">ListObjectVersions
   * API</a>.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket (Optional).
   * @param delimiter Delimiter (Optional).
   * @param encodingType Encoding type (Optional).
   * @param keyMarker Key marker (Optional).
   * @param maxKeys Maximum object information to fetch (Optional).
   * @param prefix Prefix (Optional).
   * @param versionIdMarker Version ID marker (Optional).
   * @param extraHeaders Extra headers for request (Optional).
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link ListObjectVersionsResponse} object.
   * @throws ErrorResponseException thrown to indicate S3 service returned an error response.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
   *     response.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   * @deprecated This method is no inter supported. Use {@link #listObjectVersionsAsync}.
   */
  @Deprecated
   ListObjectVersionsResponse listObjectVersions(
      String bucketName,
      String region,
      String delimiter,
      String encodingType,
      String keyMarker,
      Integer maxKeys,
      String prefix,
      String versionIdMarker,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    try {
      return listObjectVersionsAsync(
              bucketName,
              region,
              delimiter,
              encodingType,
              keyMarker,
              maxKeys,
              prefix,
              versionIdMarker,
              extraHeaders,
              extraQueryParams)
          .get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

   Part[] uploadParts(
      PutObjectBaseArgs args, String uploadId, PartReader partReader, PartSource firstPartSource)
{
    Part[] parts = Part[ObjectWriteArgs.MAX_MULTIPART_COUNT];
    int partNumber = 0;
    PartSource partSource = firstPartSource;
    while (true) {
      partNumber++;

      Multimap<String, String> ssecHeaders = null;
      // set encryption headers in the case of SSE-C.
      if (args.sse() != null && args.sse() instanceof ServerSideEncryptionCustomerKey) {
        ssecHeaders = Multimaps.forMap(args.sse().headers());
      }

      UploadPartResponse response =
          uploadPartAsync(
                  args.bucket(),
                  args.region(),
                  args.object(),
                  partSource,
                  partNumber,
                  uploadId,
                  ssecHeaders,
                  null)
              .get();
      parts[partNumber - 1] = Part(partNumber, response.etag());

      partSource = partReader.getPart();
      if (partSource == null) break;
    }

    return parts;
  }

   CompletableFuture<ObjectWriteResponse> putMultipartObjectAsync(
      PutObjectBaseArgs args,
      Multimap<String, String> headers,
      PartReader partReader,
      PartSource firstPartSource)
{
    return CompletableFuture.supplyAsync(
        () -> {
          String uploadId = null;
          ObjectWriteResponse response = null;
          try {
            CreateMultipartUploadResponse createMultipartUploadResponse =
                createMultipartUploadAsync(
                        args.bucket(),
                        args.region(),
                        args.object(),
                        headers,
                        args.extraQueryParams())
                    .get();
            uploadId = createMultipartUploadResponse.result().uploadId();
            Part[] parts = uploadParts(args, uploadId, partReader, firstPartSource);
            response =
                completeMultipartUploadAsync(
                        args.bucket(), args.region(), args.object(), uploadId, parts, null, null)
                    .get();
          } catch (InsufficientDataException
              | InternalException
              | InvalidKeyException
              | IOException
              | NoSuchAlgorithmException
              | XmlParserException
              | InterruptedException
              | ExecutionException e) {
            if (uploadId == null) {
              Throwable throwable = e;
              if (throwable instanceof ExecutionException) {
                throwable = ((ExecutionException) throwable).getCause();
              }
              if (throwable instanceof CompletionException) {
                throwable = ((CompletionException) throwable).getCause();
              }
              throw CompletionException(throwable);
            }
            try {
              abortMultipartUploadAsync(
                      args.bucket(), args.region(), args.object(), uploadId, null, null)
                  .get();
            } catch (InsufficientDataException
                | InternalException
                | InvalidKeyException
                | IOException
                | NoSuchAlgorithmException
                | XmlParserException
                | InterruptedException
                | ExecutionException ex) {
              Throwable throwable = ex;
              if (throwable instanceof ExecutionException) {
                throwable = ((ExecutionException) throwable).getCause();
              }
              if (throwable instanceof CompletionException) {
                throwable = ((CompletionException) throwable).getCause();
              }
              throw CompletionException(throwable);
            }
          }
          return response;
        });
  }

  /**
   * Execute put object asynchronously from object data from {@link RandomAccessFile} or {@link
   * InputStream}.
   *
   * @param args {@link PutObjectBaseArgs}.
   * @param data {@link RandomAccessFile} or {@link InputStream}.
   * @param objectSize object size.
   * @param partSize part size for multipart upload.
   * @param partCount Number of parts for multipart upload.
   * @param contentType content-type of object.
   * @return {@link CompletableFuture}&lt;{@link ObjectWriteResponse}&gt; object.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   */
   CompletableFuture<ObjectWriteResponse> putObjectAsync(
      PutObjectBaseArgs args,
      Object data,
      int objectSize,
      int partSize,
      int partCount,
      String contentType)
{
    PartReader partReader = newPartReader(data, objectSize, partSize, partCount);
    if (partReader == null) {
      throw ArgumentError("data must be RandomAccessFile or InputStream");
    }

    Multimap<String, String> headers = newMultimap(args.extraHeaders());
    headers.putAll(args.genHeaders());
    if (!headers.containsKey("Content-Type")) headers.put("Content-Type", contentType);

    return CompletableFuture.supplyAsync(
            () -> {
              try {
                return partReader.getPart();
              } catch (NoSuchAlgorithmException | IOException e) {
                throw CompletionException(e);
              }
            })
        .thenCompose(
            partSource -> {
              try {
                if (partReader.partCount() == 1) {
                  return putObjectAsync(
                      args.bucket(),
                      args.region(),
                      args.object(),
                      partSource,
                      headers,
                      args.extraQueryParams());
                } else {
                  return putMultipartObjectAsync(args, headers, partReader, partSource);
                }
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            });
  }

  /**
   * Do <a href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutObject.html">PutObject S3
   * API</a> for {@link PartSource} asynchronously.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket (Optional).
   * @param objectName Object name in the bucket.
   * @param partSource PartSource object.
   * @param headers Additional headers.
   * @param extraQueryParams Additional query parameters if any.
   * @return {@link CompletableFuture}&lt;{@link ObjectWriteResponse}&gt; object.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   */
   CompletableFuture<ObjectWriteResponse> putObjectAsync(
      String bucketName,
      String region,
      String objectName,
      PartSource partSource,
      Multimap<String, String> headers,
      Multimap<String, String> extraQueryParams)
{
    return getRegionAsync(bucketName, region)
        .thenCompose(
            location -> {
              try {
                return executeAsync(
                    Method.PUT,
                    bucketName,
                    objectName,
                    location,
                    httpHeaders(headers),
                    extraQueryParams,
                    partSource,
                    0);
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            })
        .thenApply(
            response -> {
              try {
                return ObjectWriteResponse(
                    response.headers(),
                    bucketName,
                    region,
                    objectName,
                    response.header("ETag").replaceAll("\"", ""),
                    response.header("x-amz-version-id"));
              } finally {
                response.close();
              }
            });
  }

  /**
   * Do <a href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutObject.html">PutObject S3
   * API</a> asynchronously.
   *
   * @param bucketName Name of the bucket.
   * @param objectName Object name in the bucket.
   * @param data Object data must be InputStream, RandomAccessFile, byte[] or String.
   * @param length Length of object data.
   * @param headers Additional headers.
   * @param extraQueryParams Additional query parameters if any.
   * @return {@link CompletableFuture}&lt;{@link ObjectWriteResponse}&gt; object.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   */
   CompletableFuture<ObjectWriteResponse> putObjectAsync(
      String bucketName,
      String region,
      String objectName,
      Object data,
      int length,
      Multimap<String, String> headers,
      Multimap<String, String> extraQueryParams)
{
    if (!(data instanceof InputStream
        || data instanceof RandomAccessFile
        || data instanceof byte[]
        || data instanceof CharSequence)) {
      throw ArgumentError(
          "data must be InputStream, RandomAccessFile, byte[] or String");
    }

    PartReader partReader = newPartReader(data, length, length, 1);

    if (partReader != null) {
      return putObjectAsync(
          bucketName, region, objectName, partReader.getPart(), headers, extraQueryParams);
    }

    return getRegionAsync(bucketName, region)
        .thenCompose(
            location -> {
              try {
                return executeAsync(
                    Method.PUT,
                    bucketName,
                    objectName,
                    location,
                    httpHeaders(headers),
                    extraQueryParams,
                    data,
                    (int) length);
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            })
        .thenApply(
            response -> {
              try {
                return ObjectWriteResponse(
                    response.headers(),
                    bucketName,
                    region,
                    objectName,
                    response.header("ETag").replaceAll("\"", ""),
                    response.header("x-amz-version-id"));
              } finally {
                response.close();
              }
            });
  }

  /**
   * Do <a href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutObject.html">PutObject S3
   * API</a>.
   *
   * @param bucketName Name of the bucket.
   * @param objectName Object name in the bucket.
   * @param data Object data must be InputStream, RandomAccessFile, byte[] or String.
   * @param length Length of object data.
   * @param headers Additional headers.
   * @param extraQueryParams Additional query parameters if any.
   * @return {@link ObjectWriteResponse} object.
   * @throws ErrorResponseException thrown to indicate S3 service returned an error response.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
   *     response.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   * @deprecated This method is no inter supported. Use {@link #putObjectAsync}.
   */
  @Deprecated
   ObjectWriteResponse putObject(
      String bucketName,
      String region,
      String objectName,
      Object data,
      int length,
      Multimap<String, String> headers,
      Multimap<String, String> extraQueryParams)
{
    try {
      return putObjectAsync(bucketName, region, objectName, data, length, headers, extraQueryParams)
          .get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /**
   * Do <a
   * href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListMultipartUploads.html">ListMultipartUploads
   * S3 API</a> asynchronously.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket (Optional).
   * @param delimiter Delimiter (Optional).
   * @param encodingType Encoding type (Optional).
   * @param keyMarker Key marker (Optional).
   * @param maxUploads Maximum upload information to fetch (Optional).
   * @param prefix Prefix (Optional).
   * @param uploadIdMarker Upload ID marker (Optional).
   * @param extraHeaders Extra headers for request (Optional).
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link CompletableFuture}&lt;{@link ListMultipartUploadsResponse}&gt; object.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   */
   CompletableFuture<ListMultipartUploadsResponse> listMultipartUploadsAsync(
      String bucketName,
      String region,
      String delimiter,
      String encodingType,
      String keyMarker,
      Integer maxUploads,
      String prefix,
      String uploadIdMarker,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    Multimap<String, String> queryParams =
        merge(
            extraQueryParams,
            newMultimap(
                "uploads",
                "",
                "delimiter",
                (delimiter != null) ? delimiter : "",
                "max-uploads",
                (maxUploads != null) ? maxUploads.toString() : "1000",
                "prefix",
                (prefix != null) ? prefix : ""));
    if (encodingType != null) queryParams.put("encoding-type", encodingType);
    if (keyMarker != null) queryParams.put("key-marker", keyMarker);
    if (uploadIdMarker != null) queryParams.put("upload-id-marker", uploadIdMarker);

    return getRegionAsync(bucketName, region)
        .thenCompose(
            location -> {
              try {
                return executeAsync(
                    Method.GET,
                    bucketName,
                    null,
                    location,
                    httpHeaders(extraHeaders),
                    queryParams,
                    null,
                    0);
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            })
        .thenApply(
            response -> {
              try {
                ListMultipartUploadsResult result =
                    Xml.unmarshal(ListMultipartUploadsResult.class, response.body().charStream());
                return ListMultipartUploadsResponse(
                    response.headers(), bucketName, region, result);
              } catch (XmlParserException e) {
                throw CompletionException(e);
              } finally {
                response.close();
              }
            });
  }

  /**
   * Do <a
   * href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListMultipartUploads.html">ListMultipartUploads
   * S3 API</a>.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket (Optional).
   * @param delimiter Delimiter (Optional).
   * @param encodingType Encoding type (Optional).
   * @param keyMarker Key marker (Optional).
   * @param maxUploads Maximum upload information to fetch (Optional).
   * @param prefix Prefix (Optional).
   * @param uploadIdMarker Upload ID marker (Optional).
   * @param extraHeaders Extra headers for request (Optional).
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link ListMultipartUploadsResponse} object.
   * @throws ErrorResponseException thrown to indicate S3 service returned an error response.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
   *     response.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   * @deprecated This method is no inter supported. Use {@link #listMultipartUploadsAsync}.
   */
  @Deprecated
   ListMultipartUploadsResponse listMultipartUploads(
      String bucketName,
      String region,
      String delimiter,
      String encodingType,
      String keyMarker,
      Integer maxUploads,
      String prefix,
      String uploadIdMarker,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    try {
      return listMultipartUploadsAsync(
              bucketName,
              region,
              delimiter,
              encodingType,
              keyMarker,
              maxUploads,
              prefix,
              uploadIdMarker,
              extraHeaders,
              extraQueryParams)
          .get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /**
   * Do <a href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListParts.html">ListParts S3
   * API</a> asynchronously.
   *
   * @param bucketName Name of the bucket.
   * @param region Name of the bucket (Optional).
   * @param objectName Object name in the bucket.
   * @param maxParts Maximum parts information to fetch (Optional).
   * @param partNumberMarker Part number marker (Optional).
   * @param uploadId Upload ID.
   * @param extraHeaders Extra headers for request (Optional).
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link CompletableFuture}&lt;{@link ListPartsResponse}&gt; object.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   */
   CompletableFuture<ListPartsResponse> listPartsAsync(
      String bucketName,
      String region,
      String objectName,
      Integer maxParts,
      Integer partNumberMarker,
      String uploadId,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    Multimap<String, String> queryParams =
        merge(
            extraQueryParams,
            newMultimap(
                UPLOAD_ID,
                uploadId,
                "max-parts",
                (maxParts != null) ? maxParts.toString() : "1000"));
    if (partNumberMarker != null) {
      queryParams.put("part-number-marker", partNumberMarker.toString());
    }

    return getRegionAsync(bucketName, region)
        .thenCompose(
            location -> {
              try {
                return executeAsync(
                    Method.GET,
                    bucketName,
                    objectName,
                    location,
                    httpHeaders(extraHeaders),
                    queryParams,
                    null,
                    0);
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            })
        .thenApply(
            response -> {
              try {
                ListPartsResult result =
                    Xml.unmarshal(ListPartsResult.class, response.body().charStream());
                return ListPartsResponse(
                    response.headers(), bucketName, region, objectName, result);
              } catch (XmlParserException e) {
                throw CompletionException(e);
              } finally {
                response.close();
              }
            });
  }

  /**
   * Do <a href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListParts.html">ListParts S3
   * API</a>.
   *
   * @param bucketName Name of the bucket.
   * @param region Name of the bucket (Optional).
   * @param objectName Object name in the bucket.
   * @param maxParts Maximum parts information to fetch (Optional).
   * @param partNumberMarker Part number marker (Optional).
   * @param uploadId Upload ID.
   * @param extraHeaders Extra headers for request (Optional).
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link ListPartsResponse} object.
   * @throws ErrorResponseException thrown to indicate S3 service returned an error response.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
   *     response.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   * @deprecated This method is no inter supported. Use {@link #listPartsAsync}.
   */
  @Deprecated
   ListPartsResponse listParts(
      String bucketName,
      String region,
      String objectName,
      Integer maxParts,
      Integer partNumberMarker,
      String uploadId,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    try {
      return listPartsAsync(
              bucketName,
              region,
              objectName,
              maxParts,
              partNumberMarker,
              uploadId,
              extraHeaders,
              extraQueryParams)
          .get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /**
   * Do <a href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_UploadPart.html">UploadPart S3
   * API</a> for PartSource asynchronously.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket (Optional).
   * @param objectName Object name in the bucket.
   * @param partSource PartSource Object.
   * @param partNumber Part number.
   * @param uploadId Upload ID.
   * @param extraHeaders Extra headers for request (Optional).
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link CompletableFuture}&lt;{@link UploadPartResponse}&gt; object.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   */
   CompletableFuture<UploadPartResponse> uploadPartAsync(
      String bucketName,
      String region,
      String objectName,
      PartSource partSource,
      int partNumber,
      String uploadId,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    return getRegionAsync(bucketName, region)
        .thenCompose(
            location -> {
              try {
                return executeAsync(
                    Method.PUT,
                    bucketName,
                    objectName,
                    location,
                    httpHeaders(extraHeaders),
                    merge(
                        extraQueryParams,
                        newMultimap(
                            "partNumber", Integer.toString(partNumber), UPLOAD_ID, uploadId)),
                    partSource,
                    0);
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            })
        .thenApply(
            response -> {
              try {
                return UploadPartResponse(
                    response.headers(),
                    bucketName,
                    region,
                    objectName,
                    uploadId,
                    partNumber,
                    response.header("ETag").replaceAll("\"", ""));
              } finally {
                response.close();
              }
            });
  }

  /**
   * Do <a href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_UploadPart.html">UploadPart S3
   * API</a> asynchronously.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket (Optional).
   * @param objectName Object name in the bucket.
   * @param data Object data must be InputStream, RandomAccessFile, byte[] or String.
   * @param length Length of object data.
   * @param uploadId Upload ID.
   * @param partNumber Part number.
   * @param extraHeaders Extra headers for request (Optional).
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link CompletableFuture}&lt;{@link UploadPartResponse}&gt; object.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   */
   CompletableFuture<UploadPartResponse> uploadPartAsync(
      String bucketName,
      String region,
      String objectName,
      Object data,
      int length,
      String uploadId,
      int partNumber,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    if (!(data instanceof InputStream
        || data instanceof RandomAccessFile
        || data instanceof byte[]
        || data instanceof CharSequence)) {
      throw ArgumentError(
          "data must be InputStream, RandomAccessFile, byte[] or String");
    }

    PartReader partReader = newPartReader(data, length, length, 1);

    if (partReader != null) {
      return uploadPartAsync(
          bucketName,
          region,
          objectName,
          partReader.getPart(),
          partNumber,
          uploadId,
          extraHeaders,
          extraQueryParams);
    }

    return getRegionAsync(bucketName, region)
        .thenCompose(
            location -> {
              try {
                return executeAsync(
                    Method.PUT,
                    bucketName,
                    objectName,
                    location,
                    httpHeaders(extraHeaders),
                    merge(
                        extraQueryParams,
                        newMultimap(
                            "partNumber", Integer.toString(partNumber), UPLOAD_ID, uploadId)),
                    data,
                    (int) length);
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            })
        .thenApply(
            response -> {
              try {
                return UploadPartResponse(
                    response.headers(),
                    bucketName,
                    region,
                    objectName,
                    uploadId,
                    partNumber,
                    response.header("ETag").replaceAll("\"", ""));
              } finally {
                response.close();
              }
            });
  }

  /**
   * Do <a href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_UploadPart.html">UploadPart S3
   * API</a>.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket (Optional).
   * @param objectName Object name in the bucket.
   * @param data Object data must be InputStream, RandomAccessFile, byte[] or String.
   * @param length Length of object data.
   * @param uploadId Upload ID.
   * @param partNumber Part number.
   * @param extraHeaders Extra headers for request (Optional).
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link UploadPartResponse} object.
   * @throws ErrorResponseException thrown to indicate S3 service returned an error response.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
   *     response.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   * @deprecated This method is no inter supported. Use {@link #uploadPartAsync}.
   */
  @Deprecated
   UploadPartResponse uploadPart(
      String bucketName,
      String region,
      String objectName,
      Object data,
      int length,
      String uploadId,
      int partNumber,
      Multimap<String, String> extraHeaders,
      Multimap<String, String> extraQueryParams)
{
    try {
      return uploadPartAsync(
              bucketName,
              region,
              objectName,
              data,
              length,
              uploadId,
              partNumber,
              extraHeaders,
              extraQueryParams)
          .get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /**
   * Do <a
   * href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_UploadPartCopy.html">UploadPartCopy
   * S3 API</a>.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket (Optional).
   * @param objectName Object name in the bucket.
   * @param uploadId Upload ID.
   * @param partNumber Part number.
   * @param headers Request headers with source object definitions.
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link UploadPartCopyResponse} object.
   * @throws ErrorResponseException thrown to indicate S3 service returned an error response.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
   *     response.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   * @deprecated This method is no inter supported. Use {@link #uploadPartCopyAsync}.
   */
  @Deprecated
   UploadPartCopyResponse uploadPartCopy(
      String bucketName,
      String region,
      String objectName,
      String uploadId,
      int partNumber,
      Multimap<String, String> headers,
      Multimap<String, String> extraQueryParams)
{
    try {
      return uploadPartCopyAsync(
              bucketName, region, objectName, uploadId, partNumber, headers, extraQueryParams)
          .get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      throwEncapsulatedException(e);
      return null;
    }
  }

  /**
   * Do <a
   * href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_UploadPartCopy.html">UploadPartCopy
   * S3 API</a>.
   *
   * @param bucketName Name of the bucket.
   * @param region Region of the bucket (Optional).
   * @param objectName Object name in the bucket.
   * @param uploadId Upload ID.
   * @param partNumber Part number.
   * @param headers Request headers with source object definitions.
   * @param extraQueryParams Extra query parameters for request (Optional).
   * @return {@link CompletableFuture}&lt;{@link UploadPartCopyResponse}&gt; object.
   * @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
   * @throws InternalException thrown to indicate internal library error.
   * @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
   * @throws IOException thrown to indicate I/O error on S3 operation.
   * @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
   * @throws XmlParserException thrown to indicate XML parsing error.
   */
   CompletableFuture<UploadPartCopyResponse> uploadPartCopyAsync(
      String bucketName,
      String region,
      String objectName,
      String uploadId,
      int partNumber,
      Multimap<String, String> headers,
      Multimap<String, String> extraQueryParams)
{
    return getRegionAsync(bucketName, region)
        .thenCompose(
            location -> {
              try {
                return executeAsync(
                    Method.PUT,
                    bucketName,
                    objectName,
                    location,
                    httpHeaders(headers),
                    merge(
                        extraQueryParams,
                        newMultimap(
                            "partNumber", Integer.toString(partNumber), "uploadId", uploadId)),
                    null,
                    0);
              } catch (InsufficientDataException
                  | InternalException
                  | InvalidKeyException
                  | IOException
                  | NoSuchAlgorithmException
                  | XmlParserException e) {
                throw CompletionException(e);
              }
            })
        .thenApply(
            response -> {
              try {
                CopyPartResult result =
                    Xml.unmarshal(CopyPartResult.class, response.body().charStream());
                return UploadPartCopyResponse(
                    response.headers(),
                    bucketName,
                    region,
                    objectName,
                    uploadId,
                    partNumber,
                    result);
              } catch (XmlParserException e) {
                throw CompletionException(e);
              } finally {
                response.close();
              }
            });
  }
}
