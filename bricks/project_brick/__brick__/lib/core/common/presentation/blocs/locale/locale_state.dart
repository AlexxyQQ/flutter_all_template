part of 'locale_cubit.dart';

class LocaleState extends Equatable {
  const LocaleState({
    this.currentLocale = AppLocales.en,
    this.isInitialized = false,
  });
  final Locale currentLocale;
  final bool isInitialized;

  @override
  List<Object> get props => [currentLocale];
}
