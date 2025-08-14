import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModuleDetailScreen extends StatelessWidget {
  final String moduleName;
  const ModuleDetailScreen({super.key, required this.moduleName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(moduleName.toUpperCase())),
      body: Center(
        child: Text("This is the $moduleName module page."),
      ),
    );
  }
}
