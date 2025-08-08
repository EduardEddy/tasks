import '../entities/country.dart';
import '../repositories/country_repository.dart';

class GetCountriesUseCase {
  final CountryRepository repository;

  GetCountriesUseCase(this.repository);

  Future<List<Country>> call() async {
    return await repository.getCountries();
  }
} 