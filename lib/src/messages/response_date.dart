import 'package:intl/intl.dart';
import 'package:minio_flutter/src/time.dart';

/// S3 specified response time wrapping {@link ZonedDateTime}.
// @Root
// @Convert(ResponseDate.ResponseDateConverter.class)
class ResponseDate {
  static final DateFormat MINIO_RESPONSE_DATE_FORMAT =
      DateFormat("yyyy-MM-dd'T'HH':'mm':'ss'Z'", "en_US");

  final DateTime zonedDateTime;

  ResponseDate(this.zonedDateTime);

  @override
  String toString() {
    return zonedDateTime.format(Time.RESPONSE_DATE_FORMAT);
  }

  static ResponseDate fromString(String responseDateString) {
    try {
      return ResponseDate(
          DateTimeX.parse(responseDateString, Time.RESPONSE_DATE_FORMAT)!);
    } catch (e) {
      return ResponseDate(
          DateTimeX.parse(responseDateString, MINIO_RESPONSE_DATE_FORMAT)!);
    }
  }
}

//  /** XML converter class. */
//     class ResponseDateConverter implements Converter<ResponseDate> {
//     @Override
//      ResponseDate read(InputNode node) throws Exception {
//       return ResponseDate.fromString(node.getValue());
//     }

//     @Override
//      void write(OutputNode node, ResponseDate amzDate) {
//       node.setValue(amzDate.toString());
//     }
//   }