import 'package:auto_route/auto_route.dart';

import '../../../../../../config/constants/colors/material/material_primitive_colors.dart';
import '../../../extensions/size/size_extension.dart';
import '../../../routes/app_route_model_builder.dart';
import '../../../routes/app_router.gr.dart';

class DialogRoutes {
  static final appDialogLoader = CustomRoute(
    customRouteBuilder: createDialogBuilder(
      barrierDismissible: false,
      dialogBackgroundColor: AppMaterialPrimitives.transparent,
      insetPadding: 0.horizontalPadding,
      dialogPadding: 0.allPadding,
    ),
    opaque: false,
    transitionsBuilder: TransitionsBuilders.slideBottom,
    page: AppDialogLoaderRoute.page,
  );
  static final appDialogRoute = CustomRoute(
    customRouteBuilder: createDialogBuilder(
      dialogBackgroundColor: AppMaterialPrimitives.transparent,
    ),
    opaque: false,
    transitionsBuilder: TransitionsBuilders.zoomIn,
    duration: const Duration(milliseconds: 600),
    page: AppDialogRoute.page,
  );

  static final List<AutoRoute> all = [appDialogLoader, appDialogRoute];
}

// static final dateRange = CustomRoute(
//   customRouteBuilder: createModalSheetBuilder(sheetPadding: EdgeInsets.zero),
//   opaque: false,
//   transitionsBuilder: TransitionsBuilders.slideBottom,
//   page: DateRangeSelectorBottomSheet.page,
// );
// static final date = CustomRoute(
//   customRouteBuilder: createModalSheetBuilder(sheetPadding: EdgeInsets.zero),
//   opaque: false,
//   transitionsBuilder: TransitionsBuilders.slideBottom,
//   page: DateSelectorBottomSheet.page,
// );
// static final dialog = CustomRoute(
//   customRouteBuilder: createDialogBuilder(
//     barrierDismissible: false,
//     dialogBackgroundColor: Colors.white,
//     insetPadding: 24.horizontalPadding,
//     dialogPadding: 0.allPadding,
//   ),
//   opaque: false,
//   transitionsBuilder: TransitionsBuilders.slideBottom,
//   page: AppDialogBoxPage.page,
// );
