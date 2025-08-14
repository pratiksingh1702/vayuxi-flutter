import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:untitled2/features/modules/all_Modules/site%20Details/repository/siteModel.dart';

import '../../../../../typeProvider/type_provider.dart';
import '../../Manpower Details/model/manpower_model.dart';
import '../../Manpower Details/service/manPowerProvider.dart';

import '../model/teamModel.dart';

import '../provider/teamProvider.dart';


class AddTeamScreen extends ConsumerStatefulWidget {
  final SiteModel site;

  const AddTeamScreen({super.key, required this.site});

  @override
  ConsumerState<AddTeamScreen> createState() => _AddTeamScreenState();
}

class _AddTeamScreenState extends ConsumerState<AddTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();

  ManpowerModel? _selectedLead;
  List<ManpowerModel> _selectedMembers = [];

  @override
  void initState() {
    super.initState();
    final type = ref.read(typeProvider);
    Future.microtask(() {
      ref.read(manpowerProvider.notifier).fetchManpower(type!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final type = ref.watch(typeProvider);
    final manpowerState = ref.watch(manpowerProvider);

    if (manpowerState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (manpowerState.error != null) {
      return Scaffold(
        body: Center(child: Text("Error: ${manpowerState.error}")),
      );
    }

    final manpowerList = manpowerState.manpowerList
        .where((m) => m.id == widget.site.id) // adjust field
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Team")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Team Name
              TextFormField(
                controller: _teamNameController,
                decoration: const InputDecoration(labelText: "Team Name"),
                validator: (value) =>
                value!.isEmpty ? "Enter team name" : null,
              ),
              const SizedBox(height: 20),

              // Team Lead - Single Select Searchable
              DropdownSearch<ManpowerModel>(
                selectedItem: _selectedLead,
                itemAsString: (m) => m.fullName ?? '',
                items: (String filter, LoadProps? props) {
                  return manpowerState.manpowerList
                      .where((m) =>
                      m.fullName!.toLowerCase().contains(filter.toLowerCase()))
                      .toList();
                },
                compareFn: (a, b) => a.id == b.id, // ✅ Required for custom objects
                onChanged: (selected) {
                  setState(() {
                    _selectedLead = selected;
                  });
                },
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                ),
                decoratorProps: const DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: "Team Leader",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),




              const SizedBox(height: 20),

              // Team Members - Multi Select Searchable
              MultiSelectDialogField<ManpowerModel>(
                items:  manpowerState.manpowerList
                    .map((m) => MultiSelectItem<ManpowerModel>(m, m.fullName ?? ''))
                    .toList(),
                searchable: true,
                title: const Text("Select Members"),
                selectedColor: Theme.of(context).primaryColor,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue, width: 1),
                ),
                buttonText: const Text(
                  "Choose Members",
                  style: TextStyle(color: Colors.black54),
                ),
                onConfirm: (values) {
                  _selectedMembers = values;
                },
                validator: (values) =>
                values == null || values.isEmpty
                    ? "Select at least one member"
                    : null,
              ),


              const SizedBox(height: 30),

              // Save Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final formData = FormData.fromMap({
                      "teamName": _teamNameController.text,
                      "teamLead": _selectedLead?.id ?? "",
                      "teamMembers": _selectedMembers.map((m) => m.id).toList(),
                      // If uploading image:
                      // "file": await MultipartFile.fromFile(filePath, filename: fileName),
                    });

                    await ref.read(teamProvider.notifier).createTeam(
                      type: type!,
                      siteId: widget.site.id,
                      formData: formData,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text("Save Team"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
