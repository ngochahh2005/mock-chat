import 'package:base_bloc_3/common/widgets/not_found_screen.dart';
import 'package:base_bloc_3/features/category/index.dart';
import 'package:base_bloc_3/features/chat/index.dart';
import 'package:base_bloc_3/features/splash/splash_screen.dart';
import 'package:base_bloc_3/import.dart';
import 'package:firebase_auth/firebase_auth.dart';

final router = GoRouter(
  initialLocation: RouteName.splash,
  // redirect: (context, state) {
  //   final loggedIn = FirebaseAuth.instance.currentUser != null;
  //   final isAuthRoute = state.matchedLocation == RouteName.login || state.matchedLocation == RouteName.register;
  //   if (!loggedIn && !isAuthRoute) {
  //     return RouteName.login;
  //   }
  //   if (loggedIn && isAuthRoute) {
  //     return RouteName.home;
  //   }
  //   return null;
  // },
  errorBuilder: (context, state) =>
      NotFoundScreen(uri: state.extra as String? ?? ''),
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: RouteName.splash,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: SplashScreen(),
      ),
    ),
    GoRoute(
      path: RouteName.home,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          MaterialPage<void>(key: state.pageKey, child: HomeScreen()),
    ),
    GoRoute(
      path: RouteName.login,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          MaterialPage<void>(key: state.pageKey, child: const LoginScreen()),
    ),
    GoRoute(
      path: RouteName.register,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          MaterialPage<void>(key: state.pageKey, child: const RegisterScreen()),
    ),
    GoRoute(
      path: RouteName.talkerScreen,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          MaterialPage<void>(
        child: TalkerScreen(
          talker: getIt<Talker>(),
        ),
      ),
    ),
    GoRoute(
      path: RouteName.category,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: CategoryPage(),
      ),
    ),
    GoRoute(
      path: RouteName.chat,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: ChatPage(),
      ),
    ),
    GoRoute(
      path: RouteName.chatDetail,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final roomId = extra['roomId'] as String;
        final peerName = extra['peerName'] as String;

        return MaterialPage(
          key: state.pageKey,
          child: ChatDetailPage(roomId: roomId, peerName: peerName),
        );
      },
    ),
  ],
);
