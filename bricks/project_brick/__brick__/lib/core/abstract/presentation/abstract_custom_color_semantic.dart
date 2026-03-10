import '../../common/presentation/views/components/app_color.dart';

/// Defines the contract for your color system.
abstract class AppCustomSemanticColors {
  // Main Brand Actions
  abstract final KAppColor primary;
  abstract final KAppColor onPrimary;
  abstract final KAppColor secondary;
  abstract final KAppColor onSecondary;
  abstract final KAppColor tertiary;
  abstract final KAppColor onTertiary;

  // Interactive Elements
  abstract final KAppColor active;
  abstract final KAppColor onActive;
  abstract final KAppColor disabled;
  abstract final KAppColor onDisabled;

  // Icons
  abstract final KAppColor icon;
  abstract final KAppColor disabledIcon;
  abstract final KAppColor selectedIcon;

  // Borders
  abstract final KAppColor border;
  abstract final KAppColor selectedBorder;
  abstract final KAppColor disabledBorder;
  abstract final KAppColor errorBorder;

  // Surfaces & Text
  abstract final KAppColor background;
  abstract final KAppColor text;

  // Functional / Feedback
  abstract final KAppColor success;
  abstract final KAppColor onSuccess;
  abstract final KAppColor warning;
  abstract final KAppColor onWarning;
  abstract final KAppColor error;
  abstract final KAppColor onError;
  abstract final KAppColor errorDisabled;

  // Defined
  abstract final KAppColor transparent;
  abstract final KAppColor white;
  abstract final KAppColor black;
}
