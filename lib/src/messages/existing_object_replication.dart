@Root(name = "ExistingObjectReplication")
public class ExistingObjectReplication {
  @Element(name = "Status")
  private Status status;

  public ExistingObjectReplication(@Nonnull @Element(name = "Status") Status status) {
    this.status = Objects.requireNonNull(status, "Status must not be null");
  }

  public Status status() {
    return this.status;
  }
}
