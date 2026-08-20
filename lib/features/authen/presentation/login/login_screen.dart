import 'package:base_bloc_3/common/utils/validators.dart';
import 'package:base_bloc_3/features/authen/presentation/bloc/auth_bloc.dart';
import 'package:base_bloc_3/features/authen/presentation/widget/build_email_field.dart';
import 'package:base_bloc_3/features/authen/presentation/widget/build_password_field.dart';
import 'package:base_bloc_3/import.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState
    extends BaseShareState<LoginScreen, AuthEvent, AuthState, AuthBloc>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  final ValueNotifier<bool> _isFormValid = ValueNotifier<bool>(false);

  bool _obscurePassword = true;

  void _validateFormInputs() {
    final email = _controllerEmail.text.trim();
    final password = _controllerPassword.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      _isFormValid.value = true;
    } else {
      _isFormValid.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _controllerEmail.addListener(_validateFormInputs);
    _controllerPassword.addListener(_validateFormInputs);
  }

  @override
  Widget renderUI(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: BaseScaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 81.h),
                          Image.asset(
                            Assets.images.appLogo2.path,
                            height: 124.h,
                            width: 124.w,
                            fit: BoxFit.contain,
                          ),
                          Text(
                            S.current.experience_app,
                            style: TextStyle(
                              fontFamily: 'lato',
                              fontWeight: FontWeight.w300,
                              fontSize: 26,
                            ),
                          ),
                          Text(
                            S.current.login,
                            style: TextStyle(
                              fontFamily: 'lato',
                              fontWeight: FontWeight.w900,
                              fontSize: 32,
                              color: Color(0xff4356B4),
                            ),
                          ),
                          SizedBox(height: 30.h),
                          BuildEmailField(
                            controllerEmail: _controllerEmail,
                            focusNode: _focusNodePassword,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          BuildPasswordField(
                            controllerPassword: _controllerPassword,
                            focusNodePassword: _focusNodePassword,
                            obscurePassword: _obscurePassword,
                          ),
                          _buildForgotPasswordButton(),
                          const Spacer(
                            flex: 1,
                          ),
                          // SizedBox(height: 30.h),
                          _buildLoginButton(),
                          const Spacer(
                            flex: 2,
                          ),
                          _buildSignUpLink(context),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.isLoginSuccess != current.isLoginSuccess &&
          current.isLoginSuccess,
      listener: (context, state) {
        if (state.isLoginSuccess) {
          context.go(RouteName.home);
        }
      },
      builder: (context, state) {
        final isLoading = state.status == BaseStateStatus.loading;

        return ValueListenableBuilder<bool>(
          valueListenable: _isFormValid,
          builder: (context, isValid, child) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                disabledBackgroundColor: const Color(0xffCACACA),
                disabledForegroundColor: Colors.white,
                backgroundColor: const Color(0xff4356B4),
                foregroundColor: Colors.white,
              ),
              onPressed: (isValid && !isLoading) ? _onLoginPressed : null,
              child: Text(
                S.current.login.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'lato',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _onLoginPressed() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      final authBloc = getIt<AuthBloc>();
      if (!authBloc.isClosed) {
        authBloc.add(
          AuthEvent.onLoginEvent(
            password: _controllerPassword.text,
            email: _controllerEmail.text,
          ),
        );
      }
    }
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          S.current.do_not_have_an_account,
          style: TextStyle(
            color: Color(0xff999999),
            fontFamily: 'lato',
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () {
            _formKey.currentState?.reset();
            context.push(RouteName.register);
          },
          child: Text(
            S.current.signup,
            style: TextStyle(
              color: Color(0xff4356B4),
              fontFamily: 'lato',
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _isFormValid.dispose();
    super.dispose();
  }
}

class _buildForgotPasswordButton extends StatelessWidget {
  const _buildForgotPasswordButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          S.current.forgot_password,
          style: TextStyle(
            fontFamily: 'lato',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xff4356B4),
          ),
        ),
      ),
    );
  }
}
