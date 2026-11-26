import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../../config/constants/paths/app_path.dart';
import '../../../../../locator/service_locator.dart';
import '../../../../../presentation/extensions/dialog/dialog_extension.dart';
import '../../../../../presentation/views/widgets/system/default_app_bar.dart';
import '../../../../../presentation/views/widgets/system/text/app_text_widget.dart';
import '../../../domain/entities/app_permission.dart';
import '../../../permission_spec.dart';
import '../../bloc/permission_bloc.dart';
import '../widgets/permission_prompt_view.dart';

/// One screen for every [AppPermission] (`/permission/:permission`).
///
/// When the user grants or skips the permission the screen finishes with
/// `true` (and with `false` if they back out):
/// 1. [onResult] is called when given (used by `PermissionGuard`);
/// 2. otherwise [nextRoute] replaces this screen when given;
/// 3. otherwise the screen pops with the result.
///
/// Only a typed [PageRouteInfo] is accepted as a destination, never a raw
/// path string (no open redirects).
@RoutePage(name: 'PermissionScreenRoute')
class PermissionScreen extends StatefulWidget implements AutoRouteWrapper {
  const PermissionScreen({
    @PathParam(AppPaths.permissionParam) required this.permission,
    super.key,
    this.nextRoute,
    this.onResult,
  });

  /// `AppPermission.name`. Unknown values render an error state.
  final String permission;

  final PageRouteInfo<Object?>? nextRoute;

  final ValueChanged<bool>? onResult;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<PermissionBloc>(
      create: (_) => sl<PermissionBloc>(),
      child: this,
    );
  }

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  AppPermission? _permission;
  AppLifecycleListener? _lifecycle;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    final permission = AppPermission.tryParse(widget.permission);
    _permission = permission;
    if (permission == null) {
      return;
    }
    final bloc = context.read<PermissionBloc>()
      ..add(PermissionChecked(permission));
    // Re-check when returning from the system settings.
    _lifecycle = AppLifecycleListener(
      onResume: () => bloc.add(PermissionChecked(permission)),
    );
  }

  @override
  void dispose() {
    _lifecycle?.dispose();
    super.dispose();
  }

  void _finish({required bool result}) {
    if (_finished) {
      return;
    }
    _finished = true;
    final onResult = widget.onResult;
    final nextRoute = widget.nextRoute;
    if (onResult != null) {
      onResult(result);
    } else if (nextRoute != null && result) {
      unawaited(context.router.replace(nextRoute));
    } else {
      unawaited(context.router.maybePop(result));
    }
  }

  void _showReAskDialog(PermissionSpec spec) {
    final bloc = context.read<PermissionBloc>();
    context.showConfirmationDialog(
      title: spec.reAskTitleKey,
      message: spec.reAskMessageKey,
      onConfirm: () => bloc.add(const PermissionSettingsOpened()),
    );
  }

  void _onPopInvoked(bool didPop, Object? _) {
    final onResult = widget.onResult;
    if (didPop && !_finished && onResult != null) {
      _finished = true;
      onResult(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final permission = _permission;
    if (permission == null) {
      return const Scaffold(
        appBar: DefaultAppBar(),
        body: Center(
          child: AppText(LocaleKeys.common_errors_somethingWentWrong),
        ),
      );
    }
    final spec = permission.spec;

    return PopScope<Object?>(
      onPopInvokedWithResult: _onPopInvoked,
      child: BlocConsumer<PermissionBloc, PermissionState>(
        listenWhen: (previous, current) =>
            previous.statuses[permission] != current.statuses[permission] ||
            previous.isSkipped(permission) != current.isSkipped(permission) ||
            (current.lastRequested == permission &&
                previous.requestCount != current.requestCount),
        listener: (context, state) {
          if (state.isLoading) {
            return;
          }
          if (state.canProceed(permission)) {
            _finish(result: true);
            return;
          }
          final needsSettings =
              state.lastRequested == permission &&
              (state.statusOf(permission)?.requiresSettings ?? false);
          if (needsSettings) {
            _showReAskDialog(spec);
          }
        },
        builder: (context, state) {
          final bloc = context.read<PermissionBloc>();
          return Scaffold(
            appBar: const DefaultAppBar(),
            body: PermissionPromptView(
              spec: spec,
              isLoading: state.isLoading,
              onContinue: () => bloc.add(PermissionRequested(permission)),
              onSkip: () => bloc.add(PermissionSkipped(permission)),
            ),
          );
        },
      ),
    );
  }
}
