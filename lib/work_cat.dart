import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled2/features/auth/service/auth_client.dart';
import 'package:untitled2/typeProvider/type_provider.dart';

import 'core/router/routes.dart';
import 'features/auth/provider/auth_provider.dart';



class WorkCategoryScreen extends ConsumerStatefulWidget {
  const WorkCategoryScreen({super.key});

  @override
  ConsumerState<WorkCategoryScreen> createState() => _WorkCategoryScreenState();
}

class _WorkCategoryScreenState extends ConsumerState<WorkCategoryScreen> {
  String? selectedImage;

  void handlePress(String imageId) {
    setState(() {
      selectedImage = imageId;
    });
    final typeNotifier = ref.read(typeProvider.notifier);

    if (imageId == "mechanical") {
      typeNotifier.setType("mechanical_work");
    } else if (imageId == "insulation") {
      typeNotifier.setType("insulation_work");
    }

    context.push(Routes.selectModule);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    // ✅ ProtectedRoute Logic
    if (!authState.isLoggedIn) {
      Future.microtask(() => context.go(Routes.login));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFCFE8FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row with Profile Image and Welcome Text
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.push(Routes.profile),
                    child: CircleAvatar(
                      radius: 49,
                      backgroundImage:
                     NetworkImage("https://plus.unsplash.com/premium_photo-1690552678496-fda53292def5?q=80&w=764&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")

                      as ImageProvider,
                    ),
                  ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width * 0.65,
                  //   child: Text.rich(
                  //     TextSpan(
                  //       text: "Welcome, ",
                  //       style: const TextStyle(
                  //           fontSize: 22, fontWeight: FontWeight.bold),
                  //       children: [
                  //         TextSpan(
                  //           text: (user?.fullName ?? "").toUpperCase(),
                  //           style: const TextStyle(color: Color(0xFF1B6DCE)),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),

              const SizedBox(height: 20),

              // Company Name
              // if (user?.companyName != null)
              //   Center(
              //     child: Text(
              //       user!.companyName!,
              //       style: const TextStyle(
              //           fontSize: 22, fontWeight: FontWeight.bold),
              //     ),
              //   ),

              const SizedBox(height: 10),

              // GST Number
              // if (user?.gstNumber != null)
              //   Center(
              //     child: Text(
              //       user!.gstNumber!,
              //       style: const TextStyle(fontSize: 16),
              //     ),
              //   ),

              const SizedBox(height: 30),

              const Text(
                "Select Work Category",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 30),

              // Category Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryButton(
                    title: "Mechanical Work",
                    imagePath: 'https://plus.unsplash.com/premium_photo-1690552678496-fda53292def5?q=80&w=764&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    isSelected: selectedImage == "mechanical",
                    onTap: () => handlePress("mechanical"),
                  ),
                  _buildCategoryButton(
                    title: "Insulation Work",
                    imagePath: 'https://plus.unsplash.com/premium_photo-1690552678496-fda53292def5?q=80&w=764&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    isSelected: selectedImage == "insulation",
                    onTap: () => handlePress("insulation"),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).fetchCurrentUser();
                  final user = ref.read(authProvider).user;
                  print("Current User: $user");
                },
                child: const Text("Get Current User"),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton({
    required String title,
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.44,
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected ? const Color(0xFF005E71) : Colors.transparent,
              width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imagePath,
            height: 109,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
