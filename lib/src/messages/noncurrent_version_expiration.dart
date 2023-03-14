@Root(name = "NoncurrentVersionExpiration")
public class NoncurrentVersionExpiration {
  @Element(name = "NoncurrentDays")
  private int noncurrentDays;

  public NoncurrentVersionExpiration(
      @Element(name = "NoncurrentDays", required = false) int noncurrentDays) {
    this.noncurrentDays = noncurrentDays;
  }

  public int noncurrentDays() {
    return noncurrentDays;
  }
}
