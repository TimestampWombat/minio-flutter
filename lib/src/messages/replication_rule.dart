@Root(name = "Rule")
public class ReplicationRule {
  @Element(name = "DeleteMarkerReplication", required = false)
  private DeleteMarkerReplication deleteMarkerReplication;

  @Element(name = "Destination")
  private ReplicationDestination destination;

  @Element(name = "ExistingObjectReplication", required = false)
  private ExistingObjectReplication existingObjectReplication;

  @Element(name = "Filter", required = false)
  private RuleFilter filter;

  @Element(name = "ID", required = false)
  private String id;

  @Element(name = "Prefix", required = false)
  @Convert(PrefixConverter.class)
  private String prefix;

  @Element(name = "Priority", required = false)
  private Integer priority;

  @Element(name = "SourceSelectionCriteria", required = false)
  private SourceSelectionCriteria sourceSelectionCriteria;

  @Element(name = "DeleteReplication", required = false)
  private DeleteReplication deleteReplication; // This is MinIO specific extension.

  @Element(name = "Status")
  private Status status;

  /** Constructs server-side encryption configuration rule. */
  public ReplicationRule(
      @Nullable @Element(name = "DeleteMarkerReplication", required = false)
          DeleteMarkerReplication deleteMarkerReplication,
      @Nonnull @Element(name = "Destination") ReplicationDestination destination,
      @Nullable @Element(name = "ExistingObjectReplication", required = false)
          ExistingObjectReplication existingObjectReplication,
      @Nullable @Element(name = "Filter", required = false) RuleFilter filter,
      @Nullable @Element(name = "ID", required = false) String id,
      @Nullable @Element(name = "Prefix", required = false) String prefix,
      @Nullable @Element(name = "Priority", required = false) Integer priority,
      @Nullable @Element(name = "SourceSelectionCriteria", required = false)
          SourceSelectionCriteria sourceSelectionCriteria,
      @Nullable @Element(name = "DeleteReplication", required = false)
          DeleteReplication deleteReplication,
      @Nonnull @Element(name = "Status") Status status) {

    if (filter != null && deleteMarkerReplication == null) {
      deleteMarkerReplication = DeleteMarkerReplication(null);
    }

    if (id != null) {
      id = id.trim();
      if (id.isEmpty()) throw ArgumentError("ID must be non-empty string");
      if (id.length() > 255) throw ArgumentError("ID must be exceed 255 characters");
    }

    this.deleteMarkerReplication = deleteMarkerReplication;
    this.destination = Objects.requireNonNull(destination, "Destination must not be null");
    this.existingObjectReplication = existingObjectReplication;
    this.filter = filter;
    this.id = id;
    this.prefix = prefix;
    this.priority = priority;
    this.sourceSelectionCriteria = sourceSelectionCriteria;
    this.deleteReplication = deleteReplication;
    this.status = Objects.requireNonNull(status, "Status must not be null");
  }

  /** Constructs server-side encryption configuration rule. */
  public ReplicationRule(
      @Nullable @Element(name = "DeleteMarkerReplication", required = false)
          DeleteMarkerReplication deleteMarkerReplication,
      @Nonnull @Element(name = "Destination") ReplicationDestination destination,
      @Nullable @Element(name = "ExistingObjectReplication", required = false)
          ExistingObjectReplication existingObjectReplication,
      @Nullable @Element(name = "Filter", required = false) RuleFilter filter,
      @Nullable @Element(name = "ID", required = false) String id,
      @Nullable @Element(name = "Prefix", required = false) String prefix,
      @Nullable @Element(name = "Priority", required = false) Integer priority,
      @Nullable @Element(name = "SourceSelectionCriteria", required = false)
          SourceSelectionCriteria sourceSelectionCriteria,
      @Nonnull @Element(name = "Status") Status status) {
    this(
        deleteMarkerReplication,
        destination,
        existingObjectReplication,
        filter,
        id,
        prefix,
        priority,
        sourceSelectionCriteria,
        null,
        status);
  }

  public DeleteMarkerReplication deleteMarkerReplication() {
    return this.deleteMarkerReplication;
  }

  public ReplicationDestination destination() {
    return this.destination;
  }

  public ExistingObjectReplication existingObjectReplication() {
    return this.existingObjectReplication;
  }

  public RuleFilter filter() {
    return this.filter;
  }

  public String id() {
    return this.id;
  }

  public String prefix() {
    return this.prefix;
  }

  public Integer priority() {
    return this.priority;
  }

  public SourceSelectionCriteria sourceSelectionCriteria() {
    return this.sourceSelectionCriteria;
  }

  public DeleteReplication deleteReplication() {
    return this.deleteReplication;
  }

  public Status status() {
    return this.status;
  }
}
