import 'dart:io';

extension InternetAddressX on InternetAddress {
  /// check address is ipv6
  bool get isIPv6 => type == InternetAddressType.IPv6;
}

bool isValidIpv6(String address) {
  try {
    return InternetAddress(address, type: InternetAddressType.IPv6).isIPv6;
  } catch (e) {
    return false;
  }
}

bool isValidAddress(String address) {
  try {
    InternetAddress(address);
    return true;
  } catch (e) {
    return false;
  }
}
