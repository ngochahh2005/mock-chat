import 'package:base_bloc_3/common/external_lib.dart';
import 'package:flutter/cupertino.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        width: 75.w,
        height: 75.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Platform.isAndroid
              ? const CircularProgressIndicator()
              : const CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}
