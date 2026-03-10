import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../config/constants/colors/material/material_primitive_colors.dart';
import '../../../../../../../config/constants/text/material/app_material_text_primitives.dart';
import '../../../../../../../config/themes/components_theme/app_picture_theme.dart';
import '../../../../extensions/size/size_extension.dart';
import '../../../../extensions/theme/theme_extension.dart';
import '../text/app_text_widget.dart';

class AppSvgPicture extends StatelessWidget {
  const AppSvgPicture.fromNetwork(
    String url, {
    this.alt,
    super.key,
    this.height,
    this.width,
    this.onTap,
    this.theme,
  }) : path = url,
       isNetwork = true,
       isIcon = false;

  const AppSvgPicture.fromAsset(
    String assetPath, {
    this.alt,
    super.key,
    this.height,
    this.width,
    this.onTap,
    this.theme,
  }) : path = assetPath,
       isNetwork = false,
       isIcon = false;

  const AppSvgPicture.icon(
    String assetIconPath, {
    this.alt,
    super.key,
    this.width = 24,
    this.height = 24,
    this.onTap,
    this.theme,
  }) : path = assetIconPath,
       isNetwork = false,
       isIcon = true;

  const AppSvgPicture.networkIcon(
    String url, {
    this.alt,
    super.key,
    this.width = 24,
    this.height = 24,
    this.onTap,
    this.theme,
  }) : path = url,
       isNetwork = true,
       isIcon = true;
  final String path;
  final String? alt;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool isNetwork;
  final bool isIcon;
  final PictureTheme? theme;

  double get _defaultHeight => height ?? 10;
  double get _defaultWidth => width ?? 10;

  ColorFilter? get _colorFilter => theme?.color != null
      ? ColorFilter.mode(theme!.color!, BlendMode.srcIn)
      : null;

  ImageProvider getImageProvider() {
    return isNetwork ? NetworkImage(path) : AssetImage(path) as ImageProvider;
  }

  @override
  Widget build(BuildContext context) {
    final child = (isIcon)
        ? Container(
            padding: theme?.containerPadding ?? 4.allPadding,
            width: theme?.containerWidth,
            height: theme?.containerHeight,
            decoration: BoxDecoration(
              color: theme?.backgroundColor,
              borderRadius: theme?.borderRadius,
              shape: theme?.borderRadius != null
                  ? BoxShape.rectangle
                  : BoxShape.circle,
              border: Border.all(
                color: theme?.borderColor ?? Colors.transparent,
                width: theme?.borderWidth ?? 0,
              ),
            ),
            child: isNetwork
                ? SvgPicture.network(
                    path,
                    width: _defaultWidth,
                    height: _defaultHeight,
                    fit: theme?.fit ?? BoxFit.cover,
                    alignment: theme?.alignment ?? Alignment.center,
                    colorFilter: _colorFilter,
                    semanticsLabel: theme?.semanticsLabel,
                    matchTextDirection: theme?.matchTextDirection ?? false,
                    errorBuilder: (context, error, stackTrace) =>
                        ImageNoDataWidget(
                          title: alt,
                          theme: theme,
                          width: width,
                          height: height,
                        ),
                    placeholderBuilder: (context) => ImagePlaceholderWidget(
                      theme: theme,
                      width: width,
                      height: height,
                    ),
                  )
                : SvgPicture.asset(
                    path,
                    width: _defaultWidth,
                    height: _defaultHeight,
                    fit: theme?.fit ?? BoxFit.cover,
                    alignment: theme?.alignment ?? Alignment.center,
                    colorFilter: _colorFilter,
                    semanticsLabel: theme?.semanticsLabel,
                    matchTextDirection: theme?.matchTextDirection ?? false,
                    errorBuilder: (context, error, stackTrace) =>
                        ImageNoDataWidget(
                          title: alt,
                          theme: theme,
                          width: width,
                          height: height,
                        ),
                    placeholderBuilder: (context) => ImagePlaceholderWidget(
                      theme: theme,
                      width: width,
                      height: height,
                    ),
                  ),
          )
        : (isNetwork)
        ? SvgPicture.network(
            path,
            width: _defaultWidth,
            height: _defaultHeight,
            fit: theme?.fit ?? BoxFit.cover,
            alignment: theme?.alignment ?? Alignment.center,
            colorFilter: _colorFilter,
            semanticsLabel: theme?.semanticsLabel,
            matchTextDirection: theme?.matchTextDirection ?? false,
            errorBuilder: (context, error, stackTrace) => ImageNoDataWidget(
              title: alt,
              theme: theme,
              width: width,
              height: height,
            ),
            placeholderBuilder: (context) => ImagePlaceholderWidget(
              theme: theme,
              width: width,
              height: height,
            ),
          )
        : SvgPicture.asset(
            path,
            width: _defaultWidth,
            height: _defaultHeight,
            fit: theme?.fit ?? BoxFit.cover,
            alignment: theme?.alignment ?? Alignment.center,
            colorFilter: _colorFilter,
            semanticsLabel: theme?.semanticsLabel,
            matchTextDirection: theme?.matchTextDirection ?? false,
            errorBuilder: (context, error, stackTrace) => ImageNoDataWidget(
              title: alt,
              theme: theme,
              width: width,
              height: height,
            ),
            placeholderBuilder: (context) => ImagePlaceholderWidget(
              theme: theme,
              width: width,
              height: height,
            ),
          );

    return onTap != null ? GestureDetector(onTap: onTap, child: child) : child;
  }
}

