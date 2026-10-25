import 'api_entity.dart';
import 'json_utils.dart';

class President extends ApiEntity {
  const President({
    required this.id,
    required this.name,
    this.lastName,
    this.image,
    this.startPeriodDate,
    this.endPeriodDate,
    this.politicalParty,
    this.description,
  });

  @override
  final int id;
  final String name;
  final String? lastName;
  final String? image;
  final String? startPeriodDate;
  final String? endPeriodDate;
  final String? politicalParty;
  @override
  final String? description;

  factory President.fromJson(Map<String, dynamic> json) => President(
        id: asInt(json['id']),
        name: asString(json['name']) ?? 'Sin nombre',
        lastName: asString(json['lastName']),
        image: asString(json['image']),
        startPeriodDate: asDate(json['startPeriodDate']),
        endPeriodDate: asDate(json['endPeriodDate']),
        politicalParty: asString(json['politicalParty']),
        description: asString(json['description']),
      );

  @override
  String get title => [name, lastName].whereType<String>().join(' ');

  @override
  String? get subtitle => politicalParty;

  @override
  String? get imageUrl => image;

  @override
  Map<String, String> get details => {
        if (politicalParty != null) 'Partido politico': politicalParty!,
        if (startPeriodDate != null) 'Inicio del periodo': startPeriodDate!,
        if (endPeriodDate != null) 'Fin del periodo': endPeriodDate!,
      };

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lastName': lastName,
        'image': image,
        'startPeriodDate': startPeriodDate,
        'endPeriodDate': endPeriodDate,
        'politicalParty': politicalParty,
        'description': description,
      };
}
