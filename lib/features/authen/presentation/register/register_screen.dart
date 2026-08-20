import 'package:base_bloc_3/common/utils/validators.dart';
import 'package:base_bloc_3/features/authen/presentation/bloc/auth_bloc.dart';
import 'package:base_bloc_3/features/authen/presentation/widget/build_email_field.dart';
import 'package:base_bloc_3/features/authen/presentation/widget/build_password_field.dart';
import 'package:base_bloc_3/features/authen/presentation/widget/build_text_field.dart';
import 'package:base_bloc_3/import.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();

  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  final ValueNotifier<bool> _isFormValid = ValueNotifier<bool>(false);

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late TapGestureRecognizer _policiesRecognizer;
  late TapGestureRecognizer _regulationsRecognizer;

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      getIt<AuthBloc>().add(
        AuthEvent.onRegisterEvent(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
          username: _controllerUsername.text,
        ),
      );
    }
  }

  void _validateFormInputs() {
    final username = _controllerUsername.text.trim();
    final email = _controllerEmail.text.trim();
    final password = _controllerPassword.text.trim();
    final confirmPassword = _controllerConfirmPassword.text.trim();

    if (email.isNotEmpty &&
        password.isNotEmpty &&
        username.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      _isFormValid.value = true;
    } else {
      _isFormValid.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _policiesRecognizer = TapGestureRecognizer()
      ..onTap = () =>
          _showBottomSheet(context, S.current.policy, "Nội dung chính sách");
    _regulationsRecognizer = TapGestureRecognizer()
      ..onTap = () => _showBottomSheet(
          context, S.current.regulation, "Nội dung của điều khoản");
    _controllerUsername.addListener(_validateFormInputs);
    _controllerEmail.addListener(_validateFormInputs);
    _controllerPassword.addListener(_validateFormInputs);
    _controllerConfirmPassword.addListener(_validateFormInputs);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            CupertinoIcons.back,
            size: 24,
            color: Color(0xff4356B4),
          ),
        ),
        backgroundColor: Colors.white,
      ),
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
                        // heading
                        SizedBox(height: 50.h),
                        Text(
                          S.current.register,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4356B4),
                          ),
                        ),
                        SizedBox(height: 35.h),

                        // username
                        BuildTextField(
                          controller: _controllerUsername,
                          focusNode: null,
                          label: S.current.username,
                          icon: Icons.person_outline,
                          validator: Validators.usernameValidator,
                          keyboardType: TextInputType.name,
                          nextFocusNode: _focusNodeEmail,
                        ),
                        SizedBox(height: 8.h),

                        // email
                        BuildTextField(
                          controller: _controllerEmail,
                          focusNode: _focusNodeEmail,
                          label: S.current.Email,
                          icon: Icons.email_outlined,
                          validator: Validators.emailValidator,
                          keyboardType: TextInputType.emailAddress,
                          nextFocusNode: _focusNodePassword,
                        ),
                        SizedBox(height: 8.h),

                        // password
                        BuildTextField(
                          controller: _controllerPassword,
                          focusNode: _focusNodePassword,
                          label: S.current.password,
                          icon: _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          validator: Validators.passwordValidator,
                          obscureText: _obscurePassword,
                          keyboardType: TextInputType.visiblePassword,
                          nextFocusNode: _focusNodeConfirmPassword,
                          onSuffixIconPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        SizedBox(height: 8.h),

                        // confirm password
                        BuildTextField(
                          controller: _controllerConfirmPassword,
                          focusNode: _focusNodeConfirmPassword,
                          label: S.current.confirm_password,
                          icon: _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          validator: (value) =>
                              Validators.confirmPasswordValidator(
                            value,
                            _controllerPassword.text,
                          ),
                          obscureText: _obscureConfirmPassword,
                          onSuffixIconPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        SizedBox(
                          height: 8.h,
                        ),

                        // terms
                        _buildTermsAddConditionsText(),

                        Spacer(
                          flex: 1,
                        ),
                        _buildRegisterButton(context),
                        Spacer(
                          flex: 2,
                        ),
                        _buildLoginLink(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      listener: (context, state) {
        if (state.isRegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              width: 200,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              behavior: SnackBarBehavior.floating,
              content: Text(S.current.registered_successfully),
            ),
          );
          context.go(RouteName.login);
        }
      },
      builder: (context, state) {
        return ValueListenableBuilder(
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
              onPressed: (isValid) ? _onRegister : null,
              child: Text(
                S.current.register.toUpperCase(),
                style: TextStyle(
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

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          S.current.already_have_an_account,
          style: TextStyle(
            color: Color(0xff999999),
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () => context.push(RouteName.login),
          child: Text(
            S.current.login,
            style: TextStyle(
              color: Color(0xff4356B4),
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
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _focusNodeConfirmPassword.dispose();
    _controllerUsername.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerConfirmPassword.dispose();
    _policiesRecognizer.dispose();
    _regulationsRecognizer.dispose();
    _isFormValid.dispose();
    super.dispose();
  }

  void _showBottomSheet(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4356B4),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                content,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTermsAddConditionsText() {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: S.current.agree_with,
              style: const TextStyle(
                color: Color(0xff999999),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: S.current.policy,
              style: TextStyle(
                color: Color(0xff4356B4),
                fontWeight: FontWeight.bold,
              ),
              recognizer: _policiesRecognizer,
            ),
            const TextSpan(
              text: " & ",
              style: TextStyle(
                color: Color(0xff999999),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: S.current.regulation,
              style: TextStyle(
                color: Color(0xff4356B4),
                fontWeight: FontWeight.bold,
              ),
              recognizer: _regulationsRecognizer,
            ),
          ],
        ),
      ),
    );
  }
}
