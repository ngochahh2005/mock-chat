import 'package:base_bloc_3/import.dart';

class BaseScaffold extends StatelessWidget {
  final GlobalKey? scaffoldKey;
  final Widget? appBar;
  final Widget? body;
  final bool hasTabBar;
  final double? appBarHeight;
  final bool? addKey;
  final bool? resizeToAvoidBottomInset;
  final String? backgroundImage;
  final bool? hasDismissKeyboard;
  final bool? marginTop;
  final bool? isFull;
  final bool? isBottom;
  final Widget? bottomNavigation;
  final bool extendBodyBehindAppBar;
  final Color backgroundColor;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Function(bool)? showFloat;
  final Function(bool)? onScroll;
  final double? paddingTop;
  final bool hasSearchTextField;
  final Widget? endDrawer;
  final bool endDrawerEnableOpenDragGesture;

  const BaseScaffold({
    super.key,
    this.scaffoldKey,
    this.appBar,
    this.marginTop,
    this.addKey,
    this.isBottom,
    this.backgroundImage,
    this.backgroundColor = Colors.white,
    this.isFull,
    this.extendBodyBehindAppBar = false,
    this.hasDismissKeyboard,
    this.body,
    this.bottomNavigation,
    this.resizeToAvoidBottomInset,
    this.showFloat,
    this.onScroll,
    this.hasTabBar = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.paddingTop,
    this.appBarHeight,
    this.hasSearchTextField = true,
    this.endDrawer,
    this.endDrawerEnableOpenDragGesture = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        key: scaffoldKey,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        bottomNavigationBar: bottomNavigation,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        backgroundColor: backgroundColor,
        appBar: appBar == null
            ? null
            : PreferredSize(
                preferredSize: Size.fromHeight(
                  appBarHeight ??
                      (hasSearchTextField
                          ? (AppBar().preferredSize.height +
                              (hasTabBar ? kToolbarHeight.h : 0))
                          : kToolbarHeight.h),
                ),
                child: appBar!,
              ),
        body: Stack(
          children: [
            if ((backgroundImage ?? "").isNotEmpty)
              Container(
                height: 1.sh,
                width: 1.sw,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(backgroundImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
            SafeArea(
              top: false,
              bottom: isBottom ?? true,
              child: Padding(
                padding: EdgeInsets.only(
                  top: paddingTop ?? 0,
                ),
                child: body ?? const SizedBox(),
              ),
            ),
          ],
        ),
        endDrawer: endDrawer,
        endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      ),
    );
  }
}
