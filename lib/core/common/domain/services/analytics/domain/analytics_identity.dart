import 'package:equatable/equatable.dart';

/// Who analytics events are attributed to.
final class AnalyticsIdentity extends Equatable {
  const AnalyticsIdentity({required this.anonymousId, this.userId});

  /// Random id generated on the device; never derived from user data.
  final String anonymousId;

  /// Opaque app user id while signed in, otherwise `null`.
  final String? userId;

  bool get isAnonymous => userId == null;

  AnalyticsIdentity withUser({required String? userId}) =>
      AnalyticsIdentity(anonymousId: anonymousId, userId: userId);

  @override
  List<Object?> get props => [anonymousId, userId];

  // Ids are pseudonymous but still personal data: keep them out of logs.
  @override
  String toString() => 'AnalyticsIdentity(<redacted>)';
}
