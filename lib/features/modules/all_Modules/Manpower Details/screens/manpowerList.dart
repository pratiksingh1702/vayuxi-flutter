import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../typeProvider/type_provider.dart';
import '../model/manpower_model.dart';
import '../service/manPowerProvider.dart';
import '../util/ViewExcel.dart';

class ManpowerListScreen extends ConsumerStatefulWidget {
  const ManpowerListScreen({super.key});

  @override
  ConsumerState<ManpowerListScreen> createState() => _ManpowerListScreenState();
}

class _ManpowerListScreenState extends ConsumerState<ManpowerListScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final type = ref.read(typeProvider);
      if (type != null && type.isNotEmpty) {
        ref.read(manpowerProvider.notifier).fetchManpower(type);
      } else {
        debugPrint("❌ Type not set in typeProvider");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final manpowerState = ref.watch(manpowerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFBFE2FA), // light blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFFBFE2FA),
        elevation: 0,
        title: const Text("Employee List", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: manpowerState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : manpowerState.manpowerList.isEmpty
          ? const Center(child: Text("No manpower found"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: manpowerState.manpowerList.length,
              itemBuilder: (context, index) {
                final ManpowerModel manpower =
                manpowerState.manpowerList[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.black12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.person, size: 32, color: Colors.blue),
                    title: Text(
                      manpower.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(manpower.employeeCode ?? ""),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        context.push('/edit-manpower', extra: manpower);
                      },
                      child: const Text("Edit"),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      context.push('/manpower/addDetails');
                    },
                    child: const Text("Add Manpower Details"),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () async {
                          await exportToExcel(
                            manpowerState.manpowerList.map((m) => m.toJson()).toList(),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("✅ Excel saved in Downloads folder")),
                          );
                        },
                        child: const Text("View Sheet"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Back"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
