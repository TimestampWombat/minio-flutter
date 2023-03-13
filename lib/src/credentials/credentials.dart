import 'package:json_annotation/json_annotation.dart';
import 'package:time/time.dart';

import '../messages/response_date.dart';
import '../time.dart';

part 'credentials.g.dart';

@JsonSerializable(includeIfNull: false)
class Credentials {
  @JsonKey(name: "AccessKeyId")
  final String accessKey;

  @JsonKey(name: "SecretAccessKey")
  final String secretKey;

  @JsonKey(name: "SessionToken")
  final String? sessionToken;

  @JsonKey(
      name: "Expiration",
      fromJson: ResponseDate.fromString,
      toJson: ResponseDate.toJson)
  final ResponseDate? expiration;

  Credentials(
      this.accessKey, this.secretKey, this.sessionToken, this.expiration) {
    if (accessKey.isEmpty || secretKey.isEmpty) {
      throw ArgumentError("AccessKey and SecretKey must not be empty");
    }
  }

  bool isExpired() {
    if (expiration == null) {
      return false;
    }

    return DateTimeX.nowUtc()
        .add(10.seconds)
        .isAfter(expiration!.zonedDateTime);
  }

  factory Credentials.fromJson(Map<String, dynamic> json) =>
      _$CredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$CredentialsToJson(this);
}
