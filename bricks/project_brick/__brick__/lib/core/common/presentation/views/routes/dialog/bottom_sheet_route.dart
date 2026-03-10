import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../extensions/size/size_extension.dart';
import '../../../routes/app_route_model_builder.dart';
import '../../../routes/app_router.gr.dart';

class BottomSheetRoute {
  static final dateRange = CustomRoute(
    customRouteBuilder: createModalSheetBuilder(sheetPadding: EdgeInsets.zero),
    opaque: false,
    transitionsBuilder: TransitionsBuilders.slideBottom,
    page: DateRangeSelectorBottomSheet.page,
  );
  static final date = CustomRoute(
    customRouteBuilder: createModalSheetBuilder(sheetPadding: EdgeInsets.zero),
    opaque: false,
    transitionsBuilder: TransitionsBuilders.slideBottom,
    page: DateSelectorBottomSheet.page,
  );
  static final deleteItems = CustomRoute(
    customRouteBuilder: createModalSheetBuilder(sheetPadding: 16.allPadding),
    opaque: false,
    transitionsBuilder: TransitionsBuilders.slideBottom,
    page: DeleteItemBottomSheetRoute.page,
  );
  static final custom = CustomRoute(
    customRouteBuilder: createModalSheetBuilder(sheetPadding: 16.allPadding),
    opaque: false,
    transitionsBuilder: TransitionsBuilders.slideBottom,
    page: AppBottomSheetWidgetRoute.page,
  );
  static final List<AutoRoute> all = [dateRange, date, deleteItems, custom];
}
