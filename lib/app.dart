import 'package:base_bloc_3/features/authen/presentation/bloc/auth_bloc.dart';
import 'package:base_bloc_3/features/setting_app/bloc/setting_bloc.dart';
import 'package:base_bloc_3/features/setting_app/enum/app_locale_enum.dart';
import 'package:base_bloc_3/import.dart';
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<LocalStorage>().save(PrefKeys.splashLoaded, false);
    });
    getIt<AuthBloc>().add(const AuthEvent.onAuthStarted());
    getIt<SettingBloc>().add(const SettingEvent.onInit());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {}
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        ScreenUtilsConfig.designWidth,
        ScreenUtilsConfig.designHeight,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<AuthBloc, AuthState>(
          bloc: getIt<AuthBloc>(),
          builder: (context, state) {
            return BlocBuilder<SettingBloc, SettingState>(
              bloc: getIt<SettingBloc>(),
              buildWhen: (previous, current) => previous.appLocale != current.appLocale,
              builder: (context, state) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                    fontFamily: 'lato',
                  ),
                  builder: FlutterSmartDialog.init(
                    loadingBuilder: (msg) => const LoadingWidget(),
                  ),
                  supportedLocales:
                      AppLocaleEnum.values.map((e) => e.locale).toList(),
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    S.delegate,
                  ],
                  locale: state.appLocale.locale,
                  routerConfig: router,
                );
              },
            );
          },
        );
      },
    );
  }
}
