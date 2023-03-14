@Root(name = "ReplicaModifications")
public class ReplicaModifications {
  @Element(name = "Status")
  private Status status;

  public ReplicaModifications(@Nonnull @Element(name = "Status") Status status) {
    this.status = Objects.requireNonNull(status, "Status must not be null");
  }

  public Status status() {
    return this.status;
  }
}
