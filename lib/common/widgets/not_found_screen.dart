import 'package:base_bloc_3/import.dart';

/// The not found screen
class NotFoundScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  const NotFoundScreen({super.key, required this.uri});

  /// The uri that can not be found.
  final String uri;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(title: Text(S.current.not_found)),
      body: Center(
        child: Text(S.current.page_not_found_message(uri)),
      ),
    );
  }
}
