import 'package:json_annotation/json_annotation.dart';

part 'jwt.g.dart';

@JsonSerializable()
class Jwt {
  Jwt(this.token, this.expiry);

  @JsonKey(name: "access_token")
  final String token;

  @JsonKey(name: "expires_in")
  final int expiry;

  factory Jwt.fromJson(Map<String, dynamic> json) => _$JwtFromJson(json);
  Map<String, dynamic> toJson() => _$JwtToJson(this);
}
