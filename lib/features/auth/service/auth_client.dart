import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/dio.dart';

class AuthAPI {
  static final dio = DioClient.dio;
  /// Signup
  static Future<Map<String, dynamic>> signup(Map<String, dynamic> data) async {
    final res = await dio.post("/auth/signup", data: data);
    return res.data;
  }

  /// Generate Email OTP
  static Future<Map<String, dynamic>> generateEmailOtp(String email) async {
    final res = await dio.post("/auth/generate-email-otp", data: {"email": email});
    return res.data;
  }

  /// Verify Email OTP
  static Future<Map<String, dynamic>> verifyEmailOtp(String email, String otp) async {
    final res = await dio.post("/auth/verify-email-otp", data: {"email": email, "otp": otp});
    return res.data;
  }

  /// Generate Login OTP
  static Future<Map<String, dynamic>> generateLoginOtp(String email) async {
    final res = await dio.post("/auth/generate-login-otp", data: {"email": email});
    return res.data;
  }

  /// Verify Login OTP (saves cookie)
  static Future<Map<String, dynamic>> verifyLoginOtp(String email, String otp) async {
    final res = await dio.post("/auth/verify-login", data: {"email": email, "otp": otp});
    return res.data;
  }

  /// Update User
  static Future<Map<String, dynamic>> updateUser(String id, Map<String, dynamic> data) async {
    final res = await dio.post("/user/$id", data: data);
    return res.data;
  }

  /// Logout
  static Future<Map<String, dynamic>> logout() async {
    final res = await dio.post("/auth/logout");
    return res.data;
  }

  /// Logout All Devices
  static Future<Map<String, dynamic>> logoutAll() async {
    final res = await dio.post("/auth/logout-all-device");
    return res.data;
  }

  /// Get Current User (needs cookie)
  static Future<Map<String, dynamic>> getCurrentUser() async {




    final response = await dio.get(
      '/user/me',

    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception(response.data['message'] ?? "Failed to fetch user");
    }
  }

  /// Get User by ID
  static Future<Map<String, dynamic>> getUserById(String id) async {
    final res = await dio.get("/user/$id");
    return res.data;
  }
}
