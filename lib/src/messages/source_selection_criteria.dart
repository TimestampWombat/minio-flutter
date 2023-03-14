@Root(name = "SourceSelectionCriteria")
public class SourceSelectionCriteria {
  @Element(name = "ReplicaModifications", required = false)
  private ReplicaModifications replicaModifications;

  @Element(name = "SseKmsEncryptedObjects", required = false)
  private SseKmsEncryptedObjects sseKmsEncryptedObjects;

  public SourceSelectionCriteria(
      @Nullable @Element(name = "SseKmsEncryptedObjects", required = false)
          SseKmsEncryptedObjects sseKmsEncryptedObjects,
      @Nullable @Element(name = "ReplicaModifications", required = false)
          ReplicaModifications replicaModifications) {
    this.sseKmsEncryptedObjects = sseKmsEncryptedObjects;
    this.replicaModifications = replicaModifications;
  }

  public SourceSelectionCriteria(@Nullable SseKmsEncryptedObjects sseKmsEncryptedObjects) {
    this(sseKmsEncryptedObjects, null);
  }

  public ReplicaModifications replicaModifications() {
    return this.replicaModifications;
  }

  public SseKmsEncryptedObjects sseKmsEncryptedObjects() {
    return this.sseKmsEncryptedObjects;
  }
}
