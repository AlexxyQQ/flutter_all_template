import 'package:flutter/material.dart';
import 'package:flutter_all_template/config/themes/app_tokens.dart';
import 'package:flutter_all_template/core/common/presentation/extensions/theme/theme_extension.dart';
import 'package:flutter_all_template/core/common/presentation/themes/styles/button_style.dart';
import 'package:flutter_all_template/core/common/presentation/views/widgets/system/app_button.dart';
import 'package:flutter_all_template/core/common/presentation/views/widgets/system/loaders/app_circular_loader.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

typedef _Factory =
    AppButton Function({
      required VoidCallback? onPressed,
      bool isDisabled,
      bool isLoading,
    });

void main() {
  setUpAll(loadTestTranslations);

  const label = 'Save';

  final variants = <String, (_Factory, ButtonVariant)>{
    'primary': (
      ({required onPressed, isDisabled = false, isLoading = false}) =>
          AppButton.primary(
            onPressed: onPressed,
            label: label,
            translate: false,
            isDisabled: isDisabled,
            isLoading: isLoading,
          ),
      ButtonVariant.primary,
    ),
    'secondary': (
      ({required onPressed, isDisabled = false, isLoading = false}) =>
          AppButton.secondary(
            onPressed: onPressed,
            label: label,
            translate: false,
            isDisabled: isDisabled,
            isLoading: isLoading,
          ),
      ButtonVariant.secondary,
    ),
    'tertiary': (
      ({required onPressed, isDisabled = false, isLoading = false}) =>
          AppButton.tertiary(
            onPressed: onPressed,
            label: label,
            translate: false,
            isDisabled: isDisabled,
            isLoading: isLoading,
          ),
      ButtonVariant.tertiary,
    ),
    'stroke': (
      ({required onPressed, isDisabled = false, isLoading = false}) =>
          AppButton.stroke(
            onPressed: onPressed,
            label: label,
            translate: false,
            isDisabled: isDisabled,
            isLoading: isLoading,
          ),
      ButtonVariant.stroke,
    ),
    'ghost': (
      ({required onPressed, isDisabled = false, isLoading = false}) =>
          AppButton.ghost(
            onPressed: onPressed,
            label: label,
            translate: false,
            isDisabled: isDisabled,
            isLoading: isLoading,
          ),
      ButtonVariant.ghost,
    ),
    'destructive': (
      ({required onPressed, isDisabled = false, isLoading = false}) =>
          AppButton.destructive(
            onPressed: onPressed,
            label: label,
            translate: false,
            isDisabled: isDisabled,
            isLoading: isLoading,
          ),
      ButtonVariant.destructive,
    ),
  };

  BoxDecoration decorationOf(WidgetTester tester) {
    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(AppButton),
            matching: find.byType(Container),
          )
          .first,
    );
    return container.decoration! as BoxDecoration;
  }

  for (final brightness in Brightness.values) {
    group('AppButton (${brightness.name})', () {
      for (final MapEntry(key: name, value: (build, variant))
          in variants.entries) {
        testWidgets('$name renders, uses theme colours and fires onPressed', (
          tester,
        ) async {
          var taps = 0;
          await tester.pumpWidget(
            themedApp(build(onPressed: () => taps++), brightness: brightness),
          );

          expect(find.text(label), findsOneWidget);

          final scheme = testTheme(brightness).colorScheme;
          expect(
            decorationOf(tester).color,
            ButtonStyles.of(variant, scheme).backgroundColor,
          );

          await tester.tap(find.byType(AppButton));
          await tester.pumpAndSettle();
          expect(taps, 1);
        });

        testWidgets('$name ignores taps when disabled or loading', (
          tester,
        ) async {
          var taps = 0;
          await tester.pumpWidget(
            themedApp(
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  build(onPressed: () => taps++, isDisabled: true),
                  build(onPressed: () => taps++, isLoading: true),
                ],
              ),
              brightness: brightness,
            ),
          );

          expect(find.byType(AppCircularLoader), findsOneWidget);
          await tester.tap(find.byType(AppButton).first);
          await tester.tap(find.byType(AppButton).last);
          await tester.pump(const Duration(milliseconds: 200));
          expect(taps, 0);
        });
      }
    });
  }

  testWidgets('light and dark primary buttons differ', (tester) async {
    Color? colorFor(Brightness b) => ButtonStyles.of(
      ButtonVariant.primary,
      testTheme(b).colorScheme,
    ).backgroundColor;
    expect(colorFor(Brightness.light), isNot(colorFor(Brightness.dark)));
  });

  testWidgets('exposes button semantics with label', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      themedApp(
        AppButton.primary(onPressed: () {}, label: label, translate: false),
      ),
    );
    expect(
      tester.getSemantics(find.byType(AppButton)),
      matchesSemantics(
        label: label,
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('theme exposes AppTokens via context.tokens', (tester) async {
    late AppTokens tokens;
    late ColorScheme colors;
    await tester.pumpWidget(
      themedApp(
        Builder(
          builder: (context) {
            tokens = context.tokens;
            colors = context.colors;
            return const SizedBox();
          },
        ),
        brightness: Brightness.dark,
      ),
    );
    expect(tokens, AppTokens.dark);
    expect(colors.brightness, Brightness.dark);
  });
}
