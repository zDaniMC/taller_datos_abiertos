import 'api_entity.dart';
import 'json_utils.dart';

class TouristicAttraction extends ApiEntity {
  const TouristicAttraction({
    required this.id,
    required this.name,
    this.description,
    this.latitude,
    this.longitude,
    this.cityName,
    this.images = const [],
  });

  @override
  final int id;
  final String name;
  @override
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? cityName;
  final List<String> images;

  factory TouristicAttraction.fromJson(Map<String, dynamic> json) {
    final city = json['city'];
    final rawImages = json['images'];
    return TouristicAttraction(
      id: asInt(json['id']),
      name: asString(json['name']) ?? 'Sin nombre',
      description: asString(json['description']),
      latitude: asDouble(json['latitude']),
      longitude: asDouble(json['longitude']),
      cityName: city is Map ? asString(city['name']) : null,
      images: rawImages is List
          ? rawImages.map(asString).whereType<String>().toList()
          : const [],
    );
  }

  @override
  String get title => name;

  @override
  String? get subtitle => cityName;

  @override
  String? get imageUrl => images.isEmpty ? null : images.first;

  @override
  Map<String, String> get details => {
        if (cityName != null) 'Ciudad': cityName!,
        if (latitude != null) 'Latitud': latitude!.toStringAsFixed(5),
        if (longitude != null) 'Longitud': longitude!.toStringAsFixed(5),
        if (images.isNotEmpty) 'Imagenes': '${images.length}',
      };

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'city': cityName == null ? null : {'name': cityName},
        'images': images,
      };
}
