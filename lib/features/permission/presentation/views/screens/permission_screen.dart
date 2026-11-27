import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/di/service_locator.dart';
import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../config/constants/paths/app_path.dart';
import '../../../../../core/presentation/failure_text.dart';
import '../../../../../core/presentation/modals/app_popup_dialog.dart';
import '../../../../../core/presentation/modals/modal_service.dart';
import '../../../domain/entities/app_permission.dart';
import '../../bloc/permission_bloc.dart';
import '../../helpers/permission_content.dart';
import '../widgets/permission_prompt_view.dart';

/// One screen for every [AppPermission] (`/permission/:permission`).
///
/// It returns its result through the router instead of calling back into the
/// caller: `true` once the permission is granted or skipped, `null` when the
/// user backs out.
///
/// ```dart
/// final done = await context.router.push<bool>(
///   PermissionRoute(permission: AppPermission.camera.name),
/// );
/// ```
@RoutePage()
class PermissionScreen extends StatefulWidget implements AutoRouteWrapper {
  const PermissionScreen({
    @PathParam(AppPaths.permissionParam) required this.permission,
    super.key,
  });

  /// `AppPermission.name`. Unknown values render an error state.
  final String permission;

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

  void _finish() {
    if (_finished) {
      return;
    }
    _finished = true;
    unawaited(context.router.maybePop(true));
  }

  void _showReAskDialog(AppPermission permission) {
    final bloc = context.read<PermissionBloc>();
    unawaited(
      ModalService.showPopup<void>(
        context: context,
        builder: (dialogContext) => AppPopupDialog(
          title: permission.reAskTitleKey.tr(),
          content: Text(permission.reAskMessageKey.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(LocaleKeys.common_words_cancel.tr()),
            ),
            TextButton(
              key: const Key('permission_open_settings_button'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                bloc.add(const PermissionSettingsOpened());
              },
              child: Text(LocaleKeys.common_words_confirm.tr()),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final permission = _permission;
    if (permission == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(LocaleKeys.common_errors_somethingWentWrong.tr()),
        ),
      );
    }

    return MultiBlocListener(
      listeners: [
        // Granted (also from the settings page) or skipped: we are done.
        BlocListener<PermissionBloc, PermissionState>(
          listenWhen: (previous, current) =>
              !previous.canProceed(permission) &&
              current.canProceed(permission),
          listener: (context, state) => _finish(),
        ),
        // The prompt just closed and only the system settings can still help.
        BlocListener<PermissionBloc, PermissionState>(
          listenWhen: (previous, current) =>
              previous.isRequesting(permission) &&
              !current.isRequesting(permission),
          listener: (context, state) {
            final status = state.statusOf(permission);
            if (!state.canProceed(permission) &&
                (status?.requiresSettings ?? false)) {
              _showReAskDialog(permission);
            }
          },
        ),
        BlocListener<PermissionBloc, PermissionState>(
          listenWhen: (previous, current) =>
              current.error != null && previous.error != current.error,
          listener: (context, state) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!.displayText)));
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<PermissionBloc, PermissionState>(
          builder: (context, state) => PermissionPromptView(
            permission: permission,
            isLoading: state.isRequesting(permission),
            onContinue: () => context.read<PermissionBloc>().add(
              PermissionRequested(permission),
            ),
            onSkip: () => context.read<PermissionBloc>().add(
              PermissionSkipped(permission),
            ),
          ),
        ),
      ),
    );
  }
}
