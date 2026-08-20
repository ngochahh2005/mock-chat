import 'package:base_bloc_3/import.dart';

class DialogUtils {
  /// [title] is the title of the dialog.
  ///
  /// [titleStyle] is the style of the title.
  ///
  /// [content] is the content of the dialog.
  ///
  /// [contentStyle] is the style of the content.
  ///
  /// [child] is the custom widget of the dialog (images, checkbox,...) show under the content.
  ///
  /// [buttonText] is the text of the default button.
  ///
  /// [buttonTextStyle] is the style of the default button's text.
  ///
  /// [buttonOnPressed] is the callback of the default button.
  ///
  /// [secondaryButtonText] is the text of the secondary button.
  ///
  /// [secondaryButtonTextStyle] is the style of the secondary button's text.
  ///
  /// [secondaryButtonOnPressed] is the callback of the secondary button.
  ///
  /// [callbackAfterClose] is the flag to determine whether the callback should be called after the dialog is closed.
  ///
  /// [barrierDismissible] is the flag to determine whether the dialog can be dismissed by tapping the modal barrier.
  ///
  /// Example:
  /// ```dart
  /// DialogUtils.showDialog(
  ///   title: "Dialog Title",
  ///   content: "This is a dialog content",
  ///   buttonText: "OK",
  ///   buttonOnPressed: () {
  ///     // Do something when close dialog
  ///   },
  /// );
  /// ```
  static Future<dynamic> showDialog({
    String? title,
    TextStyle? titleStyle,
    String? content,
    TextStyle? contentStyle,
    Widget? child,
    String? buttonText,
    TextStyle? buttonTextStyle,
    Function()? buttonOnPressed,
    String? secondaryButtonText,
    TextStyle? secondaryButtonTextStyle,
    Function()? secondaryButtonOnPressed,
    bool callbackAfterClose = false,
    bool barrierDismissible = false,
  }) {
    return SmartDialog.show(
      tag: "dialog",
      clickMaskDismiss: !barrierDismissible,
      backType: barrierDismissible ? SmartBackType.block : SmartBackType.normal,
      builder: (BuildContext context) {
        return DialogWidget(
          title: title,
          titleStyle: titleStyle,
          content: content,
          contentStyle: contentStyle,
          buttonText: buttonText,
          buttonTextStyle: buttonTextStyle,
          buttonOnPressed: () {
            if (callbackAfterClose) {
              closeDialog();
              buttonOnPressed?.call();
            } else {
              buttonOnPressed?.call();
              closeDialog();
            }
          },
          secondaryButtonText: secondaryButtonText,
          secondaryButtonTextStyle: secondaryButtonTextStyle,
          secondaryButtonOnPressed: () {
            if (callbackAfterClose) {
              closeDialog();
              secondaryButtonOnPressed?.call();
            } else {
              secondaryButtonOnPressed?.call();
              closeDialog();
            }
          },
          child: child,
        );
      },
    );
  }

  /// [child] is custom dialog widget
  ///
  /// [tag] is dialog's tag, handle close dialog by SmartDialog.dismiss(tag: "tag")
  ///
  /// [barrierDismissible] is the flag to determine whether the dialog can be dismissed by tapping the modal barrier.
  ///
  /// Example:
  /// ```dart
  /// DialogUtils.showCustomDialog(
  ///   tag: "custom-dialog",
  ///   child: Container(
  ///     color: Colors.white,
  ///     child: InkWell(
  ///       onTap: () => SmartDialog.dismiss(tag: "custom-dialog"),
  ///       child: const Text("Custom Dialog"),
  ///     ),
  ///   ),
  /// );
  /// ```
  static Future<dynamic> showCustomDialog({
    required Widget child,
    String? tag,
    bool barrierDismissible = false,
  }) {
    return SmartDialog.show(
      tag: tag,
      clickMaskDismiss: !barrierDismissible,
      backType: barrierDismissible ? SmartBackType.block : SmartBackType.normal,
      builder: (BuildContext context) {
        return child;
      },
    );
  }

  /// Close common dialog
  static void closeDialog() {
    SmartDialog.dismiss(tag: "dialog");
  }

  /// Show loading layer over screen
  static Future<dynamic> showLoading() {
    return SmartDialog.show(
      tag: 'loading',
      clickMaskDismiss: false,
      backType: SmartBackType.ignore,
      animationType: SmartAnimationType.centerFade_otherSlide,
      keepSingle: true,
      builder: (BuildContext context) {
        return const LoadingWidget();
      },
    );
  }

  /// Hide loading layer
  static void hideLoading() {
    SmartDialog.dismiss(tag: 'loading');
  }
}
