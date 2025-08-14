import 'package:flutter_riverpod/flutter_riverpod.dart';

final typeProvider = StateNotifierProvider<TypeNotifier, String?>((ref) {
  return TypeNotifier();
});

class TypeNotifier extends StateNotifier<String?> {
  TypeNotifier() : super(null);

  void setType(String type) {
    state = type;
  }
}
