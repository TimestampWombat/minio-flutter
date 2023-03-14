// @Root(name = "Tagging", strict = false)
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")

import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

part 'tags.g.dart';

@JsonSerializable()
class Tags {
  /*
   * Limits are specified in https://docs.aws.amazon.com/AmazonS3/latest/dev/object-tagging.html and
   * https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html#tag-restrictions
   */
  static final int MAX_KEY_LENGTH = 128;
  static final int MAX_VALUE_LENGTH = 256;
  static final int MAX_OBJECT_TAG_COUNT = 10;
  static final int MAX_TAG_COUNT = 50;

  // @Path(value = "TagSet")
  // @ElementMap(
  //     attribute = false,
  //     entry = "Tag",
  //     inline = true,
  //     key = "Key",
  //     value = "Value",
  //     required = false)
  @JsonKey(name: "Tag")
  Map<String, String>? tags;

  Tags([Map<String, String>? tags, bool isObject = false]) {
    if (tags == null) {
      return;
    }

    int limit = isObject ? MAX_OBJECT_TAG_COUNT : MAX_TAG_COUNT;
    if (tags.length > limit) {
      throw ArgumentError(
          "too many ${(isObject ? "object" : "bucket")} tags; allowed = $limit, found = ${tags.length}");
    }

    for (var entry in tags.entries) {
      String key = entry.key;
      if (key.isEmpty || key.length > MAX_KEY_LENGTH || key.contains("&")) {
        throw ArgumentError("invalid tag key '$key'");
      }

      String value = entry.value;
      if (value.length > MAX_VALUE_LENGTH || value.contains("&")) {
        throw ArgumentError("invalid tag value '$value'");
      }
    }

    this.tags = UnmodifiableMapView(tags);
  }

  /// Creates bucket tags.
  static Tags newBucketTags(Map<String, String> tags) {
    return Tags(tags, false);
  }

  /// Creates object tags.
  static Tags newObjectTags(Map<String, String> tags) {
    return Tags(tags, true);
  }

  /// Returns tags.
  Map<String, String> get() {
    return UnmodifiableMapView(tags ?? <String, String>{});
  }
}
