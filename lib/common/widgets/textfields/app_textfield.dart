import 'package:base_bloc_3/import.dart';

enum TextFieldState {
  none,
  validateSucceeded,
  validateFailed,
  showMessage,
}

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final double radius;
  final Color borderColor;
  final Color focusBorderColor;
  final Color? cursorColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final String? hintText;
  final String? initText;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final bool readOnly;
  final double paddingRightIcon;
  final FocusNode? focusNode;
  final EdgeInsets? padding;
  final Color? bgChangeColor;
  final Color? borderChangeColor;
  final bool autofocus;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Widget in the bubble
  final Widget? messageContent;

  ///flag to show/ hide content in text field
  final bool isPassword;

  ///flag to determine state of text field
  final TextFieldState state;

  ///Error text below the text field
  final String? errorText;
  final int? maxLine;
  final int? maxLength;
  final bool isShowIconSucceeded;
  final bool isShowIconFailed;
  final List<FilteringTextInputFormatter>? listTextInputFormatter;

  /// Leading icon
  final Widget? leadingIcon;

  /// Input Action
  final TextInputAction? inputAction;

  const AppTextField({
    Key? key,
    this.controller,
    this.readOnly = false,
    this.radius = 8,
    this.borderColor = const Color(0xFFEBEBEB),
    this.focusBorderColor = AppColors.deepDark,
    this.textStyle,
    this.cursorColor,
    this.backgroundColor,
    this.hintText,
    this.hintStyle,
    this.isPassword = false,
    this.isShowIconSucceeded = true,
    this.isShowIconFailed = true,
    this.state = TextFieldState.none,
    this.errorText,
    this.messageContent,
    this.keyboardType,
    this.initText,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.padding,
    this.maxLine = 1,
    this.maxLength,
    this.paddingRightIcon = 8,
    this.listTextInputFormatter,
    this.leadingIcon,
    this.bgChangeColor,
    this.borderChangeColor,
    this.inputAction,
    this.autofocus = false,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  bool isObscure = false;
  bool isFocus = false;

  late TextStyle _textStyle;
  late TextFieldState _state;
  late FocusNode myFocusNode;

  @override
  void initState() {
    isObscure = widget.isPassword;
    _textStyle = widget.textStyle ??
        TextStyle(
          fontSize: 13.sp,
          color: AppColors.deepDark,
          fontWeight: FontWeight.w300,
          fontFamily: robotoFont,
          leadingDistribution: TextLeadingDistribution.even,
        );
    _state = widget.state;
    _controller =
        widget.controller ?? TextEditingController(text: widget.initText);
    myFocusNode = widget.focusNode ?? FocusNode();
    super.initState();
  }

  void _toggleObscure() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  void _onFocusChange(bool val) {
    setState(() {
      isFocus = val;
    });
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != _state) {
      setState(() {
        _state = widget.state;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myFocusNode.requestFocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isFocus
                  ? (widget.bgChangeColor ?? widget.backgroundColor)
                  : widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(
                color: _borderColor,
              ),
            ),
            padding: widget.padding ??
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
            child: Row(
              children: [
                if (widget.leadingIcon != null)
                  Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: widget.leadingIcon!,
                  ),
                Expanded(
                  child: Focus(
                    onFocusChange: _onFocusChange,
                    child: TextField(
                      focusNode: myFocusNode,
                      inputFormatters: widget.listTextInputFormatter,
                      onChanged: widget.onChanged,
                      onSubmitted: widget.onSubmitted,
                      readOnly: widget.readOnly,
                      cursorColor: widget.cursorColor ?? Colors.black,
                      obscureText: isObscure,
                      obscuringCharacter: '●',
                      autofocus: widget.autofocus,
                      maxLength: widget.maxLength,
                      keyboardType: widget.keyboardType,
                      maxLines: widget.maxLine,
                      textInputAction: widget.inputAction,
                      scrollPadding: EdgeInsets.zero,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                        isCollapsed: true,
                        hintText: widget.hintText ?? "",
                        hintStyle: widget.hintStyle ??
                            TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.deepDark.withOpacity(0.5),
                              fontWeight: FontWeight.w300,
                              fontFamily: robotoFont,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                      ),
                      style: _textStyle.copyWith(color: _textColor),
                      controller: _controller,
                    ),
                  ),
                ),
                if (_state == TextFieldState.validateSucceeded)
                  if (widget.isShowIconSucceeded)
                    Padding(
                      padding:
                          EdgeInsets.only(right: widget.paddingRightIcon.w),
                      child: Assets.svg.icDone.svg(),
                    ),
                if (_state == TextFieldState.validateFailed && !isFocus)
                  if (widget.isShowIconFailed)
                    Padding(
                      padding:
                          EdgeInsets.only(right: widget.paddingRightIcon.w),
                      child: Assets.svg.icError.svg(),
                    ),
                if (widget.isPassword)
                  InkWell(
                    onTap: _toggleObscure,
                    child: isObscure
                        ? Assets.svg.icEye.svg()
                        : Assets.svg.icEyeOff.svg(),
                  ),
              ],
            ),
          ),
          if ((widget.errorText ?? "").isNotEmpty &&
              _state == TextFieldState.validateFailed &&
              !isFocus)
            Padding(
              padding: EdgeInsets.only(top: 8.0.h),
              child: Text(
                widget.errorText!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFFFE5050),
                  fontWeight: FontWeight.w400,
                  fontFamily: robotoFont,
                  height: 14.06 / 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color get _borderColor {
    if (_state == TextFieldState.validateFailed && !isFocus) {
      return const Color(0xFFFE5050);
    }
    if (_state == TextFieldState.showMessage) {
      return const Color(0xFFCEE1FF);
    }
    if (isFocus) {
      return widget.focusBorderColor;
    } else {
      return isFocus
          ? (widget.borderChangeColor ?? widget.borderColor)
          : widget.borderColor;
    }
  }

  Color get _textColor {
    if (_state == TextFieldState.validateFailed && !isFocus) {
      return const Color(0xFFFE5050);
    }
    return _textStyle.color ?? AppColors.deepDark;
  }
}
