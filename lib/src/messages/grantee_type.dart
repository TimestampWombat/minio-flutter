// @Root(name = "Type")
// @Convert(GranteeType.GranteeTypeConverter.class)
enum GranteeType {
  CANONICAL_USER("CanonicalUser"),
  AMAZON_CUSTOMER_BY_EMAIL("AmazonCustomerByEmail"),
  GROUP("Group");

  final String value;

  const GranteeType(this.value);

  @override
  String toString() {
    return value;
  }

  /// Returns GranteeType of given string.
  static GranteeType fromString(String granteeTypeString) {
    for (GranteeType granteeType in GranteeType.values) {
      if (granteeTypeString == granteeType.value) {
        return granteeType;
      }
    }

    throw ArgumentError("Unknown grantee type '$granteeTypeString'");
  }
}
