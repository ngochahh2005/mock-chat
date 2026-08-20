import 'package:base_bloc_3/common/utils/validators.dart';
import 'package:base_bloc_3/features/authen/presentation/bloc/auth_bloc.dart';
import 'package:base_bloc_3/features/authen/presentation/widget/build_email_field.dart';
import 'package:base_bloc_3/features/authen/presentation/widget/build_password_field.dart';
import 'package:base_bloc_3/import.dart';
import 'package:flutter/cupertino.dart';

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

  bool _obscurePassword = true;

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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Text(
                S.current.register,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4356B4),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                S.current.create_your_account,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 35.h),
              _buildTextField(
                controller: _controllerUsername,
                focusNode: null,
                label: S.current.username,
                icon: Icons.person_outline,
                validator: Validators.usernameValidator,
                keyboardType: TextInputType.name,
                nextFocusNode: _focusNodeEmail,
              ),
              SizedBox(height: 10.h),
              _buildTextField(
                controller: _controllerEmail,
                focusNode: _focusNodeEmail,
                label: S.current.Email,
                icon: Icons.email_outlined,
                validator: Validators.emailValidator,
                keyboardType: TextInputType.emailAddress,
                nextFocusNode: _focusNodePassword,
              ),
              SizedBox(height: 10.h),
              _buildTextField(
                controller: _controllerPassword,
                focusNode: _focusNodePassword,
                label: S.current.password,
                icon: Icons.password_outlined,
                validator: Validators.passwordValidator,
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                nextFocusNode: _focusNodeConfirmPassword,
                hasSuffixIcon: true,
                onSuffixIconPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              SizedBox(height: 10.h),
              _buildTextField(
                controller: _controllerConfirmPassword,
                focusNode: _focusNodeConfirmPassword,
                label: S.current.confirm_password,
                icon: Icons.password_outlined,
                validator: (value) => Validators.confirmPasswordValidator(
                  value,
                  _controllerPassword.text,
                ),
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
              ),
              SizedBox(height: 50.h),
              _buildRegisterButton(context),
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    FocusNode? focusNode,
    required String label,
    required IconData icon,
    required String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    FocusNode? nextFocusNode,
    bool hasSuffixIcon = false,
    VoidCallback? onSuffixIconPressed,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: hasSuffixIcon
            ? IconButton(
                onPressed: onSuffixIconPressed,
                icon: obscureText
                    ? const Icon(Icons.visibility_outlined)
                    : const Icon(Icons.visibility_off_outlined),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
      onEditingComplete: () => nextFocusNode?.requestFocus(),
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
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              getIt<AuthBloc>().add(
                AuthEvent.onRegisterEvent(
                  email: _controllerEmail.text,
                  password: _controllerPassword.text,
                  username: _controllerUsername.text,
                ),
              );
            }
          },
          child: Text(S.current.register),
        );
      },
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.current.already_have_an_account),
        TextButton(
          onPressed: () => context.push(RouteName.login),
          child: Text(S.current.signup),
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
    super.dispose();
  }
}
