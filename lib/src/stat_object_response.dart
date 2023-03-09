import 'package:collection/collection.dart';
import 'package:minio_flutter/src/messages/response_date.dart';

import 'generic_response.dart';
import 'messages/legal_hold.dart';
import 'messages/retention_mode.dart';
import 'time.dart';

/// Response of {@link S3Base#statObjectAsync}.
class StatObjectResponse extends GenericResponse {
  late String etag;
  late int size;
  DateTime? lastModified;
  RetentionMode? retentionMode;
  DateTime? retentionRetainUntilDate;
  late LegalHold legalHold;
  late bool deleteMarker;
  late Map<String, String?> userMetadata;

  StatObjectResponse(super.headers, super.bucket, super.region, super.object) {
    String? value;

    value = headers.value("ETag");
    etag = (value != null ? value.replaceAll("\"", "") : "");

    value = headers.value("Content-Length");
    size = (value != null ? int.tryParse(value) ?? -1 : -1);

    lastModified = DateTimeX.parse(
        headers.value("Last-Modified"), Time.HTTP_HEADER_DATE_FORMAT);

    value = headers.value("x-amz-object-lock-mode");
    retentionMode = (value != null ? RetentionMode.values.byName(value) : null);

    value = headers.value("x-amz-object-lock-retain-until-date");
    retentionRetainUntilDate =
        (value != null ? ResponseDate.fromString(value).zonedDateTime : null);

    legalHold =
        LegalHold.bool("ON" == headers.value("x-amz-object-lock-legal-hold"));

    deleteMarker =
        'true' == headers.value("x-amz-delete-marker")?.toLowerCase();

    Map<String, String?> userMetadata = <String, String?>{};

    headers.forEach((key, values) {
      if (key.toLowerCase().startsWith("x-amz-meta-")) {
        userMetadata[key
            .toLowerCase()
            .substring("x-amz-meta-".length, key.length)] = values.firstOrNull;
      }
    });

    this.userMetadata = UnmodifiableMapView(userMetadata);
  }

  String? versionId() {
    return headers.value("x-amz-version-id");
  }

  String? contentType() {
    return headers.value("Content-Type");
  }

  @override
  String toString() {
    return "ObjectStat{bucket=$bucket, object=$object, last-modified=$lastModified, size=$size}";
  }
}
