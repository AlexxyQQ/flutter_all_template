import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/di/service_locator.dart';
import '../../../../../core/generic/presentation/bloc/paged_list_bloc.dart';
import '../../bloc/{{feature_name.snakeCase()}}_list_bloc.dart';

/// Route shell of the {{feature_name.pascalCase()}} feature: provides a [{{feature_name.pascalCase()}}ListBloc] (already loading
/// the first page) to every child route registered in `{{feature_name.pascalCase()}}Routes.route`.
///
/// The bloc lives exactly as long as this route. Add more pages (detail, edit)
/// as extra children and they share the same bloc.
@RoutePage()
class {{feature_name.pascalCase()}}Wrapper extends StatelessWidget implements AutoRouteWrapper {
  const {{feature_name.pascalCase()}}Wrapper({super.key});

  @override
  Widget build(BuildContext context) => const AutoRouter();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<{{feature_name.pascalCase()}}ListBloc>(
      create: (_) => sl<{{feature_name.pascalCase()}}ListBloc>()..add(const PagedListStarted()),
      child: this,
    );
  }
}
