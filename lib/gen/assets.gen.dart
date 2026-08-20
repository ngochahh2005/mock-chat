// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $EnvGen {
  const $EnvGen();

  /// File path: env/.env_dev
  String get aEnvDev => 'env/.env_dev';

  /// File path: env/.env_production
  String get aEnvProduction => 'env/.env_production';

  /// File path: env/.env_staging
  String get aEnvStaging => 'env/.env_staging';

  /// List of all assets
  List<String> get values => [aEnvDev, aEnvProduction, aEnvStaging];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/app_logo.png
  AssetGenImage get appLogo =>
      const AssetGenImage('assets/images/app_logo.png');

  /// File path: assets/images/app_logo_2.png
  AssetGenImage get appLogo2 =>
      const AssetGenImage('assets/images/app_logo_2.png');

  /// File path: assets/images/ic_profile.svg
  SvgGenImage get icProfile =>
      const SvgGenImage('assets/images/ic_profile.svg');

  /// File path: assets/images/loading.png
  AssetGenImage get loading => const AssetGenImage('assets/images/loading.png');

  /// List of all assets
  List<dynamic> get values => [appLogo, appLogo2, icProfile, loading];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/ic_arrow_left.svg
  SvgGenImage get icArrowLeft =>
      const SvgGenImage('assets/svg/ic_arrow_left.svg');

  /// File path: assets/svg/ic_arrow_right.svg
  SvgGenImage get icArrowRight =>
      const SvgGenImage('assets/svg/ic_arrow_right.svg');

  /// File path: assets/svg/ic_blue_arrow_down.svg
  SvgGenImage get icBlueArrowDown =>
      const SvgGenImage('assets/svg/ic_blue_arrow_down.svg');

  /// File path: assets/svg/ic_blue_plus.svg
  SvgGenImage get icBluePlus =>
      const SvgGenImage('assets/svg/ic_blue_plus.svg');

  /// File path: assets/svg/ic_close.svg
  SvgGenImage get icClose => const SvgGenImage('assets/svg/ic_close.svg');

  /// File path: assets/svg/ic_close_dialog.svg
  SvgGenImage get icCloseDialog =>
      const SvgGenImage('assets/svg/ic_close_dialog.svg');

  /// File path: assets/svg/ic_done.svg
  SvgGenImage get icDone => const SvgGenImage('assets/svg/ic_done.svg');

  /// File path: assets/svg/ic_error.svg
  SvgGenImage get icError => const SvgGenImage('assets/svg/ic_error.svg');

  /// File path: assets/svg/ic_error_hexagon.svg
  SvgGenImage get icErrorHexagon =>
      const SvgGenImage('assets/svg/ic_error_hexagon.svg');

  /// File path: assets/svg/ic_eye.svg
  SvgGenImage get icEye => const SvgGenImage('assets/svg/ic_eye.svg');

  /// File path: assets/svg/ic_eye_off.svg
  SvgGenImage get icEyeOff => const SvgGenImage('assets/svg/ic_eye_off.svg');

  /// File path: assets/svg/ic_image_default.svg
  SvgGenImage get icImageDefault =>
      const SvgGenImage('assets/svg/ic_image_default.svg');

  /// File path: assets/svg/ic_profile.svg
  SvgGenImage get icProfile => const SvgGenImage('assets/svg/ic_profile.svg');

  /// File path: assets/svg/ic_round_checked.svg
  SvgGenImage get icRoundChecked =>
      const SvgGenImage('assets/svg/ic_round_checked.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        icArrowLeft,
        icArrowRight,
        icBlueArrowDown,
        icBluePlus,
        icClose,
        icCloseDialog,
        icDone,
        icError,
        icErrorHexagon,
        icEye,
        icEyeOff,
        icImageDefault,
        icProfile,
        icRoundChecked
      ];
}

abstract final class Assets {
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
  static const $EnvGen env = $EnvGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
