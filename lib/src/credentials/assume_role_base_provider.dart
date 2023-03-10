import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'package:time/time.dart';
import 'package:xml2json/xml2json.dart';

import 'package:minio_flutter/src/errors/minio_exception.dart';
import 'package:minio_flutter/src/utils/responsex.dart';
import '../utils/http_url.dart' as HttpUrl;
import 'credentials.dart';
import 'provider.dart';

abstract class AssumeRoleBaseProvider implements Provider {
  static final int DEFAULT_DURATION_SECONDS = 1.hours.inSeconds;
  late final http.Client httpClient;
  Credentials? credentials;
  final Xml2Json xml2Json = Xml2Json();

  AssumeRoleBaseProvider(
      [http.Client? client, SecurityContext? securityContext]) {
    if (client != null) {
      if (securityContext != null) {
        throw ArgumentError(
            "Either securityContext or custom HTTP client must be provided");
      }
      httpClient = client;
    } else {
      if (securityContext == null) {
        throw ArgumentError("securityContext must be provided");
      }
      httpClient = http.IOClient(HttpClient(context: securityContext));
    }
  }

  AssumeRoleBaseProvider.customSSL(
      http.Client? customHttpClient, SecurityContext securityContext) {
    if (customHttpClient != null) {
      httpClient = customHttpClient;
    } else {
      // TODO: not for web
      httpClient = http.IOClient(HttpClient(context: securityContext));
    }
  }

  @override
  FutureOr<Credentials> fetch() async {
    if (credentials != null && !credentials!.isExpired()) {
      return credentials!;
    }

    try {
      http.StreamedResponse response = await httpClient.send(getRequest());
      if (response.notSuccessful()) {
        throw ProviderException(
            "STS service failed with HTTP status code ${response.statusCode}");
      }

      credentials = await parseResponse(response);
      return credentials!;
    } catch (e) {
      throw ProviderException("STS service failed with HTTP status code $e");
    }
  }

  HttpUrl.Builder newUrlBuilder(Uri url, String action, int durationSeconds,
      String? policy, String? roleArn, String? roleSessionName) {
    HttpUrl.Builder urlBuilder = url
        .newBuilder()
        .addQueryParameter("Action", action)
        .addQueryParameter("Version", "2011-06-15");

    if (durationSeconds > 0) {
      urlBuilder.addQueryParameter("DurationSeconds", '$durationSeconds');
    }

    if (policy != null) {
      urlBuilder.addQueryParameter("Policy", policy);
    }

    if (roleArn != null) {
      urlBuilder.addQueryParameter("RoleArn", roleArn);
    }

    if (roleSessionName != null) {
      urlBuilder.addQueryParameter("RoleSessionName", roleSessionName);
    }

    return urlBuilder;
  }

  Future<Credentials> parseResponse(http.StreamedResponse response) async {
    // TODO: xml??????
    xml2Json.parse(await response.stream.bytesToString());
    Response result = xmlUnmarshal(json.decode(xml2Json.toBadgerfish()));
    // Xml.unmarshal(getResponseClass(), response.stream.bytesToString());
    return result.getCredentials();
  }

  Response xmlUnmarshal(Map<String, dynamic> json);

  http.BaseRequest getRequest();
}

abstract class Response {
  Credentials getCredentials();
}

int getValidDurationSeconds(int? duration) {
  return (duration != null &&
          duration > AssumeRoleBaseProvider.DEFAULT_DURATION_SECONDS)
      ? duration
      : AssumeRoleBaseProvider.DEFAULT_DURATION_SECONDS;
}
