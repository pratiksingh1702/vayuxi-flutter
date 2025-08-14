import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';

import '../../auth/provider/auth_provider.dart';


class ModuleScreen extends ConsumerWidget {
  const ModuleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // ✅ ProtectedRoute logic
    if (!authState.isLoggedIn) {
      Future.microtask(() => context.go(Routes.login));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFCFE8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Select Module",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // ✅ Modules List
              ..._moduleItems.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildModuleItem(context, item),
              )),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black12),
                  ),
                  onPressed: () => context.push(Routes.workCategory),
                  child: const Text("Back"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build a single module button
  Widget _buildModuleItem(BuildContext context, ModuleItem item) {
    return GestureDetector(
      onTap: () => context.push(item.routeName),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [

            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

// Model for module items
class ModuleItem {
  final String label;
  final String imagePath;
  final String routeName;

  ModuleItem({required this.label, required this.imagePath, required this.routeName});
}

// All module items
final _moduleItems = [
  ModuleItem(label: "Site Details", imagePath: "assets/home/site.png", routeName: "/site-list/site"),
  ModuleItem(label: "Rate", imagePath: "assets/home/rate.png", routeName: "/site-list/rate"),
  ModuleItem(label: "Manpower Details", imagePath: "assets/home/manpower.png", routeName: "/manpower"),
  ModuleItem(label: "Create Team", imagePath: "assets/home/addTeam.png", routeName: "/site-list/team"),
  ModuleItem(label: "DPR Report", imagePath: "assets/home/dpr.png", routeName: "/site-list/dpr"),
  ModuleItem(label: "Attendance", imagePath: "assets/home/attendance.png", routeName: "attendance"),
  ModuleItem(label: "Add Expense", imagePath: "assets/home/expense.png", routeName: "expense"),
  ModuleItem(label: "Summary Analysis", imagePath: "assets/home/summary.png", routeName: "summary"),
  ModuleItem(label: "Salary", imagePath: "assets/home/salary.png", routeName: "salary"),
  ModuleItem(label: "Profile", imagePath: "assets/home/profileIcon.png", routeName: "profile"),
  ModuleItem(label: "Upgrade 2.0", imagePath: "assets/home/upgrade.png", routeName: "upgrade"),
];
