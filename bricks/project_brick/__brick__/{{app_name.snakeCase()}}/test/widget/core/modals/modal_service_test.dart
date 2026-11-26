import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_all_template/core/common/domain/services/navigation/navigation_service.dart';
import 'package:flutter_all_template/core/common/presentation/modals/app_bottom_sheet.dart';
import 'package:flutter_all_template/core/common/presentation/modals/app_popup_dialog.dart';
import 'package:flutter_all_template/core/common/presentation/modals/modal_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNavigation extends Mock implements NavigationService {}

void main() {
  const sheetTitle = 'Pick';
  const sheetBody = 'sheet body';
  const sheetAction = 'Done';
  const lockedSheetBody = 'locked';
  const popupTitle = 'Sure?';
  const popupBody = 'popup body';
  const popupAction = 'Yes';
  late MockNavigation navigation;
  late ModalService modals;
  late BuildContext host;

  setUp(() {
    navigation = MockNavigation();
    when(() => navigation.modalContext).thenReturn(null);
    modals = ModalService(navigation: navigation);
  });

  Future<void> pumpHost(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: Scaffold(
        body: Builder(
          builder: (context) {
            host = context;
            return const SizedBox();
          },
        ),
      ),
    ),
  );

  Future<String?> openSheet() => modals.showSheet<String>(
    context: host,
    builder: (context) => AppBottomSheet(
      title: sheetTitle,
      actions: [
        TextButton(
          key: const Key('done'),
          onPressed: () => Navigator.of(context).pop('done'),
          child: const Text(sheetAction),
        ),
      ],
      child: const Text(sheetBody),
    ),
  );

  Future<String?> openPopup({bool barrierDismissible = true}) =>
      modals.showPopup<String>(
        context: host,
        barrierDismissible: barrierDismissible,
        builder: (context) => AppPopupDialog(
          title: popupTitle,
          content: const Text(popupBody),
          actions: [
            TextButton(
              key: const Key('yes'),
              onPressed: () => Navigator.of(context).pop('yes'),
              child: const Text(popupAction),
            ),
          ],
        ),
      );

  testWidgets('sheet returns a typed result', (tester) async {
    await pumpHost(tester);
    final result = openSheet();
    await tester.pumpAndSettle();

    expect(find.text(sheetTitle), findsOneWidget);
    expect(find.text(sheetBody), findsOneWidget);
    expect(
      tester.widget<BottomSheet>(find.byType(BottomSheet)).showDragHandle,
      isTrue,
    );

    await tester.tap(find.byKey(const Key('done')));
    await tester.pumpAndSettle();

    expect(await result, 'done');
    expect(find.text(sheetBody), findsNothing);
  });

  testWidgets('sheet dismissed by tapping the barrier completes with null', (
    tester,
  ) async {
    await pumpHost(tester);
    final result = openSheet();
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(await result, isNull);
    expect(find.text(sheetBody), findsNothing);
  });

  testWidgets('non-dismissible sheet ignores barrier taps', (tester) async {
    await pumpHost(tester);
    unawaited(
      modals.showSheet<String>(
        context: host,
        isDismissible: false,
        builder: (_) => const AppBottomSheet(child: Text(lockedSheetBody)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(find.text(lockedSheetBody), findsOneWidget);
    expect(
      tester.widget<BottomSheet>(find.byType(BottomSheet)).showDragHandle,
      isFalse,
    );
  });

  testWidgets('popup returns a typed result', (tester) async {
    await pumpHost(tester);
    final result = openPopup();
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(popupBody), findsOneWidget);

    await tester.tap(find.byKey(const Key('yes')));
    await tester.pumpAndSettle();

    expect(await result, 'yes');
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('popup dismissed by tapping the barrier completes with null', (
    tester,
  ) async {
    await pumpHost(tester);
    final result = openPopup();
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(await result, isNull);
  });

  testWidgets('non-dismissible popup ignores barrier taps', (tester) async {
    await pumpHost(tester);
    unawaited(openPopup(barrierDismissible: false));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('falls back to NavigationService.modalContext', (tester) async {
    await pumpHost(tester);
    when(() => navigation.modalContext).thenReturn(host);

    final result = modals.showPopup<String>(
      builder: (context) => AppPopupDialog(
        content: TextButton(
          key: const Key('ok'),
          onPressed: () => Navigator.of(context).pop('ok'),
          child: const Text('Ok'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('ok')));
    await tester.pumpAndSettle();

    expect(await result, 'ok');
  });

  testWidgets('without any context nothing is shown and result is null', (
    tester,
  ) async {
    await pumpHost(tester);

    expect(
      await modals.showSheet<String>(builder: (_) => const Text('x')),
      isNull,
    );
    expect(
      await modals.showPopup<String>(builder: (_) => const Text('x')),
      isNull,
    );
    expect(find.text('x'), findsNothing);
  });
}
