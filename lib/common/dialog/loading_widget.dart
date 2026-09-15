import 'package:base_bloc_3/common/external_lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: SpinKitFadingCircle(
        size: 50,
        color: Color(0xff4356B4),
      )
      // Container(
      //   width: 75.w,
      //   height: 75.w,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(8.r),
      //   ),
      //   child: Center(
      //     child: Platform.isAndroid
      //         ? const CircularProgressIndicator()
      //         : const CupertinoActivityIndicator(),
      //   ),
      // ),
    );
  }
}
