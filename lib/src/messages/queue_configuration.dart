@Root(name = "QueueConfiguration", strict = false)
public class QueueConfiguration extends NotificationCommonConfiguration {
  @Element(name = "Queue")
  private String queue;

  public QueueConfiguration() {
    super();
  }

  /** Returns queue. */
  public String queue() {
    return queue;
  }

  /** Sets queue. */
  public void setQueue(String queue) {
    this.queue = queue;
  }
}
