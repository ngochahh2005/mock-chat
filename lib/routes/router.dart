import 'package:base_bloc_3/common/widgets/not_found_screen.dart';
import 'package:base_bloc_3/features/category/index.dart';
import 'package:base_bloc_3/features/chat/index.dart';
import 'package:base_bloc_3/features/profile/profile_screen.dart';
import 'package:base_bloc_3/import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

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
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: child,
          bottomNavigationBar: _buildBottomNavigationBar(context, state),
        );
      },
      routes: [
        GoRoute(
          path: RouteName.chat,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: ChatPage(),
          ),
        ),
        GoRoute(
          path: RouteName.profile,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: ProfileScreen(),
          ),
        ),
      ],
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

Widget _buildBottomNavigationBar(BuildContext context, GoRouterState state) {
  final currentLocation = state.uri.toString();

  int selectedIdx = 0;
  if (currentLocation.startsWith(RouteName.friends)) {
    selectedIdx = 1;
  } else if (currentLocation.startsWith(RouteName.profile)) {
    selectedIdx = 2;
  } else if (currentLocation == RouteName.chat) {
    selectedIdx = 0;
  }

  return Container(
    margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // chat
        _buildNavItem(
          context: context,
          icon: CupertinoIcons.chat_bubble_2_fill,
          label: S.current.message,
          isSelected: selectedIdx == 0,
          badgeCount: 3,
          showDot: true,
          onTap: () => context.go(RouteName.chat),
        ),

        // friends
        _buildNavItem(
          context: context,
          icon: CupertinoIcons.person_2_fill,
          label: S.current.friends,
          isSelected: selectedIdx == 1,
          onTap: () => context.go(RouteName.friends),
          showDot: true,
        ),

        // profile
        _buildNavItem(
          context: context,
          icon: CupertinoIcons.profile_circled,
          label: S.current.profile,
          isSelected: selectedIdx == 2,
          onTap: () => context.go(RouteName.profile),
          showDot: true,
        ),
      ],
    ),
  );
}

Widget _buildNavItem({
  required BuildContext context,
  required IconData icon,
  required String label,
  required bool isSelected,
  int? badgeCount,
  bool showDot = false,
  required VoidCallback onTap,
}) {
  final color = isSelected ? const Color(0xff4356B4) : Color(0xffD2D2D2);

  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: SizedBox(
      height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showDot && isSelected)
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Color(0xff4356B4),
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(height: 9),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              if (badgeCount != null && badgeCount > 0)
                Positioned(
                  right: -10,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xffD32F2F),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      maxHeight: 16,
                      maxWidth: 16,
                    ),
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}
