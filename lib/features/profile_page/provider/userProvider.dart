// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../auth/provider/authProvider.dart';
//
//
// class UserState {
//   final UserModel? user;
//   final bool isLoading;
//   final String? errorMessage;
//
//   UserState({this.user, this.isLoading = false, this.errorMessage});
//
//   UserState copyWith({
//     UserModel? user,
//     bool? isLoading,
//     String? errorMessage,
//   }) {
//     return UserState(
//       user: user ?? this.user,
//       isLoading: isLoading ?? this.isLoading,
//       errorMessage: errorMessage,
//     );
//   }
// }
//
// class UserNotifier extends StateNotifier<UserState> {
//   UserNotifier() : super(UserState(user: UserModel(id: "1")));
//
//   /// Simulate fetching user profile (from Auth or API)
//   Future<void> fetchUser() async {
//     state = state.copyWith(isLoading: true);
//     await Future.delayed(const Duration(seconds: 1));
//
//     // ✅ Use dummy user from authProvider simulation
//     state = state.copyWith(
//       user: UserModel(
//         id: "1",
//         fullName: "Pratik Singh",
//         companyName: "Hello Company",
//         gstNumber: "GST12345",
//         profilePhoto: null,
//       ),
//       isLoading: false,
//     );
//   }
//
//   /// Simulate updating user profile
//   Future<void> updateUser({
//     String? fullName,
//     String? companyName,
//     String? gstNumber,
//     String? profilePhoto,
//   }) async {
//     state = state.copyWith(isLoading: true);
//     await Future.delayed(const Duration(seconds: 1));
//
//     state = state.copyWith(
//       user: UserModel(
//         id: state.user?.id ?? "1",
//         fullName: fullName ?? state.user?.fullName,
//         companyName: companyName ?? state.user?.companyName,
//         gstNumber: gstNumber ?? state.user?.gstNumber,
//         profilePhoto: profilePhoto ?? state.user?.profilePhoto,
//       ),
//       isLoading: false,
//     );
//   }
// }
//
// final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
//   return UserNotifier();
// });
