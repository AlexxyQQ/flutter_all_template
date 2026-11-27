import 'package:injectable/injectable.dart';

import 'session.dart';
import 'session_authority.dart';
import 'session_manager_impl.dart';

/// Exposes the one [SessionManagerImpl] through its two narrow interfaces.
@module
abstract class SessionModule {
  @lazySingleton
  ISessionManager sessionManager(SessionManagerImpl impl) => impl;

  @lazySingleton
  ISessionAuthority sessionAuthority(SessionManagerImpl impl) => impl;
}
