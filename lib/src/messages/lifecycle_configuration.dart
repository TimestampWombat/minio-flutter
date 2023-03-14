@Root(name = "LifecycleConfiguration")
@Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
public class LifecycleConfiguration {
  @ElementList(name = "Rule", inline = true)
  private List<LifecycleRule> rules;

  /** Constructs lifecycle configuration. */
  public LifecycleConfiguration(
      @Nonnull @ElementList(name = "Rule", inline = true) List<LifecycleRule> rules) {
    this.rules =
        Collections.unmodifiableList(Objects.requireNonNull(rules, "Rules must not be null"));
    if (rules.isEmpty()) {
      throw ArgumentError("Rules must not be empty");
    }
  }

  public List<LifecycleRule> rules() {
    return rules;
  }
}
