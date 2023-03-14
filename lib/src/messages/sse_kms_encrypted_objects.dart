@Root(name = "SseKmsEncryptedObjects")
public class SseKmsEncryptedObjects {
  @Element(name = "Status")
  private Status status;

  public SseKmsEncryptedObjects(@Nonnull @Element(name = "Status") Status status) {
    this.status = Objects.requireNonNull(status, "Status must not be null");
  }

  public Status status() {
    return this.status;
  }
}
