import 'minio_async_client.dart';
import 'stat_object_args.dart';
import 'stat_object_response.dart';

/// Simple Storage Service (aka S3) client to perform bucket and object operations.
///
/// <h2>Bucket operations</h2>
///
/// <ul>
///   <li>Create, list and delete buckets.
///   <li>Put, get and delete bucket lifecycle configuration.
///   <li>Put, get and delete bucket policy configuration.
///   <li>Put, get and delete bucket encryption configuration.
///   <li>Put and get bucket default retention configuration.
///   <li>Put and get bucket notification configuration.
///   <li>Enable and disable bucket versioning.
/// </ul>
///
/// <h2>Object operations</h2>
///
/// <ul>
///   <li>Put, get, delete and list objects.
///   <li>Create objects by combining existing objects.
///   <li>Put and get object retention and legal hold.
///   <li>Filter object content by SQL statement.
/// </ul>
///
/// <p>If access/secret keys are provided, all S3 operation requests are signed using AWS Signature
/// Version 4; else they are performed anonymously.
///
/// <p>Examples on using this library are available <a
/// href="https://github.com/minio/minio-java/tree/master/src/test/java/io/minio/examples">here</a>.
///
/// <p>Use {@code MinioClient.builder()} to create S3 client.
///
/// <pre>{@code
/// // Create client with anonymous access.
/// MinioClient minioClient = MinioClient.builder().endpoint("https://play.min.io").build();
///
/// // Create client with credentials.
/// MinioClient minioClient =
///     MinioClient.builder()
///         .endpoint("https://play.min.io")
///         .credentials("Q3AM3UQ867SPQQA43P2F", "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG")
///         .build();
/// }</pre>
 class MinioClient {
   MinioAsyncClient? asyncClient = null;

   MinioClient.async(this.asyncClient);

   MinioClient(MinioClient client):
    this.asyncClient = client.asyncClient;
  

  /// Gets information of an object.
  ///
  /// <pre>Example:{@code
  /// // Get information of an object.
  /// StatObjectResponse stat =
  ///     minioClient.statObject(
  ///         StatObjectArgs.builder().bucket("my-bucketname").object("my-objectname").build());
  ///
  /// // Get information of SSE-C encrypted object.
  /// StatObjectResponse stat =
  ///     minioClient.statObject(
  ///         StatObjectArgs.builder()
  ///             .bucket("my-bucketname")
  ///             .object("my-objectname")
  ///             .ssec(ssec)
  ///             .build());
  ///
  /// // Get information of a versioned object.
  /// StatObjectResponse stat =
  ///     minioClient.statObject(
  ///         StatObjectArgs.builder()
  ///             .bucket("my-bucketname")
  ///             .object("my-objectname")
  ///             .versionId("version-id")
  ///             .build());
  ///
  /// // Get information of a SSE-C encrypted versioned object.
  /// StatObjectResponse stat =
  ///     minioClient.statObject(
  ///         StatObjectArgs.builder()
  ///             .bucket("my-bucketname")
  ///             .object("my-objectname")
  ///             .versionId("version-id")
  ///             .ssec(ssec)
  ///             .build());
  /// }</pre>
  ///
  /// @param args {@link StatObjectArgs} object.
  /// @return {@link StatObjectResponse} - Populated object information and metadata.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
  /// @see StatObjectResponse
   StatObjectResponse? statObject(StatObjectArgs args)
       {
    try {
      return asyncClient.statObject(args).get();
    } 
    // on InterruptedException catch ( e) {
    //   throw RuntimeException(e);
    // } on ExecutionException
    catch ( e) {
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Gets data from offset to length of a SSE-C encrypted object. Returned {@link InputStream} must
  /// be closed after use to release network resources.
  ///
  /// <pre>Example:{@code
  /// try (InputStream stream =
  ///     minioClient.getObject(
  ///   GetObjectArgs.builder()
  ///     .bucket("my-bucketname")
  ///     .object("my-objectname")
  ///     .offset(offset)
  ///     .length(len)
  ///     .ssec(ssec)
  ///     .build()
  /// ) {
  ///   // Read data from stream
  /// }
  /// }</pre>
  ///
  /// @param args Object of {@link GetObjectArgs}
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   GetObjectResponse? getObject(GetObjectArgs args)
       {
    try {
      return asyncClient.getObject(args).get();
    // } catch (InterruptedException e) {
    //   throw RuntimeException(e);
    // } catch (ExecutionException e) {
    }catch(e){
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Downloads data of a SSE-C encrypted object to file.
  ///
  /// <pre>Example:{@code
  /// minioClient.downloadObject(
  ///   DownloadObjectArgs.builder()
  ///     .bucket("my-bucketname")
  ///     .object("my-objectname")
  ///     .ssec(ssec)
  ///     .filename("my-filename")
  ///     .build());
  /// }</pre>
  ///
  /// @param args Object of {@link DownloadObjectArgs}
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void downloadObject(DownloadObjectArgs args)
      {
    try {
      asyncClient.downloadObject(args).get();
    // } catch (InterruptedException e) {
    //   throw RuntimeException(e);
    // } catch (ExecutionException e) {
    }catch(e){
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Creates an object by server-side copying data from another object.
  ///
  /// <pre>Example:{@code
  /// // Create object "my-objectname" in bucket "my-bucketname" by copying from object
  /// // "my-objectname" in bucket "my-source-bucketname".
  /// minioClient.copyObject(
  ///     CopyObjectArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .object("my-objectname")
  ///         .source(
  ///             CopySource.builder()
  ///                 .bucket("my-source-bucketname")
  ///                 .object("my-objectname")
  ///                 .build())
  ///         .build());
  ///
  /// // Create object "my-objectname" in bucket "my-bucketname" by copying from object
  /// // "my-source-objectname" in bucket "my-source-bucketname".
  /// minioClient.copyObject(
  ///     CopyObjectArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .object("my-objectname")
  ///         .source(
  ///             CopySource.builder()
  ///                 .bucket("my-source-bucketname")
  ///                 .object("my-source-objectname")
  ///                 .build())
  ///         .build());
  ///
  /// // Create object "my-objectname" in bucket "my-bucketname" with SSE-KMS server-side
  /// // encryption by copying from object "my-objectname" in bucket "my-source-bucketname".
  /// minioClient.copyObject(
  ///     CopyObjectArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .object("my-objectname")
  ///         .source(
  ///             CopySource.builder()
  ///                 .bucket("my-source-bucketname")
  ///                 .object("my-objectname")
  ///                 .build())
  ///         .sse(sseKms) // Replace with actual key.
  ///         .build());
  ///
  /// // Create object "my-objectname" in bucket "my-bucketname" with SSE-S3 server-side
  /// // encryption by copying from object "my-objectname" in bucket "my-source-bucketname".
  /// minioClient.copyObject(
  ///     CopyObjectArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .object("my-objectname")
  ///         .source(
  ///             CopySource.builder()
  ///                 .bucket("my-source-bucketname")
  ///                 .object("my-objectname")
  ///                 .build())
  ///         .sse(sseS3) // Replace with actual key.
  ///         .build());
  ///
  /// // Create object "my-objectname" in bucket "my-bucketname" with SSE-C server-side encryption
  /// // by copying from object "my-objectname" in bucket "my-source-bucketname".
  /// minioClient.copyObject(
  ///     CopyObjectArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .object("my-objectname")
  ///         .source(
  ///             CopySource.builder()
  ///                 .bucket("my-source-bucketname")
  ///                 .object("my-objectname")
  ///                 .build())
  ///         .sse(ssec) // Replace with actual key.
  ///         .build());
  ///
  /// // Create object "my-objectname" in bucket "my-bucketname" by copying from SSE-C encrypted
  /// // object "my-source-objectname" in bucket "my-source-bucketname".
  /// minioClient.copyObject(
  ///     CopyObjectArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .object("my-objectname")
  ///         .source(
  ///             CopySource.builder()
  ///                 .bucket("my-source-bucketname")
  ///                 .object("my-source-objectname")
  ///                 .ssec(ssec) // Replace with actual key.
  ///                 .build())
  ///         .build());
  ///
  /// // Create object "my-objectname" in bucket "my-bucketname" with custom headers conditionally
  /// // by copying from object "my-objectname" in bucket "my-source-bucketname".
  /// minioClient.copyObject(
  ///     CopyObjectArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .object("my-objectname")
  ///         .source(
  ///             CopySource.builder()
  ///                 .bucket("my-source-bucketname")
  ///                 .object("my-objectname")
  ///                 .matchETag(etag) // Replace with actual etag.
  ///                 .build())
  ///         .headers(headers) // Replace with actual headers.
  ///         .build());
  /// }</pre>
  ///
  /// @param args {@link CopyObjectArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   ObjectWriteResponse? copyObject(CopyObjectArgs args)
       {
    try {
      return asyncClient.copyObject(args).get();
    // } catch (InterruptedException e) {
    //   throw RuntimeException(e);
    // } catch (ExecutionException e) {
    } catch ( e) {
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Creates an object by combining data from different source objects using server-side copy.
  ///
  /// <pre>Example:{@code
  /// List<ComposeSource> sourceObjectList = ArrayList<ComposeSource>();
  ///
  /// sourceObjectList.add(
  ///    ComposeSource.builder().bucket("my-job-bucket").object("my-objectname-part-one").build());
  /// sourceObjectList.add(
  ///    ComposeSource.builder().bucket("my-job-bucket").object("my-objectname-part-two").build());
  /// sourceObjectList.add(
  ///    ComposeSource.builder().bucket("my-job-bucket").object("my-objectname-part-three").build());
  ///
  /// // Create my-bucketname/my-objectname by combining source object list.
  /// minioClient.composeObject(
  ///    ComposeObjectArgs.builder()
  ///        .bucket("my-bucketname")
  ///        .object("my-objectname")
  ///        .sources(sourceObjectList)
  ///        .build());
  ///
  /// // Create my-bucketname/my-objectname with user metadata by combining source object
  /// // list.
  /// Map<String, String> userMetadata = HashMap<>();
  /// userMetadata.put("My-Project", "Project One");
  /// minioClient.composeObject(
  ///     ComposeObjectArgs.builder()
  ///        .bucket("my-bucketname")
  ///        .object("my-objectname")
  ///        .sources(sourceObjectList)
  ///        .userMetadata(userMetadata)
  ///        .build());
  ///
  /// // Create my-bucketname/my-objectname with user metadata and server-side encryption
  /// // by combining source object list.
  /// minioClient.composeObject(
  ///   ComposeObjectArgs.builder()
  ///        .bucket("my-bucketname")
  ///        .object("my-objectname")
  ///        .sources(sourceObjectList)
  ///        .userMetadata(userMetadata)
  ///        .ssec(sse)
  ///        .build());
  /// }</pre>
  ///
  /// @param args {@link ComposeObjectArgs} object.
  /// @return {@link ObjectWriteResponse} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   ObjectWriteResponse? composeObject(ComposeObjectArgs args)
      {
    try {
      return asyncClient.composeObject(args).get();
    // } catch (InterruptedException e) {
    //   throw RuntimeException(e);
    // } catch (ExecutionException e) {
    } catch ( e) {
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Gets presigned URL of an object for HTTP method, expiry time and custom request parameters.
  ///
  /// <pre>Example:{@code
  /// // Get presigned URL string to delete 'my-objectname' in 'my-bucketname' and its life time
  /// // is one day.
  /// String url =
  ///    minioClient.getPresignedObjectUrl(
  ///        GetPresignedObjectUrlArgs.builder()
  ///            .method(Method.DELETE)
  ///            .bucket("my-bucketname")
  ///            .object("my-objectname")
  ///            .expiry(24 * 60 * 60)
  ///            .build());
  /// System.out.println(url);
  ///
  /// // Get presigned URL string to upload 'my-objectname' in 'my-bucketname'
  /// // with response-content-type as application/json and life time as one day.
  /// Map<String, String> reqParams = HashMap<String, String>();
  /// reqParams.put("response-content-type", "application/json");
  ///
  /// String url =
  ///    minioClient.getPresignedObjectUrl(
  ///        GetPresignedObjectUrlArgs.builder()
  ///            .method(Method.PUT)
  ///            .bucket("my-bucketname")
  ///            .object("my-objectname")
  ///            .expiry(1, TimeUnit.DAYS)
  ///            .extraQueryParams(reqParams)
  ///            .build());
  /// System.out.println(url);
  ///
  /// // Get presigned URL string to download 'my-objectname' in 'my-bucketname' and its life time
  /// // is 2 hours.
  /// String url =
  ///    minioClient.getPresignedObjectUrl(
  ///        GetPresignedObjectUrlArgs.builder()
  ///            .method(Method.GET)
  ///            .bucket("my-bucketname")
  ///            .object("my-objectname")
  ///            .expiry(2, TimeUnit.HOURS)
  ///            .build());
  /// System.out.println(url);
  /// }</pre>
  ///
  /// @param args {@link GetPresignedObjectUrlArgs} object.
  /// @return String - URL string.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
  /// @throws ServerException
   String getPresignedObjectUrl(GetPresignedObjectUrlArgs args)
      {
    return asyncClient.getPresignedObjectUrl(args);
  }

  /// Gets form-data of {@link PostPolicy} of an object to upload its data using POST method.
  ///
  /// <pre>Example:{@code
  /// // Create post policy for 'my-bucketname' with 7 days expiry from now.
  /// PostPolicy policy = PostPolicy("my-bucketname", ZonedDateTime.now().plusDays(7));
  ///
  /// // Add condition that 'key' (object name) equals to 'my-objectname'.
  /// policy.addEqualsCondition("key", "my-objectname");
  ///
  /// // Add condition that 'Content-Type' starts with 'image/'.
  /// policy.addStartsWithCondition("Content-Type", "image/");
  ///
  /// // Add condition that 'content-length-range' is between 64kiB to 10MiB.
  /// policy.addContentLengthRangeCondition(64 * 1024, 10 * 1024 * 1024);
  ///
  /// Map<String, String> formData = minioClient.getPresignedPostFormData(policy);
  ///
  /// // Upload an image using POST object with form-data.
  /// MultipartBody.Builder multipartBuilder = MultipartBody.Builder();
  /// multipartBuilder.setType(MultipartBody.FORM);
  /// for (Map.Entry<String, String> entry : formData.entrySet()) {
  ///   multipartBuilder.addFormDataPart(entry.getKey(), entry.getValue());
  /// }
  /// multipartBuilder.addFormDataPart("key", "my-objectname");
  /// multipartBuilder.addFormDataPart("Content-Type", "image/png");
  ///
  /// // "file" must be added at last.
  /// multipartBuilder.addFormDataPart(
  ///     "file", "my-objectname", RequestBody.create(File("Pictures/avatar.png"), null));
  ///
  /// Request request =
  ///     Request.Builder()
  ///         .url("https://play.min.io/my-bucketname")
  ///         .post(multipartBuilder.build())
  ///         .build();
  /// OkHttpClient httpClient = OkHttpClient().newBuilder().build();
  /// Response response = httpClient.newCall(request).execute();
  /// if (response.isSuccessful()) {
  ///   System.out.println("Pictures/avatar.png is uploaded successfully using POST object");
  /// } else {
  ///   System.out.println("Failed to upload Pictures/avatar.png");
  /// }
  /// }</pre>
  ///
  /// @param policy Post policy of an object.
  /// @return {@code Map<String, String>} - Contains form-data to upload an object using POST method.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
  /// @see PostPolicy
   Map<String, String> getPresignedPostFormData(PostPolicy policy)
      {
    return asyncClient.getPresignedPostFormData(policy);
  }

  /// Removes an object.
  ///
  /// <pre>Example:{@code
  /// // Remove object.
  /// minioClient.removeObject(
  ///     RemoveObjectArgs.builder().bucket("my-bucketname").object("my-objectname").build());
  ///
  /// // Remove versioned object.
  /// minioClient.removeObject(
  ///     RemoveObjectArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .object("my-versioned-objectname")
  ///         .versionId("my-versionid")
  ///         .build());
  ///
  /// // Remove versioned object bypassing Governance mode.
  /// minioClient.removeObject(
  ///     RemoveObjectArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .object("my-versioned-objectname")
  ///         .versionId("my-versionid")
  ///         .bypassRetentionMode(true)
  ///         .build());
  /// }</pre>
  ///
  /// @param args {@link RemoveObjectArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void removeObject(RemoveObjectArgs args)
     {
    try {
      asyncClient.removeObject(args).get();
    // } catch (InterruptedException e) {
    //   throw RuntimeException(e);
    // } catch (ExecutionException e) {
    }catch(e){
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Removes multiple objects lazily. Its required to iterate the returned Iterable to perform
  /// removal.
  ///
  /// <pre>Example:{@code
  /// List<DeleteObject> objects = LinkedList<>();
  /// objects.add(DeleteObject("my-objectname1"));
  /// objects.add(DeleteObject("my-objectname2"));
  /// objects.add(DeleteObject("my-objectname3"));
  /// Iterable<Result<DeleteError>> results =
  ///     minioClient.removeObjects(
  ///         RemoveObjectsArgs.builder().bucket("my-bucketname").objects(objects).build());
  /// for (Result<DeleteError> result : results) {
  ///   DeleteError error = errorResult.get();
  ///   System.out.println(
  ///       "Error in deleting object " + error.objectName() + "; " + error.message());
  /// }
  /// }</pre>
  ///
  /// @param args {@link RemoveObjectsArgs} object.
  /// @return {@code Iterable<Result<DeleteError>>} - Lazy iterator contains object removal status.
   Iterable<Result<DeleteError>> removeObjects(RemoveObjectsArgs args) {
    return asyncClient.removeObjects(args);
  }

  /// Restores an object.
  ///
  /// <pre>Example:{@code
  /// // Restore object.
  /// minioClient.restoreObject(
  ///     RestoreObjectArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .object("my-objectname")
  ///         .request(RestoreRequest(null, null, null, null, null, null))
  ///         .build());
  ///
  /// // Restore versioned object.
  /// minioClient.restoreObject(
  ///     RestoreObjectArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .object("my-versioned-objectname")
  ///         .versionId("my-versionid")
  ///         .request(RestoreRequest(null, null, null, null, null, null))
  ///         .build());
  /// }</pre>
  ///
  /// @param args {@link RestoreObjectArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void restoreObject(RestoreObjectArgs args)
      // throws ErrorResponseException, InsufficientDataException, InternalException,
      //     InvalidKeyException, InvalidResponseException, IOException, NoSuchAlgorithmException,
      //     ServerException, XmlParserException {
    try {
      asyncClient.restoreObject(args).get();
    // } catch (InterruptedException e) {
    //   throw RuntimeException(e);
    // } catch (ExecutionException e) {
    }catch(e){
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Lists objects information optionally with versions of a bucket. Supports both the versions 1
  /// and 2 of the S3 API. By default, the <a
  /// href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListObjectsV2.html">version 2</a> API
  /// is used. <br>
  /// <a href="https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListObjects.html">Version 1</a>
  /// can be used by passing the optional argument {@code useVersion1} as {@code true}.
  ///
  /// <pre>Example:{@code
  /// // Lists objects information.
  /// Iterable<Result<Item>> results = minioClient.listObjects(
  ///     ListObjectsArgs.builder().bucket("my-bucketname").build());
  ///
  /// // Lists objects information recursively.
  /// Iterable<Result<Item>> results = minioClient.listObjects(
  ///     ListObjectsArgs.builder().bucket("my-bucketname").recursive(true).build());
  ///
  /// // Lists maximum 100 objects information whose names starts with 'E' and after
  /// // 'ExampleGuide.pdf'.
  /// Iterable<Result<Item>> results = minioClient.listObjects(
  ///     ListObjectsArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .startAfter("ExampleGuide.pdf")
  ///         .prefix("E")
  ///         .maxKeys(100)
  ///         .build());
  ///
  /// // Lists maximum 100 objects information with version whose names starts with 'E' and after
  /// // 'ExampleGuide.pdf'.
  /// Iterable<Result<Item>> results = minioClient.listObjects(
  ///     ListObjectsArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .startAfter("ExampleGuide.pdf")
  ///         .prefix("E")
  ///         .maxKeys(100)
  ///         .includeVersions(true)
  ///         .build());
  /// }</pre>
  ///
  /// @param args Instance of {@link ListObjectsArgs} built using the builder
  /// @return {@code Iterable<Result<Item>>} - Lazy iterator contains object information.
  /// @throws XmlParserException upon parsing response xml
   Iterable<Result<Item>> listObjects(ListObjectsArgs args) {
    return asyncClient.listObjects(args);
  }

  /// Lists bucket information of all buckets.
  ///
  /// <pre>Example:{@code
  /// List<Bucket> bucketList = minioClient.listBuckets();
  /// for (Bucket bucket : bucketList) {
  ///   System.out.println(bucket.creationDate() + ", " + bucket.name());
  /// }
  /// }</pre>
  ///
  /// @return {@code List<Bucket>} - List of bucket information.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   List<Bucket>? listBuckets()
       {
    try {
      return asyncClient.listBuckets().get();
    // } catch (InterruptedException e) {
    //   throw RuntimeException(e);
    // } catch (ExecutionException e) {
    }catch(e){
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Lists bucket information of all buckets.
  ///
  /// <pre>Example:{@code
  /// List<Bucket> bucketList =
  ///     minioClient.listBuckets(ListBucketsArgs.builder().extraHeaders(headers).build());
  /// for (Bucket bucket : bucketList) {
  ///   System.out.println(bucket.creationDate() + ", " + bucket.name());
  /// }
  /// }</pre>
  ///
  /// @return {@code List<Bucket>} - List of bucket information.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   List<Bucket> listBuckets(ListBucketsArgs args)
      {
    try {
      return asyncClient.listBuckets(args).get();
    // } catch (InterruptedException e) {
    //   throw RuntimeException(e);
    // } catch (ExecutionException e) {
    }catch(e){
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Checks if a bucket exists.
  ///
  /// <pre>Example:{@code
  /// boolean found =
  ///      minioClient.bucketExists(BucketExistsArgs.builder().bucket("my-bucketname").build());
  /// if (found) {
  ///   System.out.println("my-bucketname exists");
  /// } else {
  ///   System.out.println("my-bucketname does not exist");
  /// }
  /// }</pre>
  ///
  /// @param args {@link BucketExistsArgs} object.
  /// @return boolean - True if the bucket exists.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   bool bucketExists(BucketExistsArgs args)
       {
    try {
      return asyncClient.bucketExists(args).get();
    // } catch (InterruptedException e) {
    //   throw RuntimeException(e);
    // } catch (ExecutionException e) {
    }catch(e){
      asyncClient.throwEncapsulatedException(e);
      return false;
    }
  }

  /// Creates a bucket with region and object lock.
  ///
  /// <pre>Example:{@code
  /// // Create bucket with default region.
  /// minioClient.makeBucket(
  ///     MakeBucketArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .build());
  ///
  /// // Create bucket with specific region.
  /// minioClient.makeBucket(
  ///     MakeBucketArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .region("us-west-1")
  ///         .build());
  ///
  /// // Create object-lock enabled bucket with specific region.
  /// minioClient.makeBucket(
  ///     MakeBucketArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .region("us-west-1")
  ///         .objectLock(true)
  ///         .build());
  /// }</pre>
  ///
  /// @param args Object with bucket name, region and lock functionality
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void makeBucket(MakeBucketArgs args)
      {
    try {
      asyncClient.makeBucket(args).get();
    // } catch (InterruptedException e) {
    //   throw RuntimeException(e);
    // } catch (ExecutionException e) {
    }catch(e){
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Sets versioning configuration of a bucket.
  ///
  /// <pre>Example:{@code
  /// minioClient.setBucketVersioning(
  ///     SetBucketVersioningArgs.builder().bucket("my-bucketname").config(config).build());
  /// }</pre>
  ///
  /// @param args {@link SetBucketVersioningArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void setBucketVersioning(SetBucketVersioningArgs args)
{
    try {
      asyncClient.setBucketVersioning(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Gets versioning configuration of a bucket.
  ///
  /// <pre>Example:{@code
  /// VersioningConfiguration config =
  ///     minioClient.getBucketVersioning(
  ///         GetBucketVersioningArgs.builder().bucket("my-bucketname").build());
  /// }</pre>
  ///
  /// @param args {@link GetBucketVersioningArgs} object.
  /// @return {@link VersioningConfiguration} - Versioning configuration.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   VersioningConfiguration getBucketVersioning(GetBucketVersioningArgs args)
{
    try {
      return asyncClient.getBucketVersioning(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Sets default object retention in a bucket.
  ///
  /// <pre>Example:{@code
  /// ObjectLockConfiguration config = ObjectLockConfiguration(
  ///     RetentionMode.COMPLIANCE, RetentionDurationDays(100));
  /// minioClient.setObjectLockConfiguration(
  ///     SetObjectLockConfigurationArgs.builder().bucket("my-bucketname").config(config).build());
  /// }</pre>
  ///
  /// @param args {@link SetObjectLockConfigurationArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void setObjectLockConfiguration(SetObjectLockConfigurationArgs args)
{
    try {
      asyncClient.setObjectLockConfiguration(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Deletes default object retention in a bucket.
  ///
  /// <pre>Example:{@code
  /// minioClient.deleteObjectLockConfiguration(
  ///     DeleteObjectLockConfigurationArgs.builder().bucket("my-bucketname").build());
  /// }</pre>
  ///
  /// @param args {@link DeleteObjectLockConfigurationArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void deleteObjectLockConfiguration(DeleteObjectLockConfigurationArgs args)
{
    try {
      asyncClient.deleteObjectLockConfiguration(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Gets default object retention in a bucket.
  ///
  /// <pre>Example:{@code
  /// ObjectLockConfiguration config =
  ///     minioClient.getObjectLockConfiguration(
  ///         GetObjectLockConfigurationArgs.builder().bucket("my-bucketname").build());
  /// System.out.println("Mode: " + config.mode());
  /// System.out.println(
  ///     "Duration: " + config.duration().duration() + " " + config.duration().unit());
  /// }</pre>
  ///
  /// @param args {@link GetObjectLockConfigurationArgs} object.
  /// @return {@link ObjectLockConfiguration} - Default retention configuration.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   ObjectLockConfiguration getObjectLockConfiguration(GetObjectLockConfigurationArgs args)
{
    try {
      return asyncClient.getObjectLockConfiguration(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Sets retention configuration to an object.
  ///
  /// <pre>Example:{@code
  ///  Retention retention = Retention(
  ///       RetentionMode.COMPLIANCE, ZonedDateTime.now().plusYears(1));
  ///  minioClient.setObjectRetention(
  ///      SetObjectRetentionArgs.builder()
  ///          .bucket("my-bucketname")
  ///          .object("my-objectname")
  ///          .config(config)
  ///          .bypassGovernanceMode(true)
  ///          .build());
  /// }</pre>
  ///
  /// @param args {@link SetObjectRetentionArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void setObjectRetention(SetObjectRetentionArgs args)
{
    try {
      asyncClient.setObjectRetention(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Gets retention configuration of an object.
  ///
  /// <pre>Example:{@code
  /// Retention retention =
  ///     minioClient.getObjectRetention(GetObjectRetentionArgs.builder()
  ///        .bucket(bucketName)
  ///        .object(objectName)
  ///        .versionId(versionId)
  ///        .build()););
  /// System.out.println(
  ///     "mode: " + retention.mode() + "until: " + retention.retainUntilDate());
  /// }</pre>
  ///
  /// @param args {@link GetObjectRetentionArgs} object.
  /// @return {@link Retention} - Object retention configuration.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   Retention getObjectRetention(GetObjectRetentionArgs args)
{
    try {
      return asyncClient.getObjectRetention(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Enables legal hold on an object.
  ///
  /// <pre>Example:{@code
  /// minioClient.enableObjectLegalHold(
  ///    EnableObjectLegalHoldArgs.builder()
  ///        .bucket("my-bucketname")
  ///        .object("my-objectname")
  ///        .versionId("object-versionId")
  ///        .build());
  /// }</pre>
  ///
  /// @param args {@link EnableObjectLegalHoldArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void enableObjectLegalHold(EnableObjectLegalHoldArgs args)
{
    try {
      asyncClient.enableObjectLegalHold(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Disables legal hold on an object.
  ///
  /// <pre>Example:{@code
  /// minioClient.disableObjectLegalHold(
  ///    DisableObjectLegalHoldArgs.builder()
  ///        .bucket("my-bucketname")
  ///        .object("my-objectname")
  ///        .versionId("object-versionId")
  ///        .build());
  /// }</pre>
  ///
  /// @param args {@link DisableObjectLegalHoldArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void disableObjectLegalHold(DisableObjectLegalHoldArgs args)
{
    try {
      asyncClient.disableObjectLegalHold(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Returns true if legal hold is enabled on an object.
  ///
  /// <pre>Example:{@code
  /// boolean status =
  ///     s3Client.isObjectLegalHoldEnabled(
  ///        IsObjectLegalHoldEnabledArgs.builder()
  ///             .bucket("my-bucketname")
  ///             .object("my-objectname")
  ///             .versionId("object-versionId")
  ///             .build());
  /// if (status) {
  ///   System.out.println("Legal hold is on");
  ///  } else {
  ///   System.out.println("Legal hold is off");
  ///  }
  /// }</pre>
  ///
  /// args {@link IsObjectLegalHoldEnabledArgs} object.
  ///
  /// @return boolean - True if legal hold is enabled.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   boolean isObjectLegalHoldEnabled(IsObjectLegalHoldEnabledArgs args)
{
    try {
      return asyncClient.isObjectLegalHoldEnabled(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
      return false;
    }
  }

  /// Removes an empty bucket using arguments
  ///
  /// <pre>Example:{@code
  /// minioClient.removeBucket(RemoveBucketArgs.builder().bucket("my-bucketname").build());
  /// }</pre>
  ///
  /// @param args {@link RemoveBucketArgs} bucket.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void removeBucket(RemoveBucketArgs args)
{
    try {
      asyncClient.removeBucket(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Uploads data from a stream to an object.
  ///
  /// <pre>Example:{@code
  /// // Upload known sized input stream.
  /// minioClient.putObject(
  ///     PutObjectArgs.builder().bucket("my-bucketname").object("my-objectname").stream(
  ///             inputStream, size, -1)
  ///         .contentType("video/mp4")
  ///         .build());
  ///
  /// // Upload unknown sized input stream.
  /// minioClient.putObject(
  ///     PutObjectArgs.builder().bucket("my-bucketname").object("my-objectname").stream(
  ///             inputStream, -1, 10485760)
  ///         .contentType("video/mp4")
  ///         .build());
  ///
  /// // Create object ends with '/' (also called as folder or directory).
  /// minioClient.putObject(
  ///     PutObjectArgs.builder().bucket("my-bucketname").object("path/to/").stream(
  ///             ByteArrayInputStream(byte[] {}), 0, -1)
  ///         .build());
  ///
  /// // Upload input stream with headers and user metadata.
  /// Map<String, String> headers = HashMap<>();
  /// headers.put("X-Amz-Storage-Class", "REDUCED_REDUNDANCY");
  /// Map<String, String> userMetadata = HashMap<>();
  /// userMetadata.put("My-Project", "Project One");
  /// minioClient.putObject(
  ///     PutObjectArgs.builder().bucket("my-bucketname").object("my-objectname").stream(
  ///             inputStream, size, -1)
  ///         .headers(headers)
  ///         .userMetadata(userMetadata)
  ///         .build());
  ///
  /// // Upload input stream with server-side encryption.
  /// minioClient.putObject(
  ///     PutObjectArgs.builder().bucket("my-bucketname").object("my-objectname").stream(
  ///             inputStream, size, -1)
  ///         .sse(sse)
  ///         .build());
  /// }</pre>
  ///
  /// @param args {@link PutObjectArgs} object.
  /// @return {@link ObjectWriteResponse} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   ObjectWriteResponse putObject(PutObjectArgs args)
{
    try {
      return asyncClient.putObject(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Uploads data from a file to an object.
  ///
  /// <pre>Example:{@code
  /// // Upload an JSON file.
  /// minioClient.uploadObject(
  ///     UploadObjectArgs.builder()
  ///         .bucket("my-bucketname").object("my-objectname").filename("person.json").build());
  ///
  /// // Upload a video file.
  /// minioClient.uploadObject(
  ///     UploadObjectArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .object("my-objectname")
  ///         .filename("my-video.avi")
  ///         .contentType("video/mp4")
  ///         .build());
  /// }</pre>
  ///
  /// @param args {@link UploadObjectArgs} object.
  /// @return {@link ObjectWriteResponse} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   ObjectWriteResponse uploadObject(UploadObjectArgs args)
{
    try {
      return asyncClient.uploadObject(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Gets bucket policy configuration of a bucket.
  ///
  /// <pre>Example:{@code
  /// String config =
  ///     minioClient.getBucketPolicy(GetBucketPolicyArgs.builder().bucket("my-bucketname").build());
  /// }</pre>
  ///
  /// @param args {@link GetBucketPolicyArgs} object.
  /// @return String - Bucket policy configuration as JSON string.
  /// @throws BucketPolicyTooLargeException thrown to indicate returned bucket policy is too large.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   String getBucketPolicy(GetBucketPolicyArgs args)
{
    try {
      return asyncClient.getBucketPolicy(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
      return "";
    }
  }

  /// Sets bucket policy configuration to a bucket.
  ///
  /// <pre>Example:{@code
  /// // Assume policyJson contains below JSON string;
  /// // {
  /// //     "Statement": [
  /// //         {
  /// //             "Action": [
  /// //                 "s3:GetBucketLocation",
  /// //                 "s3:ListBucket"
  /// //             ],
  /// //             "Effect": "Allow",
  /// //             "Principal": "*",
  /// //             "Resource": "arn:aws:s3:::my-bucketname"
  /// //         },
  /// //         {
  /// //             "Action": "s3:GetObject",
  /// //             "Effect": "Allow",
  /// //             "Principal": "*",
  /// //             "Resource": "arn:aws:s3:::my-bucketname/myobject*"
  /// //         }
  /// //     ],
  /// //     "Version": "2012-10-17"
  /// // }
  /// //
  /// minioClient.setBucketPolicy(
  ///     SetBucketPolicyArgs.builder().bucket("my-bucketname").config(policyJson).build());
  /// }</pre>
  ///
  /// @param args {@link SetBucketPolicyArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void setBucketPolicy(SetBucketPolicyArgs args)
{
    try {
      asyncClient.setBucketPolicy(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Deletes bucket policy configuration to a bucket.
  ///
  /// <pre>Example:{@code
  /// minioClient.deleteBucketPolicy(DeleteBucketPolicyArgs.builder().bucket("my-bucketname"));
  /// }</pre>
  ///
  /// @param args {@link DeleteBucketPolicyArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void deleteBucketPolicy(DeleteBucketPolicyArgs args)
{
    try {
      asyncClient.deleteBucketPolicy(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Sets lifecycle configuration to a bucket.
  ///
  /// <pre>Example:{@code
  /// List<LifecycleRule> rules = LinkedList<>();
  /// rules.add(
  ///     LifecycleRule(
  ///         Status.ENABLED,
  ///         null,
  ///         Expiration((ZonedDateTime) null, 365, null),
  ///         RuleFilter("logs/"),
  ///         "rule2",
  ///         null,
  ///         null,
  ///         null));
  /// LifecycleConfiguration config = LifecycleConfiguration(rules);
  /// minioClient.setBucketLifecycle(
  ///     SetBucketLifecycleArgs.builder().bucket("my-bucketname").config(config).build());
  /// }</pre>
  ///
  /// @param args {@link SetBucketLifecycleArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void setBucketLifecycle(SetBucketLifecycleArgs args)
{
    try {
      asyncClient.setBucketLifecycle(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Deletes lifecycle configuration of a bucket.
  ///
  /// <pre>Example:{@code
  /// deleteBucketLifecycle(DeleteBucketLifecycleArgs.builder().bucket("my-bucketname").build());
  /// }</pre>
  ///
  /// @param args {@link DeleteBucketLifecycleArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void deleteBucketLifecycle(DeleteBucketLifecycleArgs args)
{
    try {
      asyncClient.deleteBucketLifecycle(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Gets lifecycle configuration of a bucket.
  ///
  /// <pre>Example:{@code
  /// LifecycleConfiguration config =
  ///     minioClient.getBucketLifecycle(
  ///         GetBucketLifecycleArgs.builder().bucket("my-bucketname").build());
  /// }</pre>
  ///
  /// @param args {@link GetBucketLifecycleArgs} object.
  /// @return {@link LifecycleConfiguration} object.
  /// @return String - Life cycle configuration as XML string.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   LifecycleConfiguration getBucketLifecycle(GetBucketLifecycleArgs args)
{
    try {
      return asyncClient.getBucketLifecycle(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Gets notification configuration of a bucket.
  ///
  /// <pre>Example:{@code
  /// NotificationConfiguration config =
  ///     minioClient.getBucketNotification(
  ///         GetBucketNotificationArgs.builder().bucket("my-bucketname").build());
  /// }</pre>
  ///
  /// @param args {@link GetBucketNotificationArgs} object.
  /// @return {@link NotificationConfiguration} - Notification configuration.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   NotificationConfiguration getBucketNotification(GetBucketNotificationArgs args)
{
    try {
      return asyncClient.getBucketNotification(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Sets notification configuration to a bucket.
  ///
  /// <pre>Example:{@code
  /// List<EventType> eventList = LinkedList<>();
  /// eventList.add(EventType.OBJECT_CREATED_PUT);
  /// eventList.add(EventType.OBJECT_CREATED_COPY);
  ///
  /// QueueConfiguration queueConfiguration = QueueConfiguration();
  /// queueConfiguration.setQueue("arn:minio:sqs::1:webhook");
  /// queueConfiguration.setEvents(eventList);
  /// queueConfiguration.setPrefixRule("images");
  /// queueConfiguration.setSuffixRule("pg");
  ///
  /// List<QueueConfiguration> queueConfigurationList = LinkedList<>();
  /// queueConfigurationList.add(queueConfiguration);
  ///
  /// NotificationConfiguration config = NotificationConfiguration();
  /// config.setQueueConfigurationList(queueConfigurationList);
  ///
  /// minioClient.setBucketNotification(
  ///     SetBucketNotificationArgs.builder().bucket("my-bucketname").config(config).build());
  /// }</pre>
  ///
  /// @param args {@link SetBucketNotificationArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void setBucketNotification(SetBucketNotificationArgs args)
{
    try {
      asyncClient.setBucketNotification(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Deletes notification configuration of a bucket.
  ///
  /// <pre>Example:{@code
  /// minioClient.deleteBucketNotification(
  ///     DeleteBucketNotificationArgs.builder().bucket("my-bucketname").build());
  /// }</pre>
  ///
  /// @param args {@link DeleteBucketNotificationArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void deleteBucketNotification(DeleteBucketNotificationArgs args)
{
    try {
      asyncClient.deleteBucketNotification(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Gets bucket replication configuration of a bucket.
  ///
  /// <pre>Example:{@code
  /// ReplicationConfiguration config =
  ///     minioClient.getBucketReplication(
  ///         GetBucketReplicationArgs.builder().bucket("my-bucketname").build());
  /// }</pre>
  ///
  /// @param args {@link GetBucketReplicationArgs} object.
  /// @return {@link ReplicationConfiguration} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   ReplicationConfiguration getBucketReplication(GetBucketReplicationArgs args)
{
    try {
      return asyncClient.getBucketReplication(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Sets bucket replication configuration to a bucket.
  ///
  /// <pre>Example:{@code
  /// Map<String, String> tags = HashMap<>();
  /// tags.put("key1", "value1");
  /// tags.put("key2", "value2");
  ///
  /// ReplicationRule rule =
  ///     ReplicationRule(
  ///         DeleteMarkerReplication(Status.DISABLED),
  ///         ReplicationDestination(
  ///             null, null, "REPLACE-WITH-ACTUAL-DESTINATION-BUCKET-ARN", null, null, null, null),
  ///         null,
  ///         RuleFilter(AndOperator("TaxDocs", tags)),
  ///         "rule1",
  ///         null,
  ///         1,
  ///         null,
  ///         Status.ENABLED);
  ///
  /// List<ReplicationRule> rules = LinkedList<>();
  /// rules.add(rule);
  ///
  /// ReplicationConfiguration config =
  ///     ReplicationConfiguration("REPLACE-WITH-ACTUAL-ROLE", rules);
  ///
  /// minioClient.setBucketReplication(
  ///     SetBucketReplicationArgs.builder().bucket("my-bucketname").config(config).build());
  /// }</pre>
  ///
  /// @param args {@link SetBucketReplicationArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void setBucketReplication(SetBucketReplicationArgs args)
{
    try {
      asyncClient.setBucketReplication(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Deletes bucket replication configuration from a bucket.
  ///
  /// <pre>Example:{@code
  /// minioClient.deleteBucketReplication(
  ///     DeleteBucketReplicationArgs.builder().bucket("my-bucketname"));
  /// }</pre>
  ///
  /// @param args {@link DeleteBucketReplicationArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void deleteBucketReplication(DeleteBucketReplicationArgs args)
{
    try {
      asyncClient.deleteBucketReplication(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Listens events of object prefix and suffix of a bucket. The returned closable iterator is
  /// lazily evaluated hence its required to iterate to get records and must be used with
  /// try-with-resource to release underneath network resources.
  ///
  /// <pre>Example:{@code
  /// String[] events = {"s3:ObjectCreated:*", "s3:ObjectAccessed:*"};
  /// try (CloseableIterator<Result<NotificationRecords>> ci =
  ///     minioClient.listenBucketNotification(
  ///         ListenBucketNotificationArgs.builder()
  ///             .bucket("bucketName")
  ///             .prefix("")
  ///             .suffix("")
  ///             .events(events)
  ///             .build())) {
  ///   while (ci.hasNext()) {
  ///     NotificationRecords records = ci.next().get();
  ///     for (Event event : records.events()) {
  ///       System.out.println("Event " + event.eventType() + " occurred at "
  ///           + event.eventTime() + " for " + event.bucketName() + "/"
  ///           + event.objectName());
  ///     }
  ///   }
  /// }
  /// }</pre>
  ///
  /// @param args {@link ListenBucketNotificationArgs} object.
  /// @return {@code CloseableIterator<Result<NotificationRecords>>} - Lazy closable iterator
  ///     contains event records.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   CloseableIterator<Result<NotificationRecords>> listenBucketNotification(
      ListenBucketNotificationArgs args)
{
    return asyncClient.listenBucketNotification(args);
  }

  /// Selects content of an object by SQL expression.
  ///
  /// <pre>Example:{@code
  /// String sqlExpression = "select * from S3Object";
  /// InputSerialization is =
  ///     InputSerialization(null, false, null, null, FileHeaderInfo.USE, null, null,
  ///         null);
  /// OutputSerialization os =
  ///     OutputSerialization(null, null, null, QuoteFields.ASNEEDED, null);
  /// SelectResponseStream stream =
  ///     minioClient.selectObjectContent(
  ///       SelectObjectContentArgs.builder()
  ///       .bucket("my-bucketname")
  ///       .object("my-objectname")
  ///       .sqlExpression(sqlExpression)
  ///       .inputSerialization(is)
  ///       .outputSerialization(os)
  ///       .requestProgress(true)
  ///       .build());
  ///
  /// byte[] buf = byte[512];
  /// int bytesRead = stream.read(buf, 0, buf.length);
  /// System.out.println(String(buf, 0, bytesRead, StandardCharsets.UTF_8));
  ///
  /// Stats stats = stream.stats();
  /// System.out.println("bytes scanned: " + stats.bytesScanned());
  /// System.out.println("bytes processed: " + stats.bytesProcessed());
  /// System.out.println("bytes returned: " + stats.bytesReturned());
  ///
  /// stream.close();
  /// }</pre>
  ///
  /// @param args instance of {@link SelectObjectContentArgs}
  /// @return {@link SelectResponseStream} - Contains filtered records and progress.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   SelectResponseStream selectObjectContent(SelectObjectContentArgs args)
{
    return asyncClient.selectObjectContent(args);
  }

  /// Sets encryption configuration of a bucket.
  ///
  /// <pre>Example:{@code
  /// minioClient.setBucketEncryption(
  ///     SetBucketEncryptionArgs.builder().bucket("my-bucketname").config(config).build());
  /// }</pre>
  ///
  /// @param args {@link SetBucketEncryptionArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void setBucketEncryption(SetBucketEncryptionArgs args)
{
    try {
      asyncClient.setBucketEncryption(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Gets encryption configuration of a bucket.
  ///
  /// <pre>Example:{@code
  /// SseConfiguration config =
  ///     minioClient.getBucketEncryption(
  ///         GetBucketEncryptionArgs.builder().bucket("my-bucketname").build());
  /// }</pre>
  ///
  /// @param args {@link GetBucketEncryptionArgs} object.
  /// @return {@link SseConfiguration} - Server-side encryption configuration.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   SseConfiguration getBucketEncryption(GetBucketEncryptionArgs args)
{
    try {
      return asyncClient.getBucketEncryption(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Deletes encryption configuration of a bucket.
  ///
  /// <pre>Example:{@code
  /// minioClient.deleteBucketEncryption(
  ///     DeleteBucketEncryptionArgs.builder().bucket("my-bucketname").build());
  /// }</pre>
  ///
  /// @param args {@link DeleteBucketEncryptionArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void deleteBucketEncryption(DeleteBucketEncryptionArgs args)
{
    try {
      asyncClient.deleteBucketEncryption(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Gets tags of a bucket.
  ///
  /// <pre>Example:{@code
  /// Tags tags =
  ///     minioClient.getBucketTags(GetBucketTagsArgs.builder().bucket("my-bucketname").build());
  /// }</pre>
  ///
  /// @param args {@link GetBucketTagsArgs} object.
  /// @return {@link Tags} - Tags.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   Tags getBucketTags(GetBucketTagsArgs args)
{
    try {
      return asyncClient.getBucketTags(args).get();
    } catch (InterruptedException e) {
      throw RuntimeException(e);
    } catch (ExecutionException e) {
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Sets tags to a bucket.
  ///
  /// <pre>Example:{@code
  /// Map<String, String> map = HashMap<>();
  /// map.put("Project", "Project One");
  /// map.put("User", "jsmith");
  /// minioClient.setBucketTags(
  ///     SetBucketTagsArgs.builder().bucket("my-bucketname").tags(map).build());
  /// }</pre>
  ///
  /// @param args {@link SetBucketTagsArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void setBucketTags(SetBucketTagsArgs args)
       {
    try {
      asyncClient.setBucketTags(args).get();
    // } catch (InterruptedException e) {
    //   throw RuntimeException(e);
    // } catch (ExecutionException e) {
    }catch(e){
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Deletes tags of a bucket.
  ///
  /// <pre>Example:{@code
  /// minioClient.deleteBucketTags(DeleteBucketTagsArgs.builder().bucket("my-bucketname").build());
  /// }</pre>
  ///
  /// @param args {@link DeleteBucketTagsArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void deleteBucketTags(DeleteBucketTagsArgs args)
      {
    try {
      asyncClient.deleteBucketTags(args).get();
    // } catch (InterruptedException e) {
    //   throw RuntimeException(e);
    // } catch (ExecutionException e) {
    }catch(e){
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Gets tags of an object.
  ///
  /// <pre>Example:{@code
  /// Tags tags =
  ///     minioClient.getObjectTags(
  ///         GetObjectTagsArgs.builder().bucket("my-bucketname").object("my-objectname").build());
  /// }</pre>
  ///
  /// @param args {@link GetObjectTagsArgs} object.
  /// @return {@link Tags} - Tags.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   Tags getObjectTags(GetObjectTagsArgs args)
       {
    try {
      return asyncClient.getObjectTags(args).get();
    // } catch (InterruptedException e) {
    //   throw RuntimeException(e);
    // } catch (ExecutionException e) {
    }catch(e){
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Sets tags to an object.
  ///
  /// <pre>Example:{@code
  /// Map<String, String> map = HashMap<>();
  /// map.put("Project", "Project One");
  /// map.put("User", "jsmith");
  /// minioClient.setObjectTags(
  ///     SetObjectTagsArgs.builder()
  ///         .bucket("my-bucketname")
  ///         .object("my-objectname")
  ///         .tags((map)
  ///         .build());
  /// }</pre>
  ///
  /// @param args {@link SetObjectTagsArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void setObjectTags(SetObjectTagsArgs args)
      {
    try {
      asyncClient.setObjectTags(args).get();
    // } catch (InterruptedException e) {
    //   throw RuntimeException(e);
    // } catch (ExecutionException e) {
    }catch(e){
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Deletes tags of an object.
  ///
  /// <pre>Example:{@code
  /// minioClient.deleteObjectTags(
  ///     DeleteObjectTags.builder().bucket("my-bucketname").object("my-objectname").build());
  /// }</pre>
  ///
  /// @param args {@link DeleteObjectTagsArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   void deleteObjectTags(DeleteObjectTagsArgs args)
       {
    try {
      asyncClient.deleteObjectTags(args).get();
    // } catch (InterruptedException e) {
    //   throw RuntimeException(e);
    // } catch (ExecutionException e) {
     } catch(e) {
      asyncClient.throwEncapsulatedException(e);
    }
  }

  /// Uploads multiple objects in a single put call. It is done by creating intermediate TAR file
  /// optionally compressed which is uploaded to S3 service.
  ///
  /// <pre>Example:{@code
  /// // Upload snowball objects.
  /// List<SnowballObject> objects = ArrayList<SnowballObject>();
  /// objects.add(
  ///     SnowballObject(
  ///         "my-object-one",
  ///         ByteArrayInputStream("hello".getBytes(StandardCharsets.UTF_8)),
  ///         5,
  ///         null));
  /// objects.add(
  ///     SnowballObject(
  ///         "my-object-two",
  ///         ByteArrayInputStream("java".getBytes(StandardCharsets.UTF_8)),
  ///         4,
  ///         null));
  /// minioClient.uploadSnowballObjects(
  ///     UploadSnowballObjectsArgs.builder().bucket("my-bucketname").objects(objects).build());
  /// }</pre>
  ///
  /// @param args {@link UploadSnowballObjectsArgs} object.
  /// @throws ErrorResponseException thrown to indicate S3 service returned an error response.
  /// @throws InsufficientDataException thrown to indicate not enough data available in InputStream.
  /// @throws InternalException thrown to indicate internal library error.
  /// @throws InvalidKeyException thrown to indicate missing of HMAC SHA-256 library.
  /// @throws InvalidResponseException thrown to indicate S3 service returned invalid or no error
  ///     response.
  /// @throws IOException thrown to indicate I/O error on S3 operation.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of MD5 or SHA-256 digest library.
  /// @throws XmlParserException thrown to indicate XML parsing error.
   ObjectWriteResponse uploadSnowballObjects(UploadSnowballObjectsArgs args)
       {
    try {
      return asyncClient.uploadSnowballObjects(args).get();
    // } catch (InterruptedException e) {
    //   throw RuntimeException(e);
    // } catch (ExecutionException e) {
    }catch(e){
      asyncClient.throwEncapsulatedException(e);
      return null;
    }
  }

  /// Sets HTTP connect, write and read timeouts. A value of 0 means no timeout, otherwise values
  /// must be between 1 and Integer.MAX_VALUE when converted to milliseconds.
  ///
  /// <pre>Example:{@code
  /// minioClient.setTimeout(TimeUnit.SECONDS.toMillis(10), TimeUnit.SECONDS.toMillis(10),
  ///     TimeUnit.SECONDS.toMillis(30));
  /// }</pre>
  ///
  /// @param connectTimeout HTTP connect timeout in milliseconds.
  /// @param writeTimeout HTTP write timeout in milliseconds.
  /// @param readTimeout HTTP read timeout in milliseconds.
   void setTimeout(int connectTimeout, int writeTimeout, int readTimeout) {
    asyncClient.setTimeout(connectTimeout, writeTimeout, readTimeout);
  }

  /// Ignores check on server certificate for HTTPS connection.
  ///
  /// <pre>Example:{@code
  /// minioClient.ignoreCertCheck();
  /// }</pre>
  ///
  /// @throws KeyManagementException thrown to indicate key management error.
  /// @throws NoSuchAlgorithmException thrown to indicate missing of SSL library.
  @SuppressFBWarnings(value = "SIC", justification = "Should not be used in production anyways.")
   void ignoreCertCheck()  {
    asyncClient.ignoreCertCheck();
  }

  /// Sets application's name/version to user agent. For more information about user agent refer <a
  /// href="http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html">#rfc2616</a>.
  ///
  /// @param name Your application name.
  /// @param version Your application version.
   void setAppInfo(String name, String version) {
    asyncClient.setAppInfo(name, version);
  }

  /// Enables HTTP call tracing and written to traceStream.
  ///
  /// @param traceStream {@link OutputStream} for writing HTTP call tracing.
  /// @see #traceOff
   void traceOn(OutputStream traceStream) {
    asyncClient.traceOn(traceStream);
  }

  /// Disables HTTP call tracing previously enabled.
  ///
  /// @see #traceOn
  /// @throws IOException upon connection error
   void traceOff()  {
    asyncClient.traceOff();
  }

  /// Enables accelerate endpoint for Amazon S3 endpoint.
   void enableAccelerateEndpoint() {
    asyncClient.enableAccelerateEndpoint();
  }

  /// Disables accelerate endpoint for Amazon S3 endpoint.
   void disableAccelerateEndpoint() {
    asyncClient.disableAccelerateEndpoint();
  }

  /// Enables dual-stack endpoint for Amazon S3 endpoint.
   void enableDualStackEndpoint() {
    asyncClient.enableDualStackEndpoint();
  }

  /// Disables dual-stack endpoint for Amazon S3 endpoint.
   void disableDualStackEndpoint() {
    asyncClient.disableDualStackEndpoint();
  }

  /// Enables virtual-style endpoint.
   void enableVirtualStyleEndpoint() {
    asyncClient.enableVirtualStyleEndpoint();
  }

  /// Disables virtual-style endpoint.
   void disableVirtualStyleEndpoint() {
    asyncClient.disableVirtualStyleEndpoint();
  }

   static Builder builder() {
    return Builder();
  }

  /** Argument builder of {@link MinioClient}. */
   static final class Builder {
     MinioAsyncClient.Builder asyncClientBuilder = null;

     Builder() {
      asyncClientBuilder = MinioAsyncClient.builder();
    }

     Builder endpoint(String endpoint) {
      asyncClientBuilder.endpoint(endpoint);
      return this;
    }

     Builder endpoint(String endpoint, int port, boolean secure) {
      asyncClientBuilder.endpoint(endpoint, port, secure);
      return this;
    }

     Builder endpoint(URL url) {
      asyncClientBuilder.endpoint(url);
      return this;
    }

     Builder endpoint(HttpUrl url) {
      asyncClientBuilder.endpoint(url);
      return this;
    }

     Builder region(String region) {
      asyncClientBuilder.region(region);
      return this;
    }

     Builder credentials(String accessKey, String secretKey) {
      asyncClientBuilder.credentials(accessKey, secretKey);
      return this;
    }

     Builder credentialsProvider(Provider provider) {
      asyncClientBuilder.credentialsProvider(provider);
      return this;
    }

     Builder httpClient(OkHttpClient httpClient) {
      asyncClientBuilder.httpClient(httpClient);
      return this;
    }

     MinioClient build() {
      MinioAsyncClient asyncClient = asyncClientBuilder.build();
      return MinioClient(asyncClient);
    }
  }
}
