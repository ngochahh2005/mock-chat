import 'package:base_bloc_3/features/authen/presentation/bloc/auth_bloc.dart';
import 'package:base_bloc_3/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:base_bloc_3/features/setting_app/bloc/setting_bloc.dart';
import 'package:base_bloc_3/features/setting_app/enum/app_locale_enum.dart';
import 'package:base_bloc_3/import.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState
    extends BaseState<ProfilePage, ProfileEvent, ProfileState, ProfileBloc>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    bloc.add(const ProfileEvent.fetchProfile());
  }

  void _goToEditPage(BuildContext context) async {
    await context.push(RouteName.editProfile);
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {});
    bloc.add(const ProfileEvent.fetchProfile());
  }

  @override
  Widget renderUI(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      listener: (context, state) {
        if (state.isLogoutSuccess) {
          context.go(RouteName.login);
        }
      },
      child: BlocBuilder<SettingBloc, SettingState>(
        bloc: getIt<SettingBloc>(),
        builder: (context, state) {
          return BlocBuilder<ProfileBloc, ProfileState>(
              bloc: getIt<ProfileBloc>(),
              builder: (context, state) {
                final user = FirebaseAuth.instance.currentUser;
                return Scaffold(
                  extendBody: true,
                  body: Stack(
                    children: [
                      // background avatar
                      _UserAvatar(user: user!),

                      Positioned.fill(
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: SizedBox(height: 270.h),
                            ),
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30),
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  // Giữ nguyên màu trắng từ Container bọc ngoài
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 24, bottom: 100),
                                    child: Column(
                                      children: [
                                        // user info
                                        UserInfo(user: user, onTap: () => _goToEditPage(context),),
                                        SizedBox(
                                          height: 8.h,
                                        ),

                                        DividerApp(),

                                        // language
                                        AppLanguage(),

                                        DividerFeatures(),

                                        // notification
                                        AppNotification(),

                                        DividerFeatures(),

                                        // app version
                                        ListTile(
                                          leading: Icon(
                                            CupertinoIcons.arrow_2_circlepath,
                                            color: Color(0xff999999),
                                            size: 24,
                                          ),
                                          title: Text(S.current.app_version,
                                              style: TextStyle(fontSize: 18)),
                                          trailing: Text(
                                            '1.0.0',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff999999),
                                            ),
                                          ),
                                        ),

                                        DividerApp(),

                                        // logout
                                        ListTile(
                                          leading: Icon(
                                            CupertinoIcons.square_arrow_right,
                                            color: Color(0xffC92323),
                                            size: 24,
                                          ),
                                          title: Text(
                                            S.current.logout,
                                            style: TextStyle(
                                              color: Color(0xffC92323),
                                              fontSize: 18,
                                            ),
                                          ),
                                          onTap: () {
                                            getIt<AuthBloc>()
                                                .add(AuthEvent.onLogoutEvent());
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}

class DividerApp extends StatelessWidget {
  const DividerApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Divider(
        height: 2,
        thickness: 4,
        color: Color(0xffEFEEEE),
      ),
    );
  }
}

class DividerFeatures extends StatelessWidget {
  const DividerFeatures({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Divider(
        height: 1,
        thickness: 1,
        indent: 50,
        endIndent: 24,
        color: Color(0xffEFEEEE),
      ),
    );
  }
}

class AppNotification extends StatelessWidget {
  const AppNotification({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        CupertinoIcons.bell,
        color: Color(0xff999999),
        size: 24,
      ),
      title: Text(
        S.current.notification,
        style: TextStyle(fontSize: 18),
      ),
      trailing: Icon(
        CupertinoIcons.forward,
        color: Color(0xff999999),
        size: 24,
      ),
    );
  }
}

class AppLanguage extends StatelessWidget {
  const AppLanguage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        CupertinoIcons.globe,
        color: Color(0xff999999),
        size: 24,
      ),
      title: Text(
        S.current.language,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<AppLocaleEnum>(
          dropdownColor: Colors.white,
          value: getIt<SettingBloc>().state.appLocale,
          items: AppLocaleEnum.values.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(
                e.displayName,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff4356B4),
                ),
              ),
            );
          }).toList(),
          onChanged: (appLocale) {
            if (appLocale != null) {
              getIt<SettingBloc>().add(
                SettingEvent.onChangeAppLocale(
                  appLocaleEnum: appLocale,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
    required this.user,
    required this.onTap,
  });

  final User user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16.w,
        ),
        Container(
          height: 62.h,
          width: 62.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff4356B4),
                Color(0xff3DCFCF),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(1, 2),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: user.photoURL != null
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user.photoURL!,
                    fit: BoxFit.cover,
                    height: 60.h,
                    width: 60.w,
                  ),
                )
              : Icon(
                  CupertinoIcons.person_solid,
                  size: 40,
                  color: Colors.white,
                ),
        ),
        SizedBox(
          width: 12.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.displayName ?? 'Awesome Chat',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              user.email ?? '',
              style: TextStyle(
                color: Color(0xff999999),
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        Spacer(
          flex: 1,
        ),
        IconButton(
          onPressed: onTap,
          icon: Icon(
            Icons.edit,
            size: 30,
            color: Color(0xff4356B4),
          ),
        ),
        SizedBox(
          width: 16.w,
        ),
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      child: user.photoURL != null
          ? CachedNetworkImage(
              imageUrl: user.photoURL ?? '',
              fit: BoxFit.cover,
              height: 300.h,
            )
          : Container(
              height: 300.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff4356B4),
                    Color(0xff3DCFCF),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Icon(
                CupertinoIcons.profile_circled,
                size: 100,
                color: Colors.white,
              ),
            ),
    );
  }
}
