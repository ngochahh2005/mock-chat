import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/common/utils/validators.dart';
import 'package:base_bloc_3/generated/l10n.dart';

class BuildPasswordField extends StatefulWidget {
  TextEditingController controllerPassword;
  FocusNode focusNodePassword;
  bool obscurePassword;

  BuildPasswordField({
    super.key,
    required this.controllerPassword,
    required this.focusNodePassword,
    required this.obscurePassword,
  });

  @override
  State<StatefulWidget> createState() => _BuildPasswordFieldState();
}

class _BuildPasswordFieldState extends State<BuildPasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controllerPassword,
      focusNode: widget.focusNodePassword,
      obscureText: widget.obscurePassword,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: S.current.password.toUpperCase(),
        helperText: ' ',
        labelStyle: TextStyle(
          fontFamily: 'lato',
          fontSize: 14,
          color: Color(0xff999999),
          fontWeight: FontWeight.normal,
        ),
        suffixIcon: IconButton(
          onPressed: _togglePasswordVisibility,
          icon: Icon(
            widget.obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Color(0xff4356B4),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.indigo, width: 2),
        ),
      ),
      validator: Validators.passwordValidator,
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      widget.obscurePassword = !widget.obscurePassword;
    });
  }
}
