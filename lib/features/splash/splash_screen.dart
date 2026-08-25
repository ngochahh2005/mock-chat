import 'package:base_bloc_3/features/authen/presentation/bloc/auth_bloc.dart';
import 'package:base_bloc_3/import.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _canNavigate = false;
  AuthState? _cachedState;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _canNavigate = true;
        });
        if (_cachedState != null) {
          _handleRouting(_cachedState!);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          _cachedState = state;

          if (_canNavigate && state.status == BaseStateStatus.success) {
            _handleRouting(state);
          }
        },
        listenWhen: (previous, current) =>
            current.status == BaseStateStatus.success,
        child: BaseScaffold(
          body: Container(
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.images.appLogo.path,
                    width: 200.w,
                    height: 200.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 12.w,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Awesome ',
                        style: TextStyle(
                          fontFamily: 'exo',
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'chat',
                        style: TextStyle(
                          fontFamily: 'exo',
                          fontWeight: FontWeight.normal,
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleRouting(AuthState state) {
    if (state.isLogin) {
      context.go(RouteName.chat);
    } else {
      context.go(RouteName.login);
    }
  }
}
