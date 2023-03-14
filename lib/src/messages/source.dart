import 'package:json_annotation/json_annotation.dart';

part 'source.g.dart';

/// Helper class to denote client information causes this event. This is MinIO extension to <a
/// href="http://docs.aws.amazon.com/AmazonS3/latest/dev/notification-content-structure.html">Event
/// Message Structure</a>
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(
//     value = "UwF",
//     justification = "Everything in this class is initialized by JSON unmarshalling.")
@JsonSerializable()
class Source {
  final String? host;
  final String? port;
  final String? userAgent;

  Source(this.host, this.port, this.userAgent);

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);

  Map<String, dynamic> toJson() => _$SourceToJson(this);
}