class ImagePlaceholderWidget extends StatelessWidget {
  const ImagePlaceholderWidget({
    super.key,
    this.theme,
    this.width,
    this.height,
  });
  final PictureTheme? theme;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme?.backgroundColor,
        borderRadius: theme?.borderRadius,
        shape: theme?.borderRadius != null
            ? BoxShape.rectangle
            : BoxShape.circle,
        border: Border.all(
          color: theme?.borderColor ?? Colors.transparent,
          width: theme?.borderWidth ?? 0,
        ),
      ),
      width: width,
      height: height,
      child: Center(
        child: CircularProgressIndicator(color: theme?.color ?? Colors.blue),
      ),
    );
  }
}

class ImageNoDataWidget extends StatelessWidget {
  const ImageNoDataWidget({
    super.key,
    this.title,
    this.theme,
    this.width,
    this.height,
    this.textStyle,
  });

  final String? title;
  final PictureTheme? theme;
  final double? width;
  final double? height;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    // 1. Get the first letter, uppercase it
    final trimmedTitle = title?.replaceAll(' ', '').trim();
    final letter = (trimmedTitle != null && trimmedTitle.isNotEmpty)
        ? trimmedTitle[0].toUpperCase()
        : 'C';

    // 2. Determine Shape (Safety logic from previous fix)
    final BoxShape effectiveShape =
        theme?.shape ??
        (theme?.borderRadius != null ? BoxShape.rectangle : BoxShape.circle);

    // 3. Calculate dynamic font size based on container size
    // Fallback to 40 if width/height are null (e.g. inside a flex container)
    final double sizeBase = (width ?? height ?? 40);
    final double calculatedFontSize =
        (sizeBase * 0.3).sp; // Text is 50% of container size

    return Container(
      decoration: BoxDecoration(
        color:
            theme?.backgroundColor ??
            context.colors.outlineVariant, // Default to light gray if null
        borderRadius: effectiveShape == BoxShape.rectangle
            ? theme?.borderRadius
            : null,
        shape: effectiveShape,
        border: Border.all(
          color: theme?.borderColor ?? AppMaterialPrimitives.transparent,
          width: theme?.borderWidth ?? 0,
        ),
      ),
      padding: theme?.containerPadding ?? 4.allPadding,
      width: width,
      height: height,
      alignment: Alignment.center, // Forces child to center
      child: AppText(
        letter,
        translate: false,
        textAlign: TextAlign.center,
        style:
            textStyle?.copyWith(
              fontSize: calculatedFontSize, // Apply dynamic size
              height:
                  1.0, // FIX: Removes vertical font padding for true centering
              color: theme?.color ?? context.colors.outline,
            ) ??
            context.textStyles.headlineSmall
                .copyWith(fontWeight: AppMaterialTextPrimitives.semibold)
                .copyWith(
                  // Start with a bold style (h2)
                  fontSize: calculatedFontSize,
                  height: 1.0,
                  color: theme?.color ?? context.colors.outline,
                  fontWeight: FontWeight.bold,
                ),
      ),
    );
  }
}
