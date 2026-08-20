import 'package:base_bloc_3/features/authen/presentation/bloc/auth_bloc.dart';
import 'package:base_bloc_3/features/setting_app/bloc/setting_bloc.dart';
import 'package:base_bloc_3/features/setting_app/enum/app_locale_enum.dart';
import 'package:base_bloc_3/import.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: S.current.home_screen,
        hasBack: false,
        actions: [
          BlocListener<AuthBloc, AuthState>(
            bloc: getIt<AuthBloc>(),
            listener: (context, state) {
              if (state.isLogoutSuccess) {
                context.go(RouteName.login);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                ),
                child: IconButton(
                  onPressed: () {
                    getIt<AuthBloc>().add(const AuthEvent.onLogoutEvent());
                  },
                  icon: const Icon(Icons.logout_rounded),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${S.current.greeting}, ${user!.email}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Language: "),
                DropdownButton<AppLocaleEnum>(
                  value: getIt<SettingBloc>().state.appLocale,
                  items: AppLocaleEnum.values.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.displayName),
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
              ],
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                context.push(RouteName.chat);
              },
              child: const Text("Open Chat Screen"),
            ),
          ],
        ),
      ),
    );
  }
}
