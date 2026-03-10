// ignore_for_file: avoid_sized_box_height, avoid_hardcoded_strings_in_widgets
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_all_template/config/constants/colors/material/material_semantics.dart';
import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/common/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter_all_template/core/common/presentation/themes/text/context_material_text_styles.dart';
import 'package:flutter_all_template/core/generic/presentation/bloc/crud/base_crud_bloc.dart';
import 'package:flutter_all_template/core/generic/presentation/views/widgets/pagination_list_view_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Import your actual files.
// Adjust these imports to match your project structure.
// import 'package:your_app/../../pagination_list_view.dart';
// import 'package:your_app/../../base_crud_bloc.dart';

// -----------------------------------------------------------------------------
// 1. Mocks and Test Data
// -----------------------------------------------------------------------------

// Simple Entity for testing
class TestEntity {
  TestEntity(this.id, this.name);
  final int id;
  final String name;
}

class MockBaseCrudBloc
    extends MockBloc<BaseCrudEvent<TestEntity>, BaseCrudState<TestEntity>>
    implements BaseCrudBloc<TestEntity> {
  @override
  String get name => 'TestEntity';

  @override
  dynamic getEntityId(TestEntity entity) => entity.id;
}

// Fake Events to register with Mocktail
class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}

class FakeBaseCrudEvent extends Fake implements BaseCrudEvent<TestEntity> {}

class FakeBaseCrudState extends Fake implements BaseCrudState<TestEntity> {}

class FakeThemeState extends Fake implements ThemeState {}

// -----------------------------------------------------------------------------
// 2. Test Setup
// -----------------------------------------------------------------------------

