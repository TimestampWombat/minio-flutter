// @Root(name = "Tier")
// @Convert(Tier.TierConverter.class)
enum Tier {
  STANDARD("Standard"),
  BULK("Bulk"),
  EXPEDITED("Expedited");

  final String value;

  const Tier(this.value);

  @override
  String toString() {
    return value;
  }
}
