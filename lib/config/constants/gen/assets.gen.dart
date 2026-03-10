// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $EnvGen {
  const $EnvGen();

  /// File path: env/.gitignore
  String get aGitignore => 'env/.gitignore';

  /// File path: env/example.env
  String get example => 'env/example.env';

  /// List of all assets
  List<String> get values => [aGitignore, example];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/arrow_cross.svg
  String get arrowCross => 'assets/icons/arrow_cross.svg';

  /// List of all assets
  List<String> get values => [arrowCross];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// Directory path: assets/images/onboarding
  $AssetsImagesOnboardingGen get onboarding =>
      const $AssetsImagesOnboardingGen();

  /// List of all assets
  List<AssetGenImage> get values => [logo];
}

class $AssetsLottieGen {
  const $AssetsLottieGen();

  /// File path: assets/lottie/loading_screen.json
  String get loadingScreen => 'assets/lottie/loading_screen.json';

  /// List of all assets
  List<String> get values => [loadingScreen];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/README.md
  String get readme => 'assets/translations/README.md';

  /// File path: assets/translations/en-GB.json
  String get enGB => 'assets/translations/en-GB.json';

  /// File path: assets/translations/ne-NP.json
  String get neNP => 'assets/translations/ne-NP.json';

  /// List of all assets
  List<String> get values => [readme, enGB, neNP];
}

class $AssetsVideosGen {
  const $AssetsVideosGen();

  /// File path: assets/videos/splash.mp4
  String get splash => 'assets/videos/splash.mp4';

  /// List of all assets
  List<String> get values => [splash];
}

class $AssetsImagesOnboardingGen {
  const $AssetsImagesOnboardingGen();

  /// File path: assets/images/onboarding/onboarding_image_four.png
  AssetGenImage get onboardingImageFour =>
      const AssetGenImage('assets/images/onboarding/onboarding_image_four.png');

  /// File path: assets/images/onboarding/onboarding_image_one.png
  AssetGenImage get onboardingImageOne =>
      const AssetGenImage('assets/images/onboarding/onboarding_image_one.png');

  /// File path: assets/images/onboarding/onboarding_image_three.png
  AssetGenImage get onboardingImageThree => const AssetGenImage(
    'assets/images/onboarding/onboarding_image_three.png',
  );

  /// File path: assets/images/onboarding/onboarding_image_two.png
  AssetGenImage get onboardingImageTwo =>
      const AssetGenImage('assets/images/onboarding/onboarding_image_two.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    onboardingImageFour,
    onboardingImageOne,
    onboardingImageThree,
    onboardingImageTwo,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLottieGen lottie = $AssetsLottieGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
  static const $AssetsVideosGen videos = $AssetsVideosGen();
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

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
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
