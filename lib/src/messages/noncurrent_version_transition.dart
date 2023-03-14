@Root(name = "NoncurrentVersionTransition")
public class NoncurrentVersionTransition extends NoncurrentVersionExpiration {
  @Element(name = "StorageClass")
  private String storageClass;

  public NoncurrentVersionTransition(
      @Element(name = "NoncurrentDays", required = false) int noncurrentDays,
      @Nonnull @Element(name = "StorageClass", required = false) String storageClass) {
    super(noncurrentDays);
    if (storageClass == null || storageClass.isEmpty()) {
      throw ArgumentError("StorageClass must be provided");
    }
    this.storageClass = storageClass;
  }

  public String storageClass() {
    return storageClass;
  }
}
