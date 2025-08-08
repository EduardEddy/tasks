import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/country.dart';

part 'country_model.freezed.dart';
part 'country_model.g.dart';

@freezed
class CountryModel with _$CountryModel {
  const factory CountryModel({
    required String name,
    String? capital,
    String? continent,
    String? emoji,
  }) = _CountryModel;

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  factory CountryModel.fromEntity(Country country) {
    return CountryModel(
      name: country.name,
      capital: country.capital,
      continent: country.continent,
      emoji: country.emoji,
    );
  }
}

extension CountryModelX on CountryModel {
  Country toEntity() {
    return Country(
      name: name,
      capital: capital,
      continent: continent,
      emoji: emoji,
    );
  }
}
