import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class SearchMessageTextField extends StatelessWidget {
  const SearchMessageTextField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: const Color(0xff4356B4),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: S.current.search_messages,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xff999999),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(
          CupertinoIcons.search,
          color: Color(0xff4356B4),
          size: 24,
        ),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: S.current.clear_search,
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
                icon: const Icon(
                  CupertinoIcons.clear_circled_solid,
                  color: Color(0xff999999),
                  size: 20,
                ),
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
