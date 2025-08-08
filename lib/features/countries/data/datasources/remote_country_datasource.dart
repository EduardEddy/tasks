import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/country_model.dart';

abstract class RemoteCountryDataSource {
  Future<List<CountryModel>> getCountries();
}

class RemoteCountryDataSourceImpl implements RemoteCountryDataSource {
  final GraphQLClient client;

  RemoteCountryDataSourceImpl(this.client);

  @override
  Future<List<CountryModel>> getCountries() async {
    const String query = '''
      query GetCountries {
        countries {
          name
          capital
          continent {
            name
          }
          emoji
        }
      }
    ''';

    try {
      final result = await client.query(QueryOptions(document: gql(query)));

      if (result.hasException) {
        throw Exception('Error al obtener países: ${result.exception}');
      }

      final data = result.data;
      if (data == null || data['countries'] == null) {
        return [];
      }

      final List<dynamic> countriesData = data['countries'] as List<dynamic>;

      return countriesData.map((countryData) {
        final Map<String, dynamic> countryMap =
            Map<String, dynamic>.from(countryData);

        if (countryMap['continent'] != null && countryMap['continent'] is Map) {
          countryMap['continent'] = countryMap['continent']['name'];
        }

        return CountryModel.fromJson(countryMap);
      }).toList();
    } catch (e) {
      throw Exception('Error en la consulta GraphQL: $e');
    }
  }
}
