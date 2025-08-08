import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/features/countries/presentation/screens/countries_screen.dart';

void main() {
  group('CountriesScreen Widget Tests', () {
    testWidgets('debería mostrar estado de carga inicialmente',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('Cargando países...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Esto puede tomar unos segundos'), findsOneWidget);
    });

    testWidgets('debería mostrar título correcto en el AppBar',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('Países del Mundo'), findsOneWidget);
    });

    testWidgets('debería tener un Scaffold con CustomScrollView',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('debería tener un fondo gris claro',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.grey[50]);
    });

    testWidgets('debería mostrar estado de carga con indicador circular',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Cargando países...'), findsOneWidget);
    });

    testWidgets('debería mostrar mensaje de carga',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('Esto puede tomar unos segundos'), findsOneWidget);
    });

    testWidgets('debería tener un SliverToBoxAdapter en el CustomScrollView',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(SliverToBoxAdapter), findsOneWidget);
    });

    testWidgets('debería mostrar el widget correctamente sin errores',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      // Assert - Si llegamos aquí sin errores, el widget se renderiza correctamente
      expect(find.byType(CountriesScreen), findsOneWidget);
    });

    testWidgets('debería tener un ProviderScope configurado correctamente',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(ProviderScope), findsOneWidget);
      expect(find.byType(CountriesScreen), findsOneWidget);
    });

    testWidgets('debería mostrar el widget dentro de un MaterialApp',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(CountriesScreen), findsOneWidget);
    });
  });
}
