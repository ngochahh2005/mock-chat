import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter/cupertino.dart';

class SearchUsernameTextField extends StatelessWidget {
  const SearchUsernameTextField({
    super.key,
    required this.bloc,
  });

  final ChatBloc bloc;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Color(0xff4356B4),
      decoration: InputDecoration(
        hintText: "Tìm kiếm username...",
        hintStyle: TextStyle(
          fontSize: 16,
          color: Color(0xff999999),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          CupertinoIcons.search,
          color: Color(0xff4356B4),
          size: 24,
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
      onChanged: (val) => bloc.add(ChatEvent.searchUser(val)),
    );
  }
}
