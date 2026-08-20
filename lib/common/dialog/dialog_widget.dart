import 'package:base_bloc_3/import.dart';

/// Can custom dialog by design pattern of project
class DialogWidget extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final String? content;
  final TextStyle? contentStyle;
  final Widget? child;
  final String? buttonText;
  final TextStyle? buttonTextStyle;
  final ButtonStyle? buttonStyle;
  final Function()? buttonOnPressed;
  final String? secondaryButtonText;
  final TextStyle? secondaryButtonTextStyle;
  final ButtonStyle? secondaryButtonStyle;
  final Function()? secondaryButtonOnPressed;
  const DialogWidget({
    super.key,
    this.title,
    this.titleStyle,
    this.content,
    this.contentStyle,
    this.child,
    this.buttonText,
    this.buttonTextStyle,
    this.buttonStyle,
    this.buttonOnPressed,
    this.secondaryButtonText,
    this.secondaryButtonTextStyle,
    this.secondaryButtonStyle,
    this.secondaryButtonOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: titleStyle ??
                  TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 10.h),
          ],
          if (content != null) ...[
            Text(
              content!,
              style: contentStyle ?? TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 10.h),
          ],
          if (child != null) ...[
            child!,
            SizedBox(height: 10.h),
          ],
          Row(
            children: [
              if (secondaryButtonText != null) ...[
                Expanded(
                  child: TextButton(
                    onPressed: secondaryButtonOnPressed,
                    style: secondaryButtonStyle ??
                        OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: AppColors.deepDark),
                          padding: EdgeInsets.zero,
                        ),
                    child: Text(
                      secondaryButtonText!,
                      style: secondaryButtonTextStyle ??
                          TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.deepDark,
                          ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
              ],
              Expanded(
                child: TextButton(
                  onPressed: buttonOnPressed,
                  style: buttonStyle ??
                      ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          AppColors.deepDark,
                        ),
                      ),
                  child: Text(
                    buttonText ?? S.current.ok,
                    style: buttonTextStyle ??
                        TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
