import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tasks/core/utils/constants.dart';
import '../../domain/entities/country.dart';
import '../../domain/repositories/country_repository.dart';
import '../../domain/usecases/get_countries_usecase.dart';
import '../../data/repositories/country_repository_impl.dart';
import '../../data/datasources/remote_country_datasource.dart';

final countriesNotifierProvider =
    AsyncNotifierProvider<CountriesNotifier, List<Country>>(() {
  return CountriesNotifier();
});

class CountriesNotifier extends AsyncNotifier<List<Country>> {
  @override
  Future<List<Country>> build() async {
    final getCountriesUseCase = ref.read(getCountriesUseCaseProvider);
    return await getCountriesUseCase();
  }

  Future<void> refreshCountries() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final getCountriesUseCase = ref.read(getCountriesUseCaseProvider);
      return await getCountriesUseCase();
    });
  }
}

final getCountriesUseCaseProvider = Provider<GetCountriesUseCase>((ref) {
  final countryRepository = ref.read(countryRepositoryProvider);
  return GetCountriesUseCase(countryRepository);
});

final countryRepositoryProvider = Provider<CountryRepository>((ref) {
  final remoteDataSource = ref.read(remoteCountryDataSourceProvider);
  return CountryRepositoryImpl(remoteDataSource);
});

final remoteCountryDataSourceProvider =
    Provider<RemoteCountryDataSource>((ref) {
  final graphQLClient = ref.read(graphQLClientProvider);
  return RemoteCountryDataSourceImpl(graphQLClient);
});

final graphQLClientProvider = Provider<GraphQLClient>((ref) {
  const String url = AppConstants.baseUrlGraphql;
  final HttpLink httpLink = HttpLink(url);
  return GraphQLClient(link: httpLink, cache: GraphQLCache());
});
