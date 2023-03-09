import 'package:intl/intl.dart';

/// Time formatters for S3 APIs.
class Time {
  static final DateFormat AMZ_DATE_FORMAT =
      DateFormat("yyyyMMdd'T'HHmmss'Z'", "en_US");

  static final DateFormat RESPONSE_DATE_FORMAT =
      DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", "en_US");

  // Formatted string is convertible to LocalDate only, not to LocalDateTime or ZonedDateTime.
  // Below example shows how to use this to get ZonedDateTime.
  // LocalDate.parse("20200225", SIGNER_DATE_FORMAT).atStartOfDay(UTC);
  static final DateFormat SIGNER_DATE_FORMAT = DateFormat("yyyyMMdd", "en_US");

  static final DateFormat HTTP_HEADER_DATE_FORMAT =
      DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", "en_US");

  static final DateFormat EXPIRATION_DATE_FORMAT = RESPONSE_DATE_FORMAT;

  Time();
}

extension DateTimeX on DateTime {
  String format(DateFormat fm) => fm.format(toUtc());

  static DateTime? parse(String? date, DateFormat fm) =>
      date == null? null : fm.parse(date, true).toUtc();
}
