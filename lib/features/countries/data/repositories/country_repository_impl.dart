import '../../domain/entities/country.dart';
import '../../domain/repositories/country_repository.dart';
import '../datasources/remote_country_datasource.dart';
import '../models/country_model.dart';

class CountryRepositoryImpl implements CountryRepository {
  final RemoteCountryDataSource remoteDataSource;

  CountryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Country>> getCountries() async {
    try {
      final countryModels = await remoteDataSource.getCountries();
      return countryModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener países: $e');
    }
  }
}
