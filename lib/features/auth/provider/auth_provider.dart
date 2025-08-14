import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/auth_client.dart';

class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final bool otpVerified;
  final String? errorMessage;
  final Map<String, dynamic>? user;

  AuthState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.otpVerified = false,
    this.errorMessage,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    bool? otpVerified,
    String? errorMessage,

    Map<String, dynamic>? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      otpVerified: otpVerified ?? this.otpVerified,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    checkLogin(); // ✅ Auto-check login on provider initialization
  }


  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print("lllllllllllllllllllllllllllll");
    print(token);
    if (token != null && token.isNotEmpty) {
      state = state.copyWith(isLoggedIn: true, otpVerified: true);
    }
  }

  /// ✅ Save token after login
  Future<void> saveLogin(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    state = state.copyWith(isLoggedIn: true, otpVerified: true);
  }

  Future<void> loginWithOtp(String email, String otp) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final res = await AuthAPI.verifyLoginOtp(email, otp);

      // ✅ Extract token from API response
      final token = res['token']?['token'];
      if (token != null) {
        await saveLogin(token); // <-- Save token to SharedPreferences
      }

      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        otpVerified: true,
        user: res['user'],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }


  Future<void> logout() async {
    await AuthAPI.logout();
    state = AuthState(isLoggedIn: false);
  }

  Future<void> fetchCurrentUser() async {
    try {
      final res = await AuthAPI.getCurrentUser();
      state = state.copyWith(user: res, isLoggedIn: true);
    } catch (_) {
      state = AuthState();
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
