@Root(name = "NotificationConfiguration", strict = false)
@Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
public class NotificationConfiguration {
  @ElementList(name = "CloudFunctionConfiguration", inline = true, required = false)
  private List<CloudFunctionConfiguration> cloudFunctionConfigurationList;

  @ElementList(name = "QueueConfiguration", inline = true, required = false)
  private List<QueueConfiguration> queueConfigurationList;

  @ElementList(name = "TopicConfiguration", inline = true, required = false)
  private List<TopicConfiguration> topicConfigurationList;

  public NotificationConfiguration() {}

  /** Returns cloud function configuration. */
  public List<CloudFunctionConfiguration> cloudFunctionConfigurationList() {
    return Collections.unmodifiableList(
        cloudFunctionConfigurationList == null
            ? LinkedList<>()
            : cloudFunctionConfigurationList);
  }

  /** Sets cloud function configuration list. */
  public void setCloudFunctionConfigurationList(
      List<CloudFunctionConfiguration> cloudFunctionConfigurationList) {
    this.cloudFunctionConfigurationList =
        Collections.unmodifiableList(cloudFunctionConfigurationList);
  }

  /** Returns queue configuration list. */
  public List<QueueConfiguration> queueConfigurationList() {
    return Collections.unmodifiableList(
        queueConfigurationList == null ? LinkedList<>() : queueConfigurationList);
  }

  /** Sets queue configuration list. */
  public void setQueueConfigurationList(List<QueueConfiguration> queueConfigurationList) {
    this.queueConfigurationList = Collections.unmodifiableList(queueConfigurationList);
  }

  /** Returns topic configuration list. */
  public List<TopicConfiguration> topicConfigurationList() {
    return Collections.unmodifiableList(
        topicConfigurationList == null ? LinkedList<>() : topicConfigurationList);
  }

  /** Sets topic configuration list. */
  public void setTopicConfigurationList(List<TopicConfiguration> topicConfigurationList) {
    this.topicConfigurationList = Collections.unmodifiableList(topicConfigurationList);
  }
}
