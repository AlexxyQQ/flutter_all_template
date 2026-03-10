import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/locator/service_locator.dart';
import '../../bloc/test_cubit.dart';

@RoutePage(name: 'AnotherWrapperRoute')
class AnotherWrapperScreen extends StatelessWidget implements AutoRouteWrapper {
  const AnotherWrapperScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (context) => sl<TestCubit>(), child: this);
  }

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
