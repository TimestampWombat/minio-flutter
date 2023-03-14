// @Root(name:"Upload", strict = false)
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")

import 'package:json_annotation/json_annotation.dart';

import '../errors/minio_exception.dart';
import 'initiator.dart';
import 'owner.dart';
import 'response_date.dart';

part 'upload.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Upload {
  @JsonKey(name: "Key")
  final String objectNameK;

  final String uploadId;

  final Initiator? initiator;

  final Owner? owner;

  final String? storageClass;

  @JsonKey(fromJson: ResponseDate.fromJson, toJson: ResponseDate.toJson)
  final ResponseDate initiated;

  int aggregatedPartSize = 0;
  String? encodingType;

  Upload(this.objectNameK, this.uploadId, this.initiator, this.owner,
      this.storageClass, this.initiated);

  /// Returns object name.
  String objectName() {
    try {
      return "url" == encodingType ? Uri.decodeFull(objectNameK) : objectNameK;
    } catch (e) {
      // This never happens as 'enc' name comes from JDK's own StandardCharsets.
      throw RuntimeException('$e');
    }
  }

  factory Upload.fromJson(Map<String, dynamic> json) => _$UploadFromJson(json);
  Map<String, dynamic> toJson() => _$UploadToJson(this);
}
