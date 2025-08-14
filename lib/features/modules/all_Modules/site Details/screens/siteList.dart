import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/siteProvider.dart';
import '../repository/siteModel.dart';

class SiteListScreen extends ConsumerStatefulWidget {
  final Widget Function(SiteModel site) pageBuilder;

  const SiteListScreen({
    super.key,
    required this.pageBuilder,
  });

  @override
  ConsumerState<SiteListScreen> createState() => _SiteListScreenState();
}

class _SiteListScreenState extends ConsumerState<SiteListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(siteProvider.notifier).fetchSites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final siteState = ref.watch(siteProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Sites")),
      body: siteState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : siteState.sites.isEmpty
          ? const Center(child: Text("No sites found"))
          : RefreshIndicator(
        onRefresh: () => ref.read(siteProvider.notifier).fetchSites(),
        child: ListView.builder(
          itemCount: siteState.sites.length,
          itemBuilder: (context, index) {
            final site = siteState.sites[index];
            return ListTile(
              title: Text(site.siteName),
              subtitle: Text(site.type),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => widget.pageBuilder(site),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
