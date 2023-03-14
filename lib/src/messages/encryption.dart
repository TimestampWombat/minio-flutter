// @Root(name = "Encryption")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
import 'package:json_annotation/json_annotation.dart';

import 'sse_algorithm.dart';

part 'encryption.g.dart';
@JsonSerializable(fieldRename: FieldRename.pascal)
class Encryption {
  final SseAlgorithm encryptionType;

  @JsonKey(name: "KMSContext")
  final String? kmsContext;

  @JsonKey(name: "KMSKeyId")
  final String? kmsKeyId;

  Encryption(this.encryptionType, this.kmsContext, this.kmsKeyId);

  factory Encryption.fromJson(Map<String, dynamic> json) =>
      _$EncryptionFromJson(json);

  Map<String, dynamic> toJson() => _$EncryptionToJson(this);
}
