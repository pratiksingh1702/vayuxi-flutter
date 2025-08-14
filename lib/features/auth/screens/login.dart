import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:go_router/go_router.dart';

import '../provider/auth_provider.dart';
import '../../../core/router/routes.dart';

import '../service/auth_client.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final otpController = TextEditingController();

  String sendOtpError = "";
  String otpError = "";
  bool otpVerified = false;

  bool get isValidEmail =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(emailController.text);

  @override
  void dispose() {
    emailController.dispose();
    // otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!isValidEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid email.")),
      );
      return;
    }
    try {
      setState(() {
        sendOtpError = "";
      });
      await AuthAPI.generateLoginOtp(emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP sent successfully!")),
      );
    } catch (e) {
      setState(() {
        sendOtpError = e.toString();
      });
    }
  }

  Future<void> _verifyOtp() async {
    final otp = otpController.text;
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a 6-digit OTP.")),
      );
      return;
    }

    try {
      setState(() {
        otpError = "";
        otpVerified = false;
      });

      await ref.read(authProvider.notifier).loginWithOtp(emailController.text, otp);
      final authState = ref.read(authProvider);
      print(authState.isLoggedIn);

      if (authState.isLoggedIn) {

        setState(() => otpVerified = true);
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(Routes.workCategory);
          });
        }
      } else {
        setState(() {
          otpError = authState.errorMessage ?? "Invalid OTP";
        });
      }
    } catch (e) {
      setState(() {
        otpError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFCFE8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              const Text("Email Id",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: "Enter your email",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _sendOtp,
                    child: const Text("Send"),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              if (emailController.text.isNotEmpty)
                Text(
                  isValidEmail ? "Email-ID Verified" : "Invalid Email-ID",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: isValidEmail ? Colors.green : Colors.red,
                  ),
                ),
              const SizedBox(height: 25),
              const Text("Email OTP",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              PinCodeTextField(
                length: 6,
                appContext: context,
                controller: otpController,
                keyboardType: TextInputType.number,
                onChanged: (_) {},
              ),
              if (otpError.isNotEmpty)
                Text(
                  otpError,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.right,
                ),
              if (otpVerified)
                const Text(
                  "OTP Verified",
                  style: TextStyle(color: Colors.green),
                  textAlign: TextAlign.right,
                ),
              const SizedBox(height: 20),
              if (sendOtpError.isNotEmpty)
                Text(
                  sendOtpError,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verifyOtp,
                  child: authState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login"),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "By continuing, you're agreeing to our Terms of Service and Privacy Policy.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
