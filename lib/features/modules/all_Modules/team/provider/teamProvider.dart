import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled2/features/modules/all_Modules/team/provider/teamService.dart';
import 'package:dio/dio.dart';
import '../model/teamModel.dart';

final teamProvider =
StateNotifierProvider<TeamNotifier, AsyncValue<List<TeamModel>>>((ref) {
  return TeamNotifier();
});

class TeamNotifier extends StateNotifier<AsyncValue<List<TeamModel>>> {
  TeamNotifier() : super(const AsyncValue.loading());

  Future<void> getTeams(String type, String siteId) async {
    state = const AsyncValue.loading();
    try {
      final teams = await TeamApi.fetchTeams(type: type, siteId: siteId);
      state = AsyncValue.data(teams);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Create a new team
  Future<void> createTeam({
    required String type,
    required String siteId,
    required FormData formData,
  }) async {
    try {
      // Create the team
      await TeamApi.createTeam(
        siteId: siteId,
        type: type,
        data: formData,
      );

      // Refresh the list after creation
      await getTeams(type, siteId);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// For single team details
final teamDetailsProvider =
FutureProvider.family<TeamModel, Map<String, String>>((ref, params) async {
  return await TeamApi.fetchTeamById(
    siteId: params["siteId"]!,
    teamId: params["teamId"]!,
  );
});
