import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import 'package:untitled2/typeProvider/type_provider.dart';
import '../../site Details/repository/siteModel.dart';
import '../provider/teamProvider.dart';

class TeamListPage extends ConsumerStatefulWidget {
  final SiteModel site;

  const TeamListPage({super.key, required this.site});

  @override
  ConsumerState<TeamListPage> createState() => _TeamListPageState();
}

class _TeamListPageState extends ConsumerState<TeamListPage> {
  Future<void> _refreshTeams() async {
    final type = ref.read(typeProvider);
    await ref.read(teamProvider.notifier).getTeams(type!, widget.site.id);
  }

  @override
  void initState() {
    super.initState();
    _refreshTeams();
  }

  @override
  Widget build(BuildContext context) {
    final teamState = ref.watch(teamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Teams")),
      body: teamState.when(
        data: (teams) => LiquidPullToRefresh(
          onRefresh: _refreshTeams,
          height: 200,
          backgroundColor: Colors.blue,
          color: Colors.white,
          animSpeedFactor: 2.0,
          showChildOpacityTransition: true,
          child: ListView.builder(
            itemCount: teams.length + 1,
            itemBuilder: (context, index) {
              if (index < teams.length) {
                final team = teams[index];
                return ListTile(
                  title: Text(team.teamName),
                  subtitle: Text("Lead: ${team.teamLead?.fullName ?? "N/A"}"),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/add-team', extra: widget.site);
                    },
                    child: const Text("Add Team"),
                  ),
                );
              }
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
    );
  }
}

