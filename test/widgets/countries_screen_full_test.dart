import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/features/countries/presentation/screens/countries_screen.dart';
import '../helpers/countries_test_helper.dart';

void main() {
  group('CountriesScreen full Tests', () {
    testWidgets('debería mostrar lista de países cuando hay datos',
        (WidgetTester tester) async {
      final mockCountries = CountriesTestHelper.getMockCountries();

      await tester.pumpWidget(
        ProviderScope(
          overrides:
              CountriesTestHelper.getMockCountriesOverride(mockCountries),
          child: const MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Países del Mundo'), findsOneWidget);
      expect(find.text('España'), findsOneWidget);
      expect(find.text('México'), findsOneWidget);
      expect(find.text('Japón'), findsOneWidget);
      expect(find.text('Capital: Madrid'), findsOneWidget);
      expect(find.text('Capital: Ciudad de México'), findsOneWidget);
      expect(find.text('Capital: Tokio'), findsOneWidget);
      expect(find.text('🇪🇸'), findsOneWidget);
      expect(find.text('🇲🇽'), findsOneWidget);
      expect(find.text('🇯🇵'), findsOneWidget);
    });

    testWidgets('debería mostrar estado vacío cuando no hay países',
        (WidgetTester tester) async {
      final emptyCountries = CountriesTestHelper.getEmptyCountries();

      await tester.pumpWidget(
        ProviderScope(
          overrides:
              CountriesTestHelper.getMockCountriesOverride(emptyCountries),
          child: const MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No se encontraron países'), findsOneWidget);
      expect(find.text('Intenta refrescar la lista para cargar los datos'),
          findsOneWidget);
      expect(find.byIcon(Icons.public_off_outlined), findsOneWidget);
    });

    testWidgets('debería mostrar estado de error cuando falla la carga',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: CountriesTestHelper.getErrorCountriesOverride(
              'Error de conexión'),
          child: const MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Oops! Algo salió mal'), findsOneWidget);
      expect(find.text('Exception: Error de conexión'), findsOneWidget);
      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('debería mostrar países sin emoji con iniciales',
        (WidgetTester tester) async {
      final countriesWithoutEmoji =
          CountriesTestHelper.getCountryWithoutEmoji();

      await tester.pumpWidget(
        ProviderScope(
          overrides: CountriesTestHelper.getMockCountriesOverride(
              countriesWithoutEmoji),
          child: const MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Estados Unidos'), findsOneWidget);
      expect(find.text('ES'), findsOneWidget); // Iniciales de "Estados Unidos"
    });

    testWidgets('debería mostrar estadísticas cuando hay países',
        (WidgetTester tester) async {
      final mockCountries = CountriesTestHelper.getMockCountries();

      await tester.pumpWidget(
        ProviderScope(
          overrides:
              CountriesTestHelper.getMockCountriesOverride(mockCountries),
          child: const MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Países Cargados'), findsOneWidget);
      expect(find.text('Explora culturas de todo el mundo'), findsOneWidget);
      expect(find.byIcon(Icons.explore), findsOneWidget);
    });

    testWidgets('debería permitir tap en un país', (WidgetTester tester) async {
      final mockCountries = CountriesTestHelper.getMockCountries();

      await tester.pumpWidget(
        ProviderScope(
          overrides:
              CountriesTestHelper.getMockCountriesOverride(mockCountries),
          child: const MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('España'));
      await tester.pumpAndSettle();

      expect(find.text('Tocaste: España'), findsOneWidget);
    });

    testWidgets('debería mostrar información de capital y continente',
        (WidgetTester tester) async {
      final mockCountries = CountriesTestHelper.getMockCountries();

      await tester.pumpWidget(
        ProviderScope(
          overrides:
              CountriesTestHelper.getMockCountriesOverride(mockCountries),
          child: const MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Capital: Madrid'), findsOneWidget);
      expect(find.text('Continente: Europa'), findsOneWidget);
      expect(find.text('Capital: Ciudad de México'), findsOneWidget);
      expect(find.text('Continente: América del Norte'), findsOneWidget);
      expect(find.text('Capital: Tokio'), findsOneWidget);
      expect(find.text('Continente: Asia'), findsOneWidget);
    });

    testWidgets('debería mostrar emojis de países cuando están disponibles',
        (WidgetTester tester) async {
      final mockCountries = CountriesTestHelper.getMockCountries();

      await tester.pumpWidget(
        ProviderScope(
          overrides:
              CountriesTestHelper.getMockCountriesOverride(mockCountries),
          child: const MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('🇪🇸'), findsOneWidget);
      expect(find.text('🇲🇽'), findsOneWidget);
      expect(find.text('🇯🇵'), findsOneWidget);
    });

    testWidgets('debería mostrar múltiples países en la lista',
        (WidgetTester tester) async {
      final mockCountries = CountriesTestHelper.getMockCountries();

      await tester.pumpWidget(
        ProviderScope(
          overrides:
              CountriesTestHelper.getMockCountriesOverride(mockCountries),
          child: const MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('España'), findsOneWidget);
      expect(find.text('México'), findsOneWidget);
      expect(find.text('Japón'), findsOneWidget);

      expect(find.byType(ListTile), findsNWidgets(3));
    });

    testWidgets('debería mostrar iconos de información en cada país',
        (WidgetTester tester) async {
      final mockCountries = CountriesTestHelper.getMockCountries();

      await tester.pumpWidget(
        ProviderScope(
          overrides:
              CountriesTestHelper.getMockCountriesOverride(mockCountries),
          child: const MaterialApp(
            home: CountriesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.location_city_outlined), findsNWidgets(3));
      expect(find.byIcon(Icons.public_outlined), findsNWidgets(3));
    });
  });
}
