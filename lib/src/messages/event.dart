import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

import 'event_metadata.dart';
import 'event_type.dart';
import 'identity.dart';
import 'response_date.dart';
import 'source.dart';

part 'event.g.dart';

/// Helper class to denote single event record for {@link NotificationRecords}.
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(
//     value = "UuF",
//     justification = "eventVersion and eventSource are available for completeness")
@JsonSerializable()
class Event {
  final String eventVersion;
  final String eventSource;
  final String awsRegion;
  final EventType eventName;
  final Identity? userIdentity;
  @JsonKey(name: 'requestParameters')
  final Map<String, String>? requestParametersK;
  @JsonKey(name: 'responseElements')
  final Map<String, String>? responseElementsK;
  final EventMetadata? s3;
  final Source? source;
  @JsonKey(
      name: 'eventTime',
      fromJson: ResponseDate.fromJson,
      toJson: ResponseDate.toJson)
  final ResponseDate eventTimeK;

  Event({
    required this.eventVersion,
    required this.eventSource,
    required this.awsRegion,
    required this.eventName,
    this.userIdentity,
    this.requestParametersK,
    this.responseElementsK,
    this.s3,
    this.source,
    required this.eventTimeK,
  });

  String region() {
    return awsRegion;
  }

  DateTime eventTime() {
    return eventTimeK.zonedDateTime;
  }

  EventType eventType() {
    return eventName;
  }

  String? userId() {
    return userIdentity?.principalId;
  }

  Map<String, String> requestParameters() {
    return UnmodifiableMapView(requestParametersK ?? {});
  }

  Map<String, String> responseElements() {
    return UnmodifiableMapView(responseElementsK ?? {});
  }

  String? bucketName() {
    return s3?.bucketName();
  }

  String? bucketOwner() {
    return s3?.bucketOwner();
  }

  String? bucketArn() {
    return s3?.bucketArn();
  }

  String? objectName() {
    return s3?.objectName();
  }

  int objectSize() {
    return s3?.objectSize() ?? -1;
  }

  String? etag() {
    return s3?.etag();
  }

  String? objectVersionId() {
    return s3?.objectVersionId();
  }

  String? sequencer() {
    return s3?.sequencer();
  }

  Map<String, String>? userMetadata() {
    return s3?.userMetadata();
  }

  String? host() {
    return source?.host;
  }

  String? port() {
    return source?.port;
  }

  String? userAgent() {
    return source?.userAgent;
  }

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
