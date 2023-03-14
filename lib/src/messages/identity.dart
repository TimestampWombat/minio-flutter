// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(
//     value = "UwF",
//     justification = "Everything in this class is initialized by JSON unmarshalling.")

import 'package:json_annotation/json_annotation.dart';

part 'identity.g.dart';

@JsonSerializable()
 class Identity {
  final String principalId;

  Identity(this.principalId);

  factory Identity.fromJson(Map<String, dynamic> json) =>
      _$IdentityFromJson(json);

  Map<String, dynamic> toJson() => _$IdentityToJson(this);    
}
