import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/common/utils/validators.dart';

class BuildEmailField extends StatelessWidget {
  final TextEditingController controllerEmail;
  final FocusNode focusNode;

  const BuildEmailField({
    super.key,
    required this.controllerEmail,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllerEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'EMAIL',
        helperText: ' ',
        labelStyle: TextStyle(
          fontFamily: 'lato',
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: Color(0xff999999),
        ),
        suffixIcon: Icon(
          Icons.mail_outline_rounded,
          color: Color(0xff4356B4),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.indigo, width: 2),
        ),
      ),
      onEditingComplete: () => focusNode.requestFocus(),
      validator: Validators.usernameValidator,
    );
  }
}
