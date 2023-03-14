import 'package:time/time.dart';

/// HTTP utilities.
 class HttpUtils {
   static final List<int> EMPTY_BODY = [];

   static void validateNotNull(Object? arg, String argName) {
    if (arg == null) {
      throw ArgumentError("$argName must not be null.");
    }
  }

   static void validateNotEmptyString(String arg, String argName) {
    validateNotNull(arg, argName);
    if (arg.isEmpty) {
      throw ArgumentError("$argName must be a non-empty string.");
    }
  }

   static void validateNullOrNotEmptyString(String arg, String argName) {
    if (arg != null && arg.isEmpty) {
      throw ArgumentError("$argName must be a non-empty string.");
    }
  }

   static void validateHostnameOrIPAddress(String endpoint) {
    // Check endpoint is IPv4 or IPv6.
    if (InetAddressValidator.getInstance().isValid(endpoint)) {
      return;
    }

    // Check endpoint is a hostname.

    // Refer https://en.wikipedia.org/wiki/Hostname#Restrictions_on_valid_host_names
    // why checks are done like below
    if (endpoint.isEmpty || endpoint.length > 253) {
      throw ArgumentError("invalid hostname");
    }

    for (String label in endpoint.split("\\.")) {
      if (label.isEmpty || label.length > 63) {
        throw ArgumentError("invalid hostname");
      }

      if (!(label.matches("^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$"))) {
        throw ArgumentError("invalid hostname");
      }
    }
  }

   static void validateUrl(Uri url) {
    if (url.path != "/") {
      throw ArgumentError("no path allowed in endpoint $url");
    }
  }

   static Uri getBaseUrl(String endpoint) {
    validateNotEmptyString(endpoint, "endpoint");
    Uri url = Uri.parse(endpoint);
    if (url == null) {
      validateHostnameOrIPAddress(endpoint);
      url = new Uri.Builder().scheme("https").host(endpoint).build();
    } else {
      validateUrl(url);
    }

    return url;
  }

   static String getHostHeader(Uri url) {
    String host = url.host;
    if (InetAddressValidator.getInstance().isValidInet6Address(host)) {
      host = "[$host]";
    }

    // ignore port when port and service matches i.e HTTP -> 80, HTTPS -> 443
    if ((url.scheme == "http" && url.port == 80)
        || (url.scheme == "https" && url.port == 443)) {
      return host;
    }

    return "$host:${url.port}";
  }

  /// copied logic from
  /// https://github.com/square/okhttp/blob/master/samples/guide/src/main/java/okhttp3/recipes/CustomTrust.java
   static OkHttpClient enableExternalCertificates(OkHttpClient httpClient, String filename)
       {
    Collection<? extends Certificate> certificates = null;
    try (FileInputStream fis = new FileInputStream(filename)) {
      certificates = CertificateFactory.getInstance("X.509").generateCertificates(fis);
    }

    if (certificates == null || certificates.isEmpty()) {
      throw ArgumentError("expected non-empty set of trusted certificates");
    }

    char[] password = "password".toCharArray(); // Any password will work.

    // Put the certificates a key store.
    KeyStore keyStore = KeyStore.getInstance(KeyStore.getDefaultType());
    // By convention, 'null' creates an empty key store.
    keyStore.load(null, password);

    int index = 0;
    for (Certificate certificate : certificates) {
      String certificateAlias = Integer.toString(index++);
      keyStore.setCertificateEntry(certificateAlias, certificate);
    }

    // Use it to build an X509 trust manager.
    KeyManagerFactory keyManagerFactory =
        KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
    keyManagerFactory.init(keyStore, password);
    TrustManagerFactory trustManagerFactory =
        TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
    trustManagerFactory.init(keyStore);

    final KeyManager[] keyManagers = keyManagerFactory.getKeyManagers();
    final TrustManager[] trustManagers = trustManagerFactory.getTrustManagers();

    SSLContext sslContext = SSLContext.getInstance("TLS");
    sslContext.init(keyManagers, trustManagers, null);
    SSLSocketFactory sslSocketFactory = sslContext.getSocketFactory();

    return httpClient
        .newBuilder()
        .sslSocketFactory(sslSocketFactory, (X509TrustManager) trustManagers[0])
        .build();
  }

   static OkHttpClient newDefaultHttpClient(
      int connectTimeout, int writeTimeout, int readTimeout) {
    OkHttpClient httpClient =
        new OkHttpClient()
            .newBuilder()
            .connectTimeout(connectTimeout.milliseconds)
            .writeTimeout(writeTimeout.milliseconds)
            .readTimeout(readTimeout.milliseconds)
            .protocols(Arrays.asList(Protocol.HTTP_1_1))
            .build();
    String filename = System.getenv("SSL_CERT_FILE");
    if (filename != null && !filename.isEmpty()) {
      try {
        httpClient = enableExternalCertificates(httpClient, filename);
      } catch (GeneralSecurityException | IOException e) {
        throw new RuntimeException(e);
      }
    }
    return httpClient;
  }

  @SuppressFBWarnings(value = "SIC", justification = "Should not be used in production anyways.")
   static OkHttpClient disableCertCheck(OkHttpClient client)
      throws KeyManagementException, NoSuchAlgorithmException {
    final TrustManager[] trustAllCerts =
        new TrustManager[] {
          new X509TrustManager() {
            @Override
             void checkClientTrusted(X509Certificate[] chain, String authType)
                throws CertificateException {}

            @Override
             void checkServerTrusted(X509Certificate[] chain, String authType)
                throws CertificateException {}

            @Override
             X509Certificate[] getAcceptedIssuers() {
              return new X509Certificate[] {};
            }
          }
        };

    final SSLContext sslContext = SSLContext.getInstance("SSL");
    sslContext.init(null, trustAllCerts, new java.security.SecureRandom());
    final SSLSocketFactory sslSocketFactory = sslContext.getSocketFactory();

    return client
        .newBuilder()
        .sslSocketFactory(sslSocketFactory, (X509TrustManager) trustAllCerts[0])
        .hostnameVerifier(
            new HostnameVerifier() {
              @Override
               boolean verify(String hostname, SSLSession session) {
                return true;
              }
            })
        .build();
  }

   static OkHttpClient setTimeout(
      OkHttpClient client, int connectTimeout, int writeTimeout, int readTimeout) {
    return client
        .newBuilder()
        .connectTimeout(connectTimeout.milliseconds)
        .writeTimeout(writeTimeout.milliseconds)
        .readTimeout(readTimeout.milliseconds)
        .build();
  }
}
