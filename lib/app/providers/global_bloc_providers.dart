import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/app_settings/presentation/bloc/locale_cubit.dart';
import '../di/service_locator.dart';

/// App-wide blocs. This is a widget-tree root, so resolving from `sl` here is
/// allowed; everything below receives dependencies via the tree.
class GlobalBlocProvider extends StatelessWidget {
  const GlobalBlocProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => BlocProvider<LocaleCubit>(
    // EasyLocalization starts with the locale bootstrap resolved; the cubit
    // starts with the same one instead of resolving it again.
    create: (_) => sl<LocaleCubit>(param1: context.locale),
    child: child,
  );
}
