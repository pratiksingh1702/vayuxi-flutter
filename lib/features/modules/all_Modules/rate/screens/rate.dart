

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../site Details/repository/siteModel.dart';

class RateScreen extends StatelessWidget {
  final SiteModel site;

  const RateScreen({super.key, required this.site});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Screen for ${site.siteName}'),
      ),
      body: Center(
        child: Text(
          'Here we will display rates for site: ${site.siteName}',
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
