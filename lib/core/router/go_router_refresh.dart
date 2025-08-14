import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A ChangeNotifier that listens to a provider and notifies GoRouter on changes
class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(ProviderListenable provider, ProviderRef ref) {
    ref.listen(provider, (previous, next) {
      notifyListeners(); // Triggers GoRouter refresh
    });
  }
}