void main() {
  late MockBaseCrudBloc mockBloc;
  late MockThemeCubit mockThemeCubit; // --- NEW ---

  setUpAll(() {
    registerFallbackValue(FakeBaseCrudEvent());
    registerFallbackValue(FakeBaseCrudState());
  });

  setUp(() {
    mockBloc = MockBaseCrudBloc();
    mockThemeCubit = MockThemeCubit(); // --- NEW ---

    // --- NEW: Stub the ThemeCubit state ---
    // You need to return a state that has valid colors so context.colors works.
    // If your ThemeState has a factory like .light(), use that.
    // Otherwise, create a basic instance.
    when(() => mockThemeCubit.state).thenReturn(
      ThemeState(
        themeMode: ThemeMode.light,
        colors: MaterialLightSemantic(),
        textStyles: ContextMaterialTextStyles(MaterialLightSemantic()),
      ),
    );

    // If your ThemeCubit is a simple provider of AppColor, ensure the state is correct.
    // For example:
    // when(() => mockThemeCubit.state).thenReturn(ThemeState(colors: KAppColor.light()));
  });

  /// Helper to wrap the widget with necessary Providers and Theme
  /// This replicates your Main.dart setup for ScreenUtil and Themes
  Widget makeTestableWidget({required Widget child}) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Standard mobile size
      builder: (context, _) => MaterialApp(
        // Inject your custom theme extension here if needed
        // theme: ThemeData.light().copyWith(extensions: [YourThemeExtension()]),
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<BaseCrudBloc<TestEntity>>.value(value: mockBloc),
              BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
            ],
            child: child,
          ),
        ),
      ),
    );
  }

  group('PaginationListView Widget Tests', () {
    // --- SCENARIO 1: Loading State ---
    testWidgets('renders LoadingWidget when state is loading and empty', (
      tester,
    ) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(
        const BaseCrudState<TestEntity>(isLoading: true, entities: []),
      );

      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: PaginationListView<TestEntity>(
            bloc: mockBloc,
            itemBuilder: (_, __, ___) => const SizedBox(),
          ),
        ),
      );

      // Assert
      // We look for CircularProgressIndicator which is inside your _DefaultLoadingWidget
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // --- SCENARIO 2: Empty State ---
    testWidgets('renders EmptyWidget when state is not loading and empty', (
      tester,
    ) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(
        const BaseCrudState<TestEntity>(
          isInitial:
              false, // Important: if isInitial is true, it renders SizedBox.shrink
          entities: [],
        ),
      );

      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: PaginationListView<TestEntity>(
            bloc: mockBloc,
            itemBuilder: (_, __, ___) => const SizedBox(),
            // You can pass a specific key to your empty widget to find it easier
            emptyWidget: const Text('Custom Empty'),
          ),
        ),
      );

      // Assert
      expect(find.text('Custom Empty'), findsOneWidget);
    });

    // --- SCENARIO 3: Error State & Retry ---
    testWidgets('renders ErrorWidget and triggers retry on tap', (
      tester,
    ) async {
      // Arrange
      const errorMessage = 'Network Error';
      when(() => mockBloc.state).thenReturn(
        const BaseCrudState<TestEntity>(
          entities: [],
          error: Failure(
            message: errorMessage,
          ), // Assuming you have a Failure class
        ),
      );

      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: PaginationListView<TestEntity>(
            bloc: mockBloc,
            itemBuilder: (_, __, ___) => const SizedBox(),
          ),
        ),
      );

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
      expect(
        find.text('Retry'),
        findsOneWidget,
      ); // Assuming AppButton has 'Retry' label

      // Act (Tap Retry)
      await tester.tap(find.text('Retry'));

      // Assert (Event sent)
      verify(
        () => mockBloc.add(any(that: isA<RefreshPaginationEvent>())),
      ).called(1);
    });

    // --- SCENARIO 4: Data Rendering ---
    testWidgets('renders list of entities when data exists', (tester) async {
      // Arrange
      final entities = [TestEntity(1, 'Item 1'), TestEntity(2, 'Item 2')];

      when(
        () => mockBloc.state,
      ).thenReturn(BaseCrudState<TestEntity>(entities: entities));

      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: PaginationListView<TestEntity>(
            bloc: mockBloc,
            itemBuilder: (context, item, index) {
              return Text(item.name);
            },
          ),
        ),
      );

      // Assert
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    // --- SCENARIO 5: Infinite Scrolling (Integration Behavior) ---
    testWidgets('triggers LoadNextPaginationEvent when scrolled to bottom', (
      tester,
    ) async {
      final entities = List.generate(
        6,
        (index) => TestEntity(index, 'Item $index'),
      );

      when(
        () => mockBloc.state,
      ).thenReturn(BaseCrudState<TestEntity>(entities: entities));

      await tester.pumpWidget(
        makeTestableWidget(
          child: SizedBox(
            height: 600, // Small viewport
            child: PaginationListView<TestEntity>(
              bloc: mockBloc,
              // Items are 500px tall. 6 * 500 = 3000px content.
              // Max scroll extent = 3000 - 600 = 2400px.
              itemBuilder: (_, item, __) =>
                  SizedBox(height: 500, child: Text(item.name)),
            ),
          ),
        ),
      );

      // Act: Scroll drastically (move content UP by 2500px)
      // This forces the viewport to the very bottom.
      await tester.drag(find.byType(ListView), const Offset(0, -2500));

      // Critical: Pump a frame to let the scroll controller update values
      await tester.pump();
      // Critical: Wait a bit for the listener callback to fire
      await tester.pump(const Duration(milliseconds: 100));

      // Assert
      verify(
        () => mockBloc.add(any(that: isA<LoadNextPaginationEvent>())),
      ).called(1);
    });

    // --- SCENARIO 6: Manual Load More Button ---
    testWidgets('shows LoadMoreButton and triggers event on tap', (
      tester,
    ) async {
      // Arrange
      final entities = List.generate(
        5,
        (index) => TestEntity(index, 'Item $index'),
      );

      when(
        () => mockBloc.state,
      ).thenReturn(BaseCrudState<TestEntity>(entities: entities));

      await tester.pumpWidget(
        makeTestableWidget(
          child: PaginationListView<TestEntity>(
            bloc: mockBloc,
            showLoadMoreButton: true, // Enable manual mode
            itemBuilder: (_, item, __) =>
                SizedBox(height: 50, child: Text(item.name)),
          ),
        ),
      );

      // Scroll to bottom to ensure button is visible
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Assert Button Exists
      final buttonFinder = find.text('Load More');
      expect(buttonFinder, findsOneWidget);

      // Act
      await tester.tap(buttonFinder);

      // Assert
      verify(
        () => mockBloc.add(any(that: isA<LoadNextPaginationEvent>())),
      ).called(1);
    });

    // --- SCENARIO 7: Pull to Refresh ---
    testWidgets('triggers RefreshPaginationEvent on pull down', (tester) async {
      // 1. Arrange: Setup Data
      final entities = List.generate(
        6,
        (index) => TestEntity(index, 'Item $index'),
      );

      // Setup State
      when(
        () => mockBloc.state,
      ).thenReturn(BaseCrudState<TestEntity>(entities: entities));

      // Setup Stream for the RefreshIndicator's await logic
      whenListen(
        mockBloc,
        Stream.fromIterable([
          BaseCrudState<TestEntity>(isLoading: true, entities: entities),
          BaseCrudState<TestEntity>(entities: entities),
        ]),
      );

      // 2. Build Widget
      await tester.pumpWidget(
        makeTestableWidget(
          child: PaginationListView<TestEntity>(
            bloc: mockBloc,
            // Ensure content exists
            itemBuilder: (_, item, __) =>
                SizedBox(height: 100, child: Text(item.name)),
          ),
        ),
      );

      // 3. Act: Manual Gesture Control for reliability
      // Get the center of the ListView
      final listCenter = tester.getCenter(find.byType(ListView));

      // Touch Down
      final gesture = await tester.startGesture(listCenter);

      // Drag Down (Move by 300px)
      await gesture.moveBy(const Offset(0, 300));
      await tester.pump(); // Reflect the movement in the UI (shows the arrow)

      // Lift Finger (Release)
      await gesture.up();

      // 4. Pump to trigger the onRefresh callback
      // RefreshIndicator waits for the snap-back animation to start before calling onRefresh
      await tester.pump();
      // Pump for a second to allow the callback to execute
      await tester.pump(const Duration(seconds: 1));

      // 5. Assert
      verify(
        () => mockBloc.add(any(that: isA<RefreshPaginationEvent>())),
      ).called(1);

      // Cleanup animations
      await tester.pumpAndSettle();
    });

    // --- SCENARIO 8: Loading Next Indicator (Automatic Mode) ---
    testWidgets('shows loading indicator at bottom when isLoadingNext is true', (
      tester,
    ) async {
      // Arrange
      final entities = List.generate(
        5,
        (index) => TestEntity(index, 'Item $index'),
      );

      when(() => mockBloc.state).thenReturn(
        BaseCrudState<TestEntity>(
          isLoadingNext: true, // Simulate loading next page
          entities: entities,
        ),
      );

      await tester.pumpWidget(
        makeTestableWidget(
          child: PaginationListView<TestEntity>(
            bloc: mockBloc,
            itemBuilder: (_, item, __) =>
                SizedBox(height: 50, child: Text(item.name)),
          ),
        ),
      );

      // Assert
      // Your code uses a Stack with Positioned for the loader
      // We look for the CircularProgressIndicator within the specific LoadingIndicator widget
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
