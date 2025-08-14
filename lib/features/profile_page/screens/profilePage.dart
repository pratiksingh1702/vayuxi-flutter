// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../core/router/routes.dart';
//
// import '../../../core/widgets/user/common_button.dart';
// import '../../../core/widgets/user/common_input.dart';
// import '../../../core/widgets/user/toggle_input.dart';
// import '../../auth/provider/authProvider.dart';
// import '../provider/userProvider.dart';
//
// class ProfileScreen extends ConsumerStatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends ConsumerState<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   final _fullNameController = TextEditingController();
//   final _gstController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _companyNameController = TextEditingController();
//   final _otherController = TextEditingController();
//
//   File? profilePhoto;
//   File? companyLogo;
//
//   List<String> selectedServices = [];
//
//   final serviceKeys = [
//     "mechanical_work",
//     "painting",
//     "construction_work",
//     "insulation_work",
//     "plumbing",
//     "rooting_work",
//     "others",
//   ];
//
//   Future<void> pickImage(bool isProfile) async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         if (isProfile) {
//           profilePhoto = File(picked.path);
//         } else {
//           companyLogo = File(picked.path);
//         }
//       });
//     }
//   }
//
//   void saveProfile() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     await ref.read(userProvider.notifier).updateUser(
//       fullName: _fullNameController.text,
//       gstNumber: _gstController.text,
//
//       companyName: _companyNameController.text,
//
//
//     );
//
//     if (context.mounted) context.push(Routes.workCategory);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);
//     final userState = ref.watch(userProvider);
//
//     if (!authState.isLoggedIn) {
//       Future.microtask(() => context.go(Routes.login));
//     }
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFCFE8FA),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(10),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),
//                 const Text("Your Profile",
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//
//                 const SizedBox(height: 20),
//
//                 // Profile Photo Picker
//                 GestureDetector(
//                   onTap: () => pickImage(true),
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundImage: profilePhoto != null
//                         ? FileImage(profilePhoto!)
//                         : (authState.user?.profilePhoto != null
//                         ? NetworkImage(authState.user!.profilePhoto!)
//                         : const AssetImage('assets/home/Profile.png'))
//                     as ImageProvider,
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//                 CommonInput(
//                   controller: _fullNameController,
//                   label: "Full Name",
//                   validator: (v) =>
//                   v!.isEmpty ? "Full Name is required" : null,
//                 ),
//                 const SizedBox(height: 20),
//                 CommonInput(
//                   controller: _gstController,
//                   label: "GST Number",
//                 ),
//                 const SizedBox(height: 20),
//                 CommonInput(
//                   controller: _addressController,
//                   label: "Address",
//                 ),
//                 const SizedBox(height: 20),
//                 CommonInput(
//                   controller: _companyNameController,
//                   label: "Company Name",
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Company Logo Picker
//                 GestureDetector(
//                   onTap: () => pickImage(false),
//                   child: Container(
//                     height: 100,
//                     width: double.infinity,
//                     color: Colors.white,
//                     child: companyLogo != null
//                         ? Image.file(companyLogo!, fit: BoxFit.cover)
//                         : const Center(child: Text("Upload Company Logo")),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//                 const Text("Select Services",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),
//
//                 Column(
//                   children: serviceKeys.map((service) {
//                     final isSelected = selectedServices.contains(service);
//                     return ToggleInputBox(
//                       label: service.replaceAll('_', ' ').toUpperCase(),
//                       isActive: isSelected,
//                       onToggle: () {
//                         setState(() {
//                           if (isSelected) {
//                             selectedServices.remove(service);
//                           } else {
//                             selectedServices.add(service);
//                           }
//                         });
//                       },
//                     );
//                   }).toList(),
//                 ),
//
//                 const SizedBox(height: 20),
//                 CommonInput(
//                   controller: _otherController,
//                   label: "Mention Others",
//                 ),
//
//                 const SizedBox(height: 30),
//                 CommonButton(label: "Save & Submit", onPressed: saveProfile),
//                 const SizedBox(height: 10),
//                 CommonButton(
//                   label: "Back",
//                   variant: ButtonVariant.secondary,
//                   onPressed: () => context.pop(),
//                 ),
//                 const SizedBox(height: 10),
//                 // CommonButton(
//                 //   label: "Logout",
//                 //   variant: ButtonVariant.danger,
//                 //   onPressed: () => ref.read(authProvider.notifier).logout(),
//                 // ),
//                 // const SizedBox(height: 10),
//                 // CommonButton(
//                 //   label: "Logout All Devices",
//                 //   variant: ButtonVariant.danger,
//                 //   onPressed: () => ref.read(authProvider.notifier).logoutAll(),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
