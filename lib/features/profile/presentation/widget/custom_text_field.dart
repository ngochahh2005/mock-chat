import 'package:base_bloc_3/common/external_lib.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final IconData icon;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.title,
    required this.icon,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff999999),
            ),
          ),
          TextField(
            controller: controller,
            readOnly: readOnly,
            decoration: InputDecoration(
              suffixIcon: Icon(icon, color: Color(0xff4356B4)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD2D2D2)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff4356B4), width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
