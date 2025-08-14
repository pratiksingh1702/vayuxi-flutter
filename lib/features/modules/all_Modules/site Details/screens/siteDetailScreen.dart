import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';


import '../providers/siteProvider.dart';
import '../repository/siteModel.dart';
import '../providers/site_service.dart';

class SiteDetailScreen extends ConsumerStatefulWidget {
  final SiteModel? site; // null if creating new site

  const SiteDetailScreen({super.key, this.site});

  @override
  ConsumerState<SiteDetailScreen> createState() => _SiteDetailScreenState();
}

class _SiteDetailScreenState extends ConsumerState<SiteDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController siteNameController;
  late TextEditingController addressController;
  late TextEditingController contactPersonController;
  late TextEditingController gstNoController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController documentNumberController;

  DateTime? selectedDate;
  File? selectedImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final site = widget.site;

    siteNameController = TextEditingController(text: site?.siteName ?? "");
    addressController = TextEditingController(text: site?.address ?? "");
    contactPersonController = TextEditingController(text: site?.contactPerson ?? "");
    gstNoController = TextEditingController(text: site?.gstNo ?? "");
    phoneController = TextEditingController(text: site?.phoneNumber ?? "");
    emailController = TextEditingController(text: site?.emailId ?? "");
    documentNumberController = TextEditingController(text: site?.documentNumber ?? "");

    if (site?.documentDate != null && site!.documentDate!.isNotEmpty) {
      selectedDate = DateTime.tryParse(site.documentDate!);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> saveSite() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // ✅ Use FormData for file + text fields
      final formData = FormData.fromMap({
        "siteName": siteNameController.text,
        "address": addressController.text,
        "contactPerson": contactPersonController.text,
        "phoneNumber": phoneController.text,
        "gstNo": gstNoController.text,
        "emailId": emailController.text,
        // "documentDate": selectedDate != null
        //     ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        //     : "",
        "documentNumber": documentNumberController.text,
        "company": widget.site?.company ?? "",
        "type": widget.site?.type ?? "mechanical_work",
      });

      if (selectedImage != null) {
        formData.files.add(MapEntry(
          "file",
          await MultipartFile.fromFile(
            selectedImage!.path,
            filename: selectedImage!.path.split('/').last,
          ),
        ));
      }

      if (widget.site == null) {
        // await SiteAPI.createSite(formData);
      } else {
        await SiteAPI.updateSite(widget.site!.id, formData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Site saved successfully!")));
        ref.read(siteProvider.notifier).fetchSites();
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }


  // Future<void> deleteSite() async {
  //   if (widget.site == null) return;
  //
  //   setState(() => isLoading = true);
  //
  //   try {
  //     await SiteAPI.deleteSite(widget.site!.id);
  //     ref.read(siteProvider.notifier).fetchSites();
  //     if (mounted) {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(const SnackBar(content: Text("Site deleted")));
  //       Navigator.pop(context, true);
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text("Error deleting site: $e")));
  //   } finally {
  //     if (mounted) setState(() => isLoading = false);
  //   }
  // }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: (val) => val == null || val.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final site = widget.site;

    return Scaffold(
      appBar: AppBar(title: Text(site == null ? "Add Site" : "Edit Site")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Upload
              Text("Site Image", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: selectedImage != null
                      ? Image.file(selectedImage!, fit: BoxFit.cover)
                      : site?.siteName != null
                      ? Center(child: Text("Tap to change image"))
                      : Center(child: Text("Tap to upload image")),
                ),
              ),
              const SizedBox(height: 20),

              buildTextField("Site Name", siteNameController),
              buildTextField("GST Number", gstNoController),
              buildTextField("Address", addressController),
              buildTextField("Contact Person", contactPersonController),
              buildTextField("Phone Number", phoneController,
                  type: TextInputType.phone),
              buildTextField("Email ID", emailController,
                  type: TextInputType.emailAddress),

              const SizedBox(height: 16),
              // Date Picker
              Text("AMC Date", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              // InkWell(
              //   onTap: pickDate,
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Colors.grey),
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Text(selectedDate != null
              //         ? DateFormat('yyyy-MM-dd').format(selectedDate!)
              //         : "Select Date"),
              //   ),
              // ),
              const SizedBox(height: 16),
              buildTextField("AMC Number", documentNumberController),

              const SizedBox(height: 20),
              Row(
                children: [
                  // if (site != null)
                  //   Expanded(
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //           backgroundColor: Colors.red),
                  //       onPressed: isLoading ? null : deleteSite,
                  //       child: const Text("Remove"),
                  //     ),
                  //   ),
                  if (site != null) const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : saveSite,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Save & Submit"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text("Back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
