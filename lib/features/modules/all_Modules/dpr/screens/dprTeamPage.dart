import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../site Details/repository/siteModel.dart';

import '../providers/dpr.dart';

class DprTeamScreen extends ConsumerStatefulWidget {
  final SiteModel site;

  const DprTeamScreen({super.key, required this.site});

  @override
  ConsumerState<DprTeamScreen> createState() => _DprTeamScreenState();
}

class _DprTeamScreenState extends ConsumerState<DprTeamScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // Here you can replace with the correct teamId or fetch teams first
      ref.read(dprProvider.notifier).getDprWork(widget.site.id, "teamId_here");
    });
  }

  @override
  Widget build(BuildContext context) {
    final dprState = ref.watch(dprProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('DPR Teams - ${widget.site.siteName ?? "Site"}'),
      ),
      body: dprState.when(
        data: (teams) => ListView.builder(
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(team.name),
                subtitle: Text("ID: ${team.id}"),
                onTap: () {
                  // Navigate to DPR details page
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text("Error: $err"),
        ),
      ),
    );
  }
}
