import 'package:flutter_test/flutter_test.dart';
import 'package:taller_datos_abiertos/models/api_endpoint.dart';
import 'package:taller_datos_abiertos/models/department.dart';
import 'package:taller_datos_abiertos/models/president.dart';
import 'package:taller_datos_abiertos/models/touristic_attraction.dart';

void main() {
  test('Department.fromJson lee region anidada y toJson conserva el id', () {
    final department = Department.fromJson({
      'id': 2,
      'name': 'Antioquia',
      'municipalities': 125,
      'population': 6900000,
      'surface': 63612,
      'regionId': 5,
      'region': {'id': 5, 'name': 'Andina'},
    });

    expect(department.title, 'Antioquia');
    expect(department.subtitle, 'Region Andina');
    expect(department.toJson()['id'], 2);
  });

  test('President.fromJson recorta fechas y arma el nombre completo', () {
    final president = President.fromJson({
      'id': 1,
      'name': 'Simon',
      'lastName': 'Bolivar',
      'startPeriodDate': '1819-12-17T00:00:00',
    });

    expect(president.title, 'Simon Bolivar');
    expect(president.startPeriodDate, '1819-12-17');
  });

  test('TouristicAttraction tolera campos nulos y numeros como texto', () {
    final attraction = TouristicAttraction.fromJson({
      'id': '7',
      'name': 'Cano Cristales',
      'latitude': '2.2667',
      'images': null,
    });

    expect(attraction.id, 7);
    expect(attraction.latitude, 2.2667);
    expect(attraction.images, isEmpty);
  });

  test('ApiEndpoint.fromSlug resuelve el endpoint o devuelve null', () {
    expect(ApiEndpoint.fromSlug('typical-dish'), ApiEndpoint.typicalDish);
    expect(ApiEndpoint.fromSlug('nope'), isNull);
  });
}
