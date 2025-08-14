import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../typeProvider/type_provider.dart';
import '../model/manpower_model.dart';
import '../service/manPowerProvider.dart';


class EditManpowerScreen extends ConsumerStatefulWidget {
  final ManpowerModel manpower;

  const EditManpowerScreen({super.key, required this.manpower});

  @override
  ConsumerState<EditManpowerScreen> createState() => _EditManpowerScreenState();
}

class _EditManpowerScreenState extends ConsumerState<EditManpowerScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _fullNameController;
  late TextEditingController _designationController;
  late TextEditingController _phoneController;

  late TextEditingController _panController;
  late TextEditingController _bankController;
  late TextEditingController _ifscController;
  late TextEditingController _epfController;
  late TextEditingController _uanController;
  late TextEditingController _esicController;
  late TextEditingController _salaryController;
  late TextEditingController _remarksController;

  DateTime? _dob;
  DateTime? _doj;
  String _payBasic = "monthly";

  @override
  void initState() {
    super.initState();

    final m = widget.manpower;

    _fullNameController = TextEditingController(text: m.fullName);
    _designationController = TextEditingController(text: m.designation);
    _phoneController = TextEditingController(text: m.phoneNumber ?? "");

    _panController = TextEditingController(text: m.panNumber ?? "");
    _bankController = TextEditingController(text: m.bankAccountNumber ?? "");
    _ifscController = TextEditingController(text: m.ifscCode ?? "");
    _epfController = TextEditingController(text: m.epfNumber ?? "");
    _uanController = TextEditingController(text: m.uanNumber ?? "");
    _esicController = TextEditingController(text: m.esicNumber ?? "");
    _salaryController = TextEditingController(text: m.salary.toString() ?? "");
    _remarksController = TextEditingController(text: m.remarks ?? "");
    _payBasic = m.payBasics ?? "monthly";

    if (m.dateOfBirth != null) _dob = DateTime.tryParse(m.dateOfBirth!);
    if (m.dateOfJoining != null) _doj = DateTime.tryParse(m.dateOfJoining!);
  }

  Future<void> _pickDate(BuildContext context, bool isDOB) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isDOB) {
          _dob = picked;
        } else {
          _doj = picked;
        }
      });
    }
  }

  Future<void> _updateManpower() async {
    if (!_formKey.currentState!.validate()) return;

    final manpowerType = ref.read(typeProvider);
    if (manpowerType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: No manpower type selected")),
      );
      return;
    }

    final data = {
      "fullName": _fullNameController.text,
      "designation": _designationController.text,
      "phoneNumber": _phoneController.text,

      "panNumber": _panController.text,
      "bankAccountNumber": _bankController.text,
      "ifscCode": _ifscController.text,
      "epfNumber": _epfController.text,
      "uanNumber": _uanController.text,
      "esicNumber": _esicController.text,
      "dateOfBirth": _dob?.toIso8601String(),
      "dateOfJoining": _doj?.toIso8601String(),
      "payBasics": _payBasic,
      "salary": double.tryParse(_salaryController.text) ?? 0,
      "remarks": _remarksController.text,
    };

    try {
      await ref
          .read(manpowerProvider.notifier)
          .updateManpower(widget.manpower.id!, data,manpowerType);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Manpower updated successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFE2FA),
      appBar: AppBar(
        title: const Text("Edit Employee Details"),
        backgroundColor: const Color(0xFFBFE2FA),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Full Name*", _fullNameController, true),
              _buildTextField("Designation*", _designationController, true),
              _buildTextField("Phone Number", _phoneController, false),

              _buildTextField("PAN Number", _panController, false),
              _buildTextField("Bank Account Number", _bankController, false),
              _buildTextField("IFSC Code", _ifscController, false),
              _buildTextField("EPF Number", _epfController, false),
              _buildTextField("UAN Number", _uanController, false),
              _buildTextField("ESIC Number", _esicController, false),

              Row(
                children: [
                  Expanded(child: _buildDatePicker("Date of Birth", _dob, true)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildDatePicker("Date of Joining", _doj, false)),
                ],
              ),

              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _payBasic,
                items: const [
                  DropdownMenuItem(value: "monthly", child: Text("Monthly")),
                  DropdownMenuItem(value: "daily", child: Text("Daily")),
                ],
                onChanged: (val) => setState(() => _payBasic = val!),
                decoration: const InputDecoration(labelText: "Pay Basics*"),
              ),
              const SizedBox(height: 10),
              _buildTextField("Salary*", _salaryController, true,
                  keyboard: TextInputType.number),
              _buildTextField("Remarks", _remarksController, false),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _updateManpower,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Update & Save"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Back"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      bool required, {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: required
            ? (value) => value == null || value.isEmpty
            ? "$label is required"
            : null
            : null,
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, bool isDOB) {
    return InkWell(
      onTap: () => _pickDate(context, isDOB),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(date != null
            ? "${date.day}-${date.month}-${date.year}"
            : "Select Date"),
      ),
    );
  }
}
