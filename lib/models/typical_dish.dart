import 'api_entity.dart';
import 'json_utils.dart';

class TypicalDish extends ApiEntity {
  const TypicalDish({
    required this.id,
    required this.name,
    this.description,
    this.ingredients,
    this.image,
  });

  @override
  final int id;
  final String name;
  @override
  final String? description;
  final String? ingredients;
  final String? image;

  factory TypicalDish.fromJson(Map<String, dynamic> json) => TypicalDish(
        id: asInt(json['id']),
        name: asString(json['name']) ?? 'Sin nombre',
        description: asString(json['description']),
        ingredients: asString(json['ingredients']),
        image: asString(json['imageUrl']) ?? asString(json['image']),
      );

  @override
  String get title => name;

  @override
  String? get subtitle => ingredients;

  @override
  String? get imageUrl => image;

  @override
  Map<String, String> get details => {
        if (ingredients != null) 'Ingredientes': ingredients!,
      };

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'ingredients': ingredients,
        'imageUrl': image,
      };
}
