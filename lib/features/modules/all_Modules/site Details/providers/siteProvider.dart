import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled2/features/modules/all_Modules/site%20Details/providers/site_service.dart';

import '../../../../../typeProvider/type_provider.dart';
import '../repository/siteModel.dart';

class SiteState {
  final bool isLoading;
  final List<SiteModel> sites;
  final String? error;

  SiteState({
    this.isLoading = false,
    this.sites = const [],
    this.error,
  });

  SiteState copyWith({
    bool? isLoading,
    List<SiteModel>? sites,
    String? error,
  }) {
    return SiteState(
      isLoading: isLoading ?? this.isLoading,
      sites: sites ?? this.sites,
      error: error,
    );
  }
}

class SiteNotifier extends StateNotifier<SiteState> {
  final Ref ref;

  SiteNotifier(this.ref) : super(SiteState());

  /// Fetch sites for the current type
  Future<void> fetchSites() async {
    final type = ref.read(typeProvider);
print(type);
    if (type == null || type.isEmpty) {

      state = state.copyWith(sites: [], isLoading: false);
      return;
    }
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");

    state = state.copyWith(isLoading: true, error: null);

    try {
      final res = await SiteAPI.fetchSites(type);
      print("ressppppppppp${res}");
      final siteList = res.map((e) => SiteModel.fromJson(e)).toList();

      state = state.copyWith(isLoading: false, sites: siteList);
    } catch (e) {
      print(e);
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Add new site
  // Future<void> addSite(Map<String, dynamic> data) async {
  //   try {
  //     final type = ref.read(typeProvider);
  //     await SiteAPI.addSite(data, type ?? '');
  //     await fetchSites(); // refresh list
  //   } catch (e) {
  //     state = state.copyWith(error: e.toString());
  //   }
  // }

  Future<void> updateSite(String siteId, FormData updatedData) async {
    try {
      print("😂😂😂😂😂");
      await SiteAPI.updateSite(siteId, updatedData);
      await fetchSites(); // 🔄 Auto refresh list after update
    } catch (e) {
      print(e);
      state = state.copyWith(error: e.toString());
    }
  }
  //
  // /// Delete site
  // Future<void> deleteSite(String siteId) async {
  //   try {
  //     await SiteAPI.deleteSite(siteId);
  //     await fetchSites();
  //   } catch (e) {
  //     state = state.copyWith(error: e.toString());
  //   }
  // }
}
final siteProvider =
StateNotifierProvider<SiteNotifier, SiteState>((ref) => SiteNotifier(ref));

