import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../typeProvider/type_provider.dart';
import '../service/manPowerService.dart';
import '../service/manPowerProvider.dart';


class NewManpowerScreen extends ConsumerStatefulWidget {
  const NewManpowerScreen({super.key});

  @override
  ConsumerState<NewManpowerScreen> createState() => _NewManpowerScreenState();
}

class _NewManpowerScreenState extends ConsumerState<NewManpowerScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _fullNameController = TextEditingController();
  final _designationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _panController = TextEditingController();
  final _bankController = TextEditingController();
  final _ifscController = TextEditingController();
  final _epfController = TextEditingController();
  final _uanController = TextEditingController();
  final _esicController = TextEditingController();
  final _salaryController = TextEditingController();
  final _remarksController = TextEditingController();

  DateTime? _dob;
  DateTime? _doj;
  String _payBasic = "monthly";

  Future<void> _pickDate(BuildContext context, bool isDOB) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
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

  void _resetForm() {
    _formKey.currentState?.reset();
    _fullNameController.clear();
    _designationController.clear();
    _phoneController.clear();
    _aadhaarController.clear();
    _panController.clear();
    _bankController.clear();
    _ifscController.clear();
    _epfController.clear();
    _uanController.clear();
    _esicController.clear();
    _salaryController.clear();
    _remarksController.clear();
    _dob = null;
    _doj = null;
    _payBasic = "monthly";
  }

  Future<void> _saveManpower() async {
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
      "aadharNumber": _aadhaarController.text,
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
      await ref.read(manpowerProvider.notifier).addManpower(manpowerType, data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Manpower added successfully")),
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
        title: const Text("New Employee Details"),
        backgroundColor: const Color(0xFFBFE2FA),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Full Name*", _fullNameController, true),
              _buildTextField("Designation*", _designationController, true),
              _buildTextField("Phone Number", _phoneController, false),
              _buildTextField("Aadhar Number", _aadhaarController, false),
              _buildTextField("PAN Number", _panController, false),
              _buildTextField("Bank Account Number", _bankController, false),
              _buildTextField("IFSC Code", _ifscController, false),
              _buildTextField("EPF Number", _epfController, false),
              _buildTextField("UAN Number", _uanController, false),
              _buildTextField("ESIC Number", _esicController, false),

              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker("Date of Birth", _dob, true),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDatePicker("Date of Joining", _doj, false),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _payBasic,
                items: const [
                  DropdownMenuItem(value: "monthly", child: Text("Monthly")),
                  DropdownMenuItem(value: "daily", child: Text("Daily")),
                ],
                onChanged: (val) {
                  setState(() {
                    _payBasic = val!;
                  });
                },
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
                      onPressed: _saveManpower,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Save & Submit"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _resetForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Reset"),
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
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: required
            ? (value) => value == null || value.isEmpty ? "$label is required" : null
            : null,
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, bool isDOB) {
    return InkWell(
      onTap: () => _pickDate(context, isDOB),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        child: Text(date != null
            ? "${date.day}-${date.month}-${date.year}"
            : "Select Date"),
      ),
    );
  }
}
