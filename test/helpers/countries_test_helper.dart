import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/features/countries/domain/entities/country.dart';
import 'package:tasks/features/countries/presentation/providers/countries_provider.dart';

class CountriesTestHelper {
  static List<Country> getMockCountries() {
    return [
      const Country(
        name: 'España',
        capital: 'Madrid',
        continent: 'Europa',
        emoji: '🇪🇸',
      ),
      const Country(
        name: 'México',
        capital: 'Ciudad de México',
        continent: 'América del Norte',
        emoji: '🇲🇽',
      ),
      const Country(
        name: 'Japón',
        capital: 'Tokio',
        continent: 'Asia',
        emoji: '🇯🇵',
      ),
    ];
  }

  static List<Country> getEmptyCountries() {
    return [];
  }

  static List<Country> getCountryWithoutEmoji() {
    return [
      const Country(
        name: 'Estados Unidos',
        capital: 'Washington D.C.',
        continent: 'América del Norte',
      ),
    ];
  }

  static List<Override> getMockCountriesOverride(List<Country> countries) {
    return [
      countriesNotifierProvider.overrideWith(
        () => MockCountriesNotifier(countries),
      ),
    ];
  }

  static List<Override> getErrorCountriesOverride(String errorMessage) {
    return [
      countriesNotifierProvider.overrideWith(
        () => MockCountriesNotifierWithError(errorMessage),
      ),
    ];
  }
}

class MockCountriesNotifier extends CountriesNotifier {
  final List<Country> countries;

  MockCountriesNotifier(this.countries);

  @override
  Future<List<Country>> build() async {
    return countries;
  }

  @override
  Future<void> refreshCountries() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(countries);
  }
}

class MockCountriesNotifierWithError extends CountriesNotifier {
  final String errorMessage;

  MockCountriesNotifierWithError(this.errorMessage);

  @override
  Future<List<Country>> build() async {
    throw Exception(errorMessage);
  }

  @override
  Future<void> refreshCountries() async {
    state = const AsyncValue.loading();
    state = AsyncValue.error(Exception(errorMessage), StackTrace.current);
  }
}
