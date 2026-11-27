part of 'locale_cubit.dart';

final class LocaleState extends Equatable {
  const LocaleState({this.currentLocale = AppLocales.fallback});

  final Locale currentLocale;

  @override
  List<Object> get props => [currentLocale];
}
