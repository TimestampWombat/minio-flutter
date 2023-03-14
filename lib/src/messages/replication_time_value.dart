@Root(name = "ReplicationTimeValue")
public class ReplicationTimeValue {
  @Element(name = "Minutes", required = false)
  private Integer minutes = 15;

  public ReplicationTimeValue(
      @Nullable @Element(name = "Minutes", required = false) Integer minutes) {
    this.minutes = minutes;
  }

  public Integer minutes() {
    return this.minutes;
  }
}
