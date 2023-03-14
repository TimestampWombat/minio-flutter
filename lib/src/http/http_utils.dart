import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'package:time/time.dart';

import 'package:minio_flutter/src/utils/internet_address.dart';
import '../errors/minio_exception.dart';

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

  static void validateNullOrNotEmptyString(String? arg, String argName) {
    if (arg != null && arg.isEmpty) {
      throw ArgumentError("$argName must be a non-empty string.");
    }
  }

  static void validateHostnameOrIPAddress(String endpoint) {
    // Check endpoint is IPv4 or IPv6.
    if (isValidAddress(endpoint)) {
      return;
    }

    // Check endpoint is a hostname.

    // Refer https://en.wikipedia.org/wiki/Hostname#Restrictions_on_valid_host_names
    // why checks are done like below
    if (endpoint.isEmpty || endpoint.length > 253) {
      throw ArgumentError("invalid hostname");
    }

    for (String label in endpoint.split(".")) {
      if (label.isEmpty || label.length > 63) {
        throw ArgumentError("invalid hostname");
      }

      final regExp = RegExp(r'^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$');
      if (!regExp.hasMatch(label)) {
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
    Uri? url;
    try {
      url = Uri.parse(endpoint);
    } catch (e) {}

    if (url == null) {
      validateHostnameOrIPAddress(endpoint);
      url = Uri(scheme: "https", host: endpoint);
    } else {
      validateUrl(url);
    }

    return url;
  }

  static String getHostHeader(Uri url) {
    String host = url.host;

    if (isValidIpv6(host)) {
      host = "[$host]";
    }

    // ignore port when port and service matches i.e HTTP -> 80, HTTPS -> 443
    if ((url.scheme == "http" && url.port == 80) ||
        (url.scheme == "https" && url.port == 443)) {
      return host;
    }

    return "$host:${url.port}";
  }

  /// copied logic from
  /// https://github.com/square/okhttp/blob/master/samples/guide/src/main/java/okhttp3/recipes/CustomTrust.java
  static SecurityContext enableExternalCertificates(String filename) {
    try {
      SecurityContext context = SecurityContext.defaultContext;
      context.useCertificateChain(filename, password: 'password');
      return context;
    } catch (e) {
      throw ArgumentError("expected non-empty set of trusted certificates");
    }
  }

  static http.Client newDefaultHttpClient(
      int connectTimeout, int writeTimeout, int readTimeout) {
    SecurityContext? context;
    String? filename = String.fromEnvironment("SSL_CERT_FILE");
    if (filename != null && filename.isNotEmpty) {
      try {
        context = enableExternalCertificates(filename);
      } catch (e) {
        throw RuntimeException('$e');
      }
    }

    HttpClient client = HttpClient(context: context);

    client.connectionTimeout = connectTimeout.milliseconds;
    // .connectTimeout(connectTimeout.milliseconds)
    // .writeTimeout(writeTimeout.milliseconds)
    // .readTimeout(readTimeout.milliseconds)
    // .protocols(Arrays.asList(Protocol.HTTP_1_1))
    // .build();
    return http.IOClient(client);
  }

  static http.Client disableCertCheck(http.Client client) {
    var ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    return http.IOClient(ioClient);
  }

// TODO: implement this
  static http.Client setTimeout(http.Client client, int connectTimeout,
      int writeTimeout, int readTimeout) {
    // return client
    //     .newBuilder()
    //     .connectTimeout(connectTimeout.milliseconds)
    //     .writeTimeout(writeTimeout.milliseconds)
    //     .readTimeout(readTimeout.milliseconds)
    //     .build();
    return http.IOClient(
        HttpClient()..connectionTimeout = connectTimeout.milliseconds);
  }
}
