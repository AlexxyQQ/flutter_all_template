import 'package:mason/mason.dart';

/// Normalises answers before templates are rendered.
///
/// Push notifications are built on FCM, so they imply Firebase. Doing this
/// here keeps the Mustache sections in `__brick__` consistent with each other.
void run(HookContext context) {
  final useNotifications = context.vars['use_notifications'] as bool;
  final useFirebase = context.vars['use_firebase'] as bool;

  if (useNotifications && !useFirebase) {
    context.vars = {...context.vars, 'use_firebase': true};
    context.logger.warn(
      'Push notifications require Firebase - enabling Firebase too.',
    );
  }
}
