import 'api_entity.dart';
import 'json_utils.dart';

class Region extends ApiEntity {
  const Region({
    required this.id,
    required this.name,
    this.description,
  });

  @override
  final int id;
  final String name;
  @override
  final String? description;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        id: asInt(json['id']),
        name: asString(json['name']) ?? 'Sin nombre',
        description: asString(json['description']),
      );

  @override
  String get title => name;

  @override
  String? get subtitle => null;

  @override
  String? get imageUrl => null;

  @override
  Map<String, String> get details => const {};

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };
}
