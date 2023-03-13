import 'package:collection/collection.dart';
import 'package:quiver/collection.dart';

import 'package:minio_flutter/src/time.dart';
import 'object_read_args.dart' as ObjectReadArgs;
import 's3escaper.dart';
import 'utils/multimapx.dart';

/// Base argument class holds condition properties for reading object.
abstract class ObjectConditionalReadArgs extends ObjectReadArgs.ObjectReadArgs {
  int? offset;
  int? length;
  String? matchETag;
  String? notMatchETag;
  DateTime? modifiedSince;
  DateTime? unmodifiedSince;

  Multimap<String, String> getHeaders() {
    int? offset = this.offset;
    int? length = this.length;
    if (length != null && offset == null) {
      offset = 0;
    }

    String? range;
    if (offset != null) {
      range = "bytes=$offset-";
      if (length != null) {
        range = "$range${offset + length - 1}";
      }
    }

    Multimap<String, String> headers = HashMultimap.create();

    if (range != null) headers.add("Range", range);
    if (matchETag != null) headers.add("if-match", matchETag!);
    if (notMatchETag != null) headers.add("if-none-match", notMatchETag!);

    if (modifiedSince != null) {
      headers.add("if-modified-since",
          modifiedSince!.format(Time.HTTP_HEADER_DATE_FORMAT));
    }

    if (unmodifiedSince != null) {
      headers.add("if-unmodified-since",
          unmodifiedSince!.format(Time.HTTP_HEADER_DATE_FORMAT));
    }

    if (ssec != null) headers.addAll(Multimaps.forMap(ssec!.headers()));

    return headers;
  }

  Multimap<String, String> genCopyHeaders() {
    Multimap<String, String> headers = HashMultimap.create();

    String copySource =
        S3Escaper.encodePath("/$bucketName/$objectName");
    if (versionId != null) {
      copySource += "?versionId=${S3Escaper.encode(versionId)}";
    }

    headers.add("x-amz-copy-source", copySource);

    if (ssec != null) {
      headers.addAll(Multimaps.forMap(ssec!.copySourceHeaders()));
    }
    if (matchETag != null) {
      headers.add("x-amz-copy-source-if-match", matchETag!);
    }
    if (notMatchETag != null) {
      headers.add("x-amz-copy-source-if-none-match", notMatchETag!);
    }

    if (modifiedSince != null) {
      headers.add("x-amz-copy-source-if-modified-since",
          modifiedSince!.format(Time.HTTP_HEADER_DATE_FORMAT));
    }

    if (unmodifiedSince != null) {
      headers.add("x-amz-copy-source-if-unmodified-since",
          unmodifiedSince!.format(Time.HTTP_HEADER_DATE_FORMAT));
    }

    return headers;
  }

  @override
  bool operator ==(Object other) {
    if (this == other) return true;
    if (other is! ObjectConditionalReadArgs) return false;
    if (super != other) return false;
    return offset == other.offset &&
        length == other.length &&
        matchETag == other.matchETag &&
        notMatchETag == other.notMatchETag &&
        modifiedSince == other.modifiedSince &&
        unmodifiedSince == other.unmodifiedSince;
  }

  @override
  int get hashCode {
    return ListEquality().hash([
      super.hashCode,
      offset,
      length,
      matchETag,
      notMatchETag,
      modifiedSince,
      unmodifiedSince
    ]);
  }
}

/// Base argument builder class for {@link ObjectConditionalReadArgs}.
abstract class Builder<B extends Builder<B, A>,
    A extends ObjectConditionalReadArgs> extends ObjectReadArgs.Builder<B, A> {
  void validateLength(int? length) {
    if (length != null && length <= 0) {
      throw ArgumentError("length should be greater than zero");
    }
  }

  void validateOffset(int? offset) {
    if (offset != null && offset < 0) {
      throw ArgumentError("offset should be zero or greater");
    }
  }

  B offset(int offset) {
    validateOffset(offset);
    operations.add((args) => args.offset = offset);
    return this as B;
  }

  B length(int length) {
    validateLength(length);
    operations.add((args) => args.length = length);
    return this as B;
  }

  B matchETag(String? etag) {
    validateNullOrNotEmptyString(etag, "etag");
    operations.add((args) => args.matchETag = etag);
    return this as B;
  }

  B notMatchETag(String? etag) {
    validateNullOrNotEmptyString(etag, "etag");
    operations.add((args) => args.notMatchETag = etag);
    return this as B;
  }

  B modifiedSince(DateTime modifiedTime) {
    operations.add((args) => args.modifiedSince = modifiedTime);
    return this as B;
  }

  B unmodifiedSince(DateTime unmodifiedTime) {
    operations.add((args) => args.unmodifiedSince = unmodifiedTime);
    return this as B;
  }
}
