import 'api_entity.dart';
import 'json_utils.dart';

class Department extends ApiEntity {
  const Department({
    required this.id,
    required this.name,
    this.description,
    this.municipalities,
    this.surface,
    this.population,
    this.phonePrefix,
    this.regionId,
    this.regionName,
  });

  @override
  final int id;
  final String name;
  @override
  final String? description;
  final int? municipalities;
  final double? surface;
  final int? population;
  final String? phonePrefix;
  final int? regionId;
  final String? regionName;

  factory Department.fromJson(Map<String, dynamic> json) {
    final region = json['region'];
    return Department(
      id: asInt(json['id']),
      name: asString(json['name']) ?? 'Sin nombre',
      description: asString(json['description']),
      municipalities:
          json['municipalities'] == null ? null : asInt(json['municipalities']),
      surface: asDouble(json['surface']),
      population: json['population'] == null ? null : asInt(json['population']),
      phonePrefix: asString(json['phonePrefix']),
      regionId: json['regionId'] == null ? null : asInt(json['regionId']),
      regionName: region is Map ? asString(region['name']) : null,
    );
  }

  @override
  String get title => name;

  @override
  String? get subtitle => regionName == null ? null : 'Region $regionName';

  @override
  String? get imageUrl => null;

  @override
  Map<String, String> get details => {
        if (regionName != null) 'Region': regionName!,
        if (municipalities != null) 'Municipios': '$municipalities',
        if (population != null) 'Poblacion': formatNumber(population!),
        if (surface != null) 'Superficie': '${formatNumber(surface!)} km2',
        if (phonePrefix != null) 'Prefijo telefonico': phonePrefix!,
      };

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'municipalities': municipalities,
        'surface': surface,
        'population': population,
        'phonePrefix': phonePrefix,
        'regionId': regionId,
        'region': regionName == null
            ? null
            : {'id': regionId, 'name': regionName},
      };
}
