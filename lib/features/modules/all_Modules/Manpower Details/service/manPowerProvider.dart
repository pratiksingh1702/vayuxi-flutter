import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/manpower_model.dart';

import 'manpowerService.dart';

/// State class to hold manpower data
class ManpowerState {
  final bool isLoading;
  final List<ManpowerModel> manpowerList;
  final String? error;

  ManpowerState({
    this.isLoading = false,
    this.manpowerList = const [],
    this.error,
  });

  ManpowerState copyWith({
    bool? isLoading,
    List<ManpowerModel>? manpowerList,
    String? error,
  }) {
    return ManpowerState(
      isLoading: isLoading ?? this.isLoading,
      manpowerList: manpowerList ?? this.manpowerList,
      error: error ?? this.error,
    );
  }
}

/// Notifier to manage manpower state
class ManpowerNotifier extends StateNotifier<ManpowerState> {
  ManpowerNotifier() : super(ManpowerState());

  /// Fetch manpower list
  Future<void> fetchManpower(String type) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await ManpowerAPI.fetchManpower(type);
      if (res["success"]) {
        final List dataList = res["data"];
        state = state.copyWith(
          manpowerList: dataList.map((e) => ManpowerModel.fromJson(e)).toList(),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: "Failed to fetch manpower",
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// Add manpower
  Future<void> addManpower(String type, Map<String, dynamic> data) async {
    try {
      await ManpowerAPI.postManpower(type, data);
      await fetchManpower(type); // Refresh list
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Update manpower
  Future<void> updateManpower(String id, Map<String, dynamic> data, String type) async {
    try {
      await ManpowerAPI.updateManpower(id, data);
      await fetchManpower(type); // Refresh list
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Mark manpower as left
  Future<void> leftManpower(String id, Map<String, dynamic> data, String type) async {
    try {
      await ManpowerAPI.leftManpower(id, data);
      await fetchManpower(type);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

/// Provider instance
final manpowerProvider =
StateNotifierProvider<ManpowerNotifier, ManpowerState>((ref) {
  return ManpowerNotifier();
});
