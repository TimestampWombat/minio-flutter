import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import '../errors/minio_exception.dart';
import 'credentials.dart';
import 'environment_provider.dart';

part 'minio_client_config_provider.g.dart';

/// Credential provider using MinioClient configuration file.
class MinioClientConfigProvider extends EnvironmentProvider {
  final String filename;
  final String alias;

  MinioClientConfigProvider(this.filename, this.alias) {
    if (filename.isEmpty) {
      throw ArgumentError("Filename must not be empty");
    }

    if (alias.isEmpty) {
      throw ArgumentError("Alias must not be empty");
    }
  }

  /// Retrieve credentials in provided alias or MINIO_ALIAS or "s3" alias in configuration file from
  /// provided filename or AWS_SHARED_CREDENTIALS_FILE environment variable or file .aws/credentials
  /// in user's home directory.
  @override
  FutureOr<Credentials> fetch() {
    String filename = this.filename;
    // if (filename == null) {
    //   filename = getProperty("MINIO_SHARED_CREDENTIALS_FILE");
    // }
    // if (filename == null) {
    //   String mcDir = ".mc";
    //   if (System.getProperty("os.name").toLowerCase(Locale.US).contains("windows")) {
    //     mcDir = "mc";
    //   }

    //   filename = Paths.get(System.getProperty("user.home"), mcDir, "config.json").toString();
    // }

    String alias = this.alias;
    // if (alias == null) {
    //   alias = getProperty("MINIO_ALIAS");
    // }
    // if (alias == null) {
    //   alias = "s3";
    // }

    try {
      McConfig config =
          McConfig.fromJson(json.decode(File(filename).readAsStringSync()));
      // mapper.readValue(new InputStreamReader(is, StandardCharsets.UTF_8), McConfig.class);
      Map<String, String>? values = config.get(alias);
      if (values == null) {
        throw ProviderException(
            "Alias $alias does not exist in MinioClient configuration file");
      }

      String? accessKey = values["accessKey"];
      String? secretKey = values["secretKey"];

      if (accessKey == null) {
        throw ProviderException(
            "Access key does not exist in alias $alias in MinioClient configuration file");
      }

      if (secretKey == null) {
        throw ProviderException(
            "Secret key does not exist in alias $alias in MinioClient configuration file");
      }

      return Credentials(accessKey, secretKey, null, null);
    } catch (e) {
      throw ProviderException(
          "Unable to read MinioClient configuration file", e);
    }
  }
}

@JsonSerializable()
class McConfig {
  Map<String, Map<String, String>> hosts;
  McConfig(this.hosts);

  Map<String, String>? get(String alias) {
    return hosts[alias];
  }

  factory McConfig.fromJson(Map<String, dynamic> json) =>
      _$McConfigFromJson(json);
  Map<String, dynamic> toJson() => _$McConfigToJson(this);
}
