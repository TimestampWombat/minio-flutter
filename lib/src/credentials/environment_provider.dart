import 'provider.dart';

abstract class EnvironmentProvider implements Provider {
  /// Get value of a property from system property or environment variable.
  String? getProperty(String name) {
    // final String value = System.getProperty(name);
    // return (value != null) ? value : System.getenv(name);
    return String.fromEnvironment(name);
  }
}
