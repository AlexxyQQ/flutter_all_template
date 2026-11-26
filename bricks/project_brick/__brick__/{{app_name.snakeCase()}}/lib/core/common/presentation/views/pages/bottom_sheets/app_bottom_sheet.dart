import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'AppBottomSheetWidgetRoute')
class AppBottomSheetWidget extends StatelessWidget {
  const AppBottomSheetWidget({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [child],
    );
  }
}
