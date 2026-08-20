import 'package:base_bloc_3/common/external_lib.dart';

class BuildTextField extends StatelessWidget {
  TextEditingController controller;
  FocusNode? focusNode;
  String label;
  IconData icon;
  String? Function(String?)? validator;
  TextInputType? keyboardType;
  bool obscureText;
  FocusNode? nextFocusNode;
  VoidCallback? onSuffixIconPressed;

  BuildTextField({
    super.key,
    required this.controller,
    this.focusNode,
    required this.label,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.nextFocusNode,
    this.onSuffixIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: 18,
      ),
      decoration: InputDecoration(
        helperText: ' ',
        labelText: label.toUpperCase(),
        labelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: Color(0xff999999),
        ),
        suffixIcon: IconButton(
          onPressed: onSuffixIconPressed,
          icon: Icon(
            icon,
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
      validator: validator,
      onEditingComplete: () => nextFocusNode?.requestFocus(),
    );
  }
}
