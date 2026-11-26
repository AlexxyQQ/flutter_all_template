import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../config/constants/gen/locale_keys.g.dart';

import '../../../../extensions/size/size_extension.dart';
import '../../../../extensions/theme/theme_extension.dart';
import 'app_circular_loader.dart';

@RoutePage(name: 'AppDialogLoaderRoute')
class AppDialogLoader extends StatefulWidget {
  const AppDialogLoader({super.key, this.duration});
  final Duration? duration;

  @override
  State<AppDialogLoader> createState() => _AppDialogLoaderState();
}

class _AppDialogLoaderState extends State<AppDialogLoader> {
  /// Safety net so a forgotten loader never blocks the UI forever.
  static const Duration _maxDuration = Duration(minutes: 5);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration ?? _maxDuration, () {
      if (mounted) {
        unawaited(Navigator.of(context).maybePop());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: 18.borderCircular,
        color: context.colors.surface,
      ),
      height: 60.h,
      width: 60.w,
      child: Center(
        child: Semantics(
          liveRegion: true,
          label: LocaleKeys
              .features_home_presentation_views_screens_home_screen_splashLoading
              .tr(),
          child: const AppCircularLoader(),
        ),
      ),
    );
  }
}
