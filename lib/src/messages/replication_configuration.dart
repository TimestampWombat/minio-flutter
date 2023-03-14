@Root(name = "ReplicationConfiguration")
@Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
public class ReplicationConfiguration {
  @Element(name = "Role", required = false)
  private String role;

  @ElementList(name = "Rule", inline = true)
  private List<ReplicationRule> rules;

  /** Constructs replication configuration. */
  public ReplicationConfiguration(
      @Nullable @Element(name = "Role", required = false) String role,
      @Nonnull @ElementList(name = "Rule", inline = true) List<ReplicationRule> rules) {
    this.role = role; // Role is not applicable in MinIO server and it is optional.

    this.rules =
        Collections.unmodifiableList(Objects.requireNonNull(rules, "Rules must not be null"));
    if (rules.isEmpty()) {
      throw ArgumentError("Rules must not be empty");
    }
    if (rules.size() > 1000) {
      throw ArgumentError("More than 1000 rules are not supported");
    }
  }

  public String role() {
    return role;
  }

  public List<ReplicationRule> rules() {
    return Collections.unmodifiableList(rules == null ? LinkedList<>() : rules);
  }
}
