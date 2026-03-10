import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../config/constants/colors/material/material_primitive_colors.dart';
import '../../../../../../../config/constants/images/app_default_images.dart';
import '../../../../extensions/size/size_extension.dart';
import '../../common/no_logo_widget.dart';
import '../loaders/app_circular_loader.dart';

class AppCachedNetworkImage extends StatelessWidget {
  /// Avatar Factory: Pre-configured for circular images
  factory AppCachedNetworkImage.avatar({
    required String? imageUrl,
    required String alt,
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Color borderColor = AppMaterialPrimitives.secondary50,
    double borderWidth = 2.0,
    Widget? errorWidget,
  }) {
    return AppCachedNetworkImage(
      key: key,
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      shape: BoxShape.circle,
      borderColor: borderColor,
      borderWidth: borderWidth,
      errorWidget:
          errorWidget ??
          _buildNoLogoFallback(
            alt: alt,
            width: width,
            height: height,
            borderColor: borderColor,
            borderWidth: borderWidth,
          ),
      // If URL is null, we want to show the NoLogoWidget immediately
      placeholder: imageUrl == null || imageUrl.isEmpty
          ? _buildNoLogoFallback(
              alt: alt,
              width: width,
              height: height,
              borderColor: borderColor,
              borderWidth: borderWidth,
            )
          : null,
    );
  }

  /// Default Constructor
  const AppCachedNetworkImage({
    required this.imageUrl,
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.placeholder,
    this.errorWidget,
    this.imageBuilder,
    this.border,
    this.usePlaceholderIfUrlEmpty = true,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BoxShape shape;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final Border? border;

  /// Custom widgets
  final Widget? placeholder;
  final Widget? errorWidget;

  /// Overrides the standard image rendering
  final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;

  /// If true, displays the placeholder/error widget immediately if URL is null/empty
  final bool usePlaceholderIfUrlEmpty;

  @override
  Widget build(BuildContext context) {
    // 1. Handle Null/Empty URLs immediately to avoid unnecessary network errors
    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return _buildErrorWidget(context, 'URL is empty');
    }

    final targetWidth = width?.w;
    final targetHeight = height?.h;

    // 2. Resolve Border logic
    final effectiveBorder =
        border ??
        (borderWidth != null && borderWidth! > 0
            ? Border.all(
                color: borderColor ?? Colors.transparent,
                width: borderWidth!.r,
              )
            : null);

    return CachedNetworkImage(
      key: ValueKey(imageUrl), // Prevents image flickering on list updates
      imageUrl: imageUrl!,
      width: targetWidth,
      height: targetHeight,
      fit: fit,

      // 3. Memory Optimization: Resize image in memory to match display size
      // This drastically reduces RAM usage for large lists/grids.
      memCacheWidth: targetWidth != null ? (targetWidth * 2).toInt() : null,

      // 4. Ignore query params for caching (optional, depends on your backend)
      cacheKey: imageUrl!.split('?').first,

      // 5. Unified Image Builder (Handles Shapes & Borders on the image itself)
      imageBuilder:
          imageBuilder ??
          (context, imageProvider) {
            return Container(
              width: targetWidth,
              height: targetHeight,
              decoration: BoxDecoration(
                shape: shape,
                borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
                border: effectiveBorder,
                image: DecorationImage(image: imageProvider, fit: fit),
              ),
            );
          },

      // 6. Consistent Placeholder
      placeholder: (context, url) =>
          placeholder ??
          Container(
            width: targetWidth,
            height: targetHeight,
            decoration: BoxDecoration(
              shape: shape,
              borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
            ),
            padding: 8.allPadding,
            child: const Center(child: AppCircularLoader()),
          ),

      // 7. Consistent Error Widget
      errorWidget: (context, url, error) {
        log('Image Load Error: $url | $error', name: 'AppCachedNetworkImage');
        return _buildErrorWidget(context, error);
      },
    );
  }

  /// Helper to build the error view (Standardized)
  Widget _buildErrorWidget(BuildContext context, Object? error) {
    final targetWidth = width?.w;
    final targetHeight = height?.h;

    final effectiveBorder =
        border ??
        (borderWidth != null && borderWidth! > 0
            ? Border.all(
                color: borderColor ?? Colors.transparent,
                width: borderWidth!.r,
              )
            : null);

    if (errorWidget != null) return errorWidget!;

    return Container(
      width: targetWidth,
      height: targetHeight,
      decoration: BoxDecoration(
        color: AppMaterialPrimitives.white,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
        border: effectiveBorder,
        image: DecorationImage(
          image: AssetImage(AppDefaultImages.assetPlaceholderImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Static helper for Avatar fallbacks (NoLogoWidget)
  static Widget _buildNoLogoFallback({
    required String alt,
    double? width,
    double? height,
    BoxShape shape = BoxShape.circle,
    Color borderColor = AppMaterialPrimitives.secondary50,
    double borderWidth = 2.0,
  }) {
    return Container(
      width: width?.w,
      height: height?.h,
      decoration: BoxDecoration(
        color: AppMaterialPrimitives.secondary90,
        shape: shape,
        border: Border.all(color: borderColor, width: borderWidth.r),
      ),
      child: NoLogoWidget(title: alt),
    );
  }
}
