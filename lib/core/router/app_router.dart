import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled2/features/modules/all_Modules/site%20Details/repository/siteModel.dart';
import 'package:untitled2/features/modules/all_Modules/site%20Details/screens/siteList.dart';


import '../../features/auth/provider/auth_provider.dart';
import '../../features/auth/screens/login.dart';
import '../../features/modules/all_Modules/Manpower Details/model/manpower_model.dart';
import '../../features/modules/all_Modules/Manpower Details/screens/addManpower.dart';
import '../../features/modules/all_Modules/Manpower Details/screens/editManpower.dart';
import '../../features/modules/all_Modules/Manpower Details/screens/manpowerList.dart';
import '../../features/modules/all_Modules/dpr/screens/dprTeamPage.dart';
import '../../features/modules/all_Modules/rate/screens/rate.dart';
import '../../features/modules/all_Modules/site Details/screens/siteDetailScreen.dart';
import '../../features/modules/all_Modules/team/screens/addTeam.dart';
import '../../features/modules/all_Modules/team/screens/teamsList.dart';
import '../../features/profile_page/screens/profilePage.dart';
import '../../features/modules/screen/module_screen.dart';
import '../../features/modules/screen/module_detail.dart';
import '../../work_cat.dart';
import '../../core/router/routes.dart';
import 'go_router_refresh.dart';
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);


  return GoRouter(
    initialLocation: Routes.login, // Always start at login
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final loggedIn = authState.isLoggedIn;
      final loggingIn = state.matchedLocation == Routes.login;

      if (!loggedIn && !loggingIn) return Routes.login;
      if (loggedIn && loggingIn) return Routes.workCategory;
      return null;
    },

    refreshListenable: GoRouterRefreshNotifier(authProvider, ref),
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.workCategory,
        builder: (context, state) => const WorkCategoryScreen(),
      ),
      GoRoute(
        path: Routes.selectModule,
        builder: (context, state) => const ModuleScreen(),
      ),
      // GoRoute(
      //   path: Routes.siteList,
      //   builder: (context, state) => const SiteListScreen(),
      // ),
      GoRoute(
        path: '/site-list/:module',
        builder: (context, state) {
          final module = state.pathParameters['module'] ?? 'details';

          return SiteListScreen(
            pageBuilder: (site) {
              switch (module) {
                case 'rate':
                  return RateScreen(site: site);
                case 'team':
                  return TeamListPage(site: site);
                case 'dpr':
                  return DprTeamScreen(site: site);


                default:
                  return SiteDetailScreen(site: site);
              }
            },
          );
        },
      ),
      GoRoute(
        path: '/manpower',
        builder: (context, state) => const ManpowerListScreen(),
      ),
      GoRoute(
        path: '/manpower/addDetails',
        builder: (context, state) => const NewManpowerScreen(),
      ),
      GoRoute(
        path: '/edit-manpower',
        builder: (context, state) {
          final manpower = state.extra as ManpowerModel;
          return EditManpowerScreen(manpower: manpower);
        },
      ),
      GoRoute(
        path: '/add-team',
        builder: (context, state) {
          final site = state.extra as SiteModel; // retrieve it
          return AddTeamScreen(site: site);
        },
      ),




      GoRoute(
        path: '/module/:name',
        builder: (context, state) {
          final moduleName = state.pathParameters['name']!;
          return ModuleDetailScreen(moduleName: moduleName);
        },
      ),
    ],
  );
});
