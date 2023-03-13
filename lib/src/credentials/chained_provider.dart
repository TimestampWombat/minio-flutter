import 'dart:async';

import '../errors/minio_exception.dart';
import 'credentials.dart';
import 'provider.dart';

class ChainedProvider implements Provider {
  final List<Provider> providers;
  Provider? currentProvider;
  Credentials? credentials;

  ChainedProvider(List<Provider> providers) : providers = List.from(providers);

  @override
  FutureOr<Credentials> fetch() async {
    if (credentials != null && !credentials!.isExpired()) {
      return credentials!;
    }

    if (currentProvider != null) {
      try {
        credentials = await currentProvider!.fetch();
        return credentials!;
      } catch (e) {
        // Ignore and fallback to iteration.
      }
    }

    for (Provider provider in providers) {
      try {
        credentials = await provider.fetch();
        currentProvider = provider;
        return credentials!;
      } catch (e) {
        // Ignore and continue to next iteration.
      }
    }

    throw ProviderException("All providers fail to fetch credentials");
  }
}
