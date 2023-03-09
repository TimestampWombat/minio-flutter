import 'package:collection/collection.dart';
import 'package:minio_flutter/src/bucket_args.dart';
import 'package:minio_flutter/src/utils/consumer.dart';
import 'package:quiver/collection.dart';

import 'utils/multimapx.dart';

/// Base argument class.
abstract class BaseArgs {
  Multimap<String, String> extraHeaders =
      Multimaps.unmodifiableMultimap(HashMultimap.create());
  Multimap<String, String> extraQueryParams =
      Multimaps.unmodifiableMultimap(HashMultimap.create());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BaseArgs) return false;
    return extraHeaders.equals(other.extraHeaders) &&
        extraQueryParams.equals(other.extraQueryParams);
  }

  @override
  int get hashCode {
    return ListEquality(MapEquality(values: UnorderedIterableEquality()))
        .hash([extraHeaders.asMap(), extraQueryParams.asMap()]);
  }
}

/// Base builder which builds arguments.
abstract class Builder<B extends Builder<B, A>, A extends BaseArgs> {
  List<Consumer<A>> operations;

  void validate(A args);

  void validateNotNull(Object? arg, String argName) {
    if (arg == null) {
      throw ArgumentError("$argName must not be null.");
    }
  }

  void validateNotEmptyString(String arg, String argName) {
    validateNotNull(arg, argName);
    if (arg.isEmpty) {
      throw ArgumentError("$argName must be a non-empty string.");
    }
  }

  void validateNullOrNotEmptyString(String? arg, String argName) {
    if (arg != null && arg.isEmpty) {
      throw ArgumentError("$argName must be a non-empty string.");
    }
  }

  void validateNullOrPositive(num? arg, String argName) {
    if (arg != null && arg < 0) {
      throw ArgumentError("$argName cannot be non-negative.");
    }
  }

  Builder() : operations = <Consumer<A>>[];

  Multimap<String, String> copyMultimap(Multimap<String, String> multimap) {
    Multimap<String, String> multimapCopy = HashMultimap.create();
    if (multimap != null) {
      multimapCopy.addAll(multimap);
    }
    return Multimaps.unmodifiableMultimap(multimapCopy);
  }

  Multimap<String, String> toMultimap(Map<String, String>? map) {
    Multimap<String, String> multimap = HashMultimap.create();
    if (map != null) {
      multimap.addAll(Multimaps.forMap(map));
    }
    return Multimaps.unmodifiableMultimap(multimap);
  }

  // Its safe to type cast to B as B extends this class.
  B extraHeaders(Multimap<String, String> headers) {
    final Multimap<String, String> extraHeaders = copyMultimap(headers);
    operations.add((args) => args.extraHeaders = extraHeaders);
    return this as B;
  }

  // Its safe to type cast to B as B extends this class.
  B extraQueryParams(Multimap<String, String> queryParams) {
    final Multimap<String, String> extraQueryParams = copyMultimap(queryParams);
    operations.add((args) => args.extraQueryParams = extraQueryParams);
    return this as B;
  }

  // Its safe to type cast to B as B extends this class.
  B extraHeadersFromMap(Map<String, String> headers) {
    final Multimap<String, String> extraHeaders = toMultimap(headers);
    operations.add((args) => args.extraHeaders = extraHeaders);
    return this as B;
  }

  // Its safe to type cast to B as B extends this class.
  B extraQueryParamsFromMap(Map<String, String> queryParams) {
    final Multimap<String, String> extraQueryParams = toMultimap(queryParams);
    operations.add((args) => args.extraQueryParams = extraQueryParams);
    return this as B;
  }

  // safe as B will always be the builder of the current args class
  // TODO: 用反射，dart不行啊?
  A newInstance(); // {
  // try {
  //   for (Constructor<?> constructor :
  //       this.getClass().getEnclosingClass().getDeclaredConstructors()) {
  //     if (constructor.getParameterCount() == 0) {
  //       return (A) constructor.newInstance();
  //     }
  //   }

  //   throw RuntimeException(
  //       this.getClass().getEnclosingClass() + " must have no argument constructor");
  // } catch (InstantiationException
  //     | IllegalAccessException
  //     | InvocationTargetException
  //     | SecurityException e) {
  //   // Args class must have no argument constructor with at least  access.
  //   throw RuntimeException(e);
  // }

  // }

  /// Creates derived Args class with each attribute populated.
  A build() {
    A args = newInstance();
    for (var operation in operations) {
      operation.accept(args);
    }
    validate(args);
    return args;
  }
}
