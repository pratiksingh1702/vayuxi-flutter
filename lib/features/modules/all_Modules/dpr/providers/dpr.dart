import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dprModel.dart';
import 'dprService.dart';

final dprProvider = StateNotifierProvider<DprNotifier, AsyncValue<List<DprModel>>>((ref) {
  return DprNotifier();
});

class DprNotifier extends StateNotifier<AsyncValue<List<DprModel>>> {
  DprNotifier() : super(const AsyncValue.loading());

  Future<void> getDprWork(String siteId, String teamId) async {
    state = const AsyncValue.loading();
    try {
      final data = await DprApi.fetchDprWork(siteId: siteId, teamId: teamId);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createDprWork(String siteId, String teamId, Map<String, dynamic> payload) async {
    try {
      final newWork = await DprApi.postDprWork(siteId: siteId, teamId: teamId, data: payload);
      state.whenData((items) => state = AsyncValue.data([...items, newWork]));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
