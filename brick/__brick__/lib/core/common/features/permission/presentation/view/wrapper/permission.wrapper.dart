import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../locator/service_locator.dart';
import '../../bloc/permission_bloc.dart';

@RoutePage(name: 'PermissionWrapperRoute')
class PermissionWrapper extends StatelessWidget implements AutoRouteWrapper {
  const PermissionWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => sl<PermissionBloc>())],
      child: this,
    );
  }
}
