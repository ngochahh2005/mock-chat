import 'package:base_bloc_3/import.dart';

/// Use when search or lazy loading list item
class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(S.current.not_found);
  }
}
