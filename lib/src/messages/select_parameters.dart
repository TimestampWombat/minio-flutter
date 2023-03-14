@Root(name = "SelectParameters")
@edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
public class SelectParameters extends SelectObjectContentRequestBase {
  public SelectParameters(
      @Nonnull String expression, @Nonnull InputSerialization is, @Nonnull OutputSerialization os) {
    super(expression, is, os);
  }
}
