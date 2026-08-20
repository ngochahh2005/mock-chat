import 'package:base_bloc_3/import.dart';
import 'package:flutter/cupertino.dart';

class BaseAppBar extends StatelessWidget {
  final String? title;
  final String? icon;
  final bool? hasBack;
  final Widget? leading;
  final double? elevation;
  final double? leadingWidth;
  final Widget? appBarWidget;
  final PreferredSize? bottom;
  final List<Widget>? actions;
  final double? titleSpacing;
  final Function()? onPressedLeading;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Color? leadingColor;
  final SystemUiOverlayStyle? systemUiOverlayStyle;
  final bool? backwardsCompatibility;
  final Color? textColor;
  final dynamic result;
  final Widget? leadingIcon;
  final Color? shadowColor;

  const BaseAppBar({
    super.key,
    this.backgroundColor,
    this.titleSpacing,
    this.title,
    this.icon,
    this.leading,
    this.leadingWidth,
    this.hasBack,
    this.bottom,
    this.leadingColor,
    this.appBarWidget,
    this.textStyle,
    this.textColor,
    this.elevation,
    this.backwardsCompatibility,
    this.actions,
    this.onPressedLeading,
    this.result,
    this.systemUiOverlayStyle,
    this.leadingIcon,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation ?? 0.7,
      shadowColor: shadowColor,
      leadingWidth: leadingWidth,
      titleSpacing: 0,
      systemOverlayStyle: systemUiOverlayStyle ?? SystemUiOverlayStyle.dark,
      leading: leading ??
          Visibility(
            visible: hasBack ?? true,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if (onPressedLeading != null) {
                  onPressedLeading!();
                } else {
                  context.pop(result);
                }
              },
              child: leadingIcon ??
                  Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.primary,
                    size: 22.sp,
                  ),
            ),
          ),
      title: appBarWidget ??
          Text(
            title ?? '',
            maxLines: 1,
            style: textStyle ??
                TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.deepDark,
                  fontWeight: FontWeight.w700,
                  fontFamily: robotoFont,
                ),
          ),
      actions: actions ?? [SizedBox(width: 5.w)],
      bottom: bottom,
      centerTitle: true,
      // flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //       image:
      //       DecorationImage(image: AssetImage(Res.bg_app_bar), fit: BoxFit.fill),
      //     )),
    );
  }
}
