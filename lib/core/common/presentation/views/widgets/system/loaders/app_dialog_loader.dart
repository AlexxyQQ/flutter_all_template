import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../domain/services/navigation/navigation_service.dart';
import '../../../../../locator/service_locator.dart';
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
  // Need to pop after the duration
  @override
  void initState() {
    super.initState();
    if (widget.duration != null) {
      Future.delayed(widget.duration!, () {
        sl<NavigationService>().maybePop();
      });
    } else {
      Future.delayed(const Duration(minutes: 5), () {
        sl<NavigationService>().maybePop();
        // TODO: Show Snackbar message saying "Loader Timed Out"
      });
    }
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
      child: const Center(child: AppCircularLoader()),
    );
  }
}
