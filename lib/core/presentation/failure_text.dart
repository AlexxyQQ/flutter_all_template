import 'package:easy_localization/easy_localization.dart';

import '../error/failure.dart';

/// The user-facing text of a [Failure]: the backend's safe message verbatim,
/// otherwise the translated [Failure.messageKey].
///
/// Widgets use this instead of calling `.tr()` on a failure field, so a server
/// message is never mistaken for a missing localization key.
extension FailureText on Failure {
  String get displayText => serverMessage ?? messageKey.tr();
}
