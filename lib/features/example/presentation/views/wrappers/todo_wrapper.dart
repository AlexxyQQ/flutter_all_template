import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/di/service_locator.dart';
import '../../../../../core/generic/presentation/bloc/paged_list_bloc.dart';
import '../../bloc/todo_list_bloc.dart';

/// Route shell of the to-do feature: provides a [TodoListBloc] (already
/// loading the first page) to every child route registered in
/// `TodoRoutes.route`.
///
/// The bloc lives exactly as long as this route. Add more pages (detail, edit)
/// as extra children and they share the same bloc.
@RoutePage()
class TodoWrapper extends StatelessWidget implements AutoRouteWrapper {
  const TodoWrapper({super.key});

  @override
  Widget build(BuildContext context) => const AutoRouter();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<TodoListBloc>(
      create: (_) => sl<TodoListBloc>()..add(const PagedListStarted()),
      child: this,
    );
  }
}
