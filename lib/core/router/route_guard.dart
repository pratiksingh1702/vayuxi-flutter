// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../features/auth/provider/auth_provider.dart';
// import 'routes.dart';
//
// // We use Riverpod container to access auth state in redirect
// String? authRedirect(context, state) {
//   final container = ProviderScope.containerOf(context, listen: false);
//   final authState = container.read(authProvider);
//
//   final path = state.uri.toString();
//   final loggedIn = authState.isLoggedIn;
//   final selectedLang = authState.otpVerified; // or a separate state
//
//   final authPages = [Routes.login];
//
//   // 1. Public route but logged in
//   if (authPages.contains(path) && loggedIn) {
//     return selectedLang ? Routes.workCategory : Routes.selectLanguage;
//   }
//
//   // 2. Protected routes but not logged in
//   if (path.startsWith(Routes.dashboard) && !loggedIn) {
//     return Routes.login;
//   }
//
//   return null; // no redirect
// }
