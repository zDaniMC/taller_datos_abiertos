import 'package:flutter/material.dart';

import 'api_entity.dart';
import 'department.dart';
import 'president.dart';
import 'region.dart';
import 'touristic_attraction.dart';
import 'typical_dish.dart';

typedef EntityParser = ApiEntity Function(Map<String, dynamic> json);

/// Endpoints de API Colombia usados por la app.
///
/// [path] es el recurso en la API y [slug] el segmento usado en las rutas
/// de go_router (/list/:endpoint).
enum ApiEndpoint {
  department(
    path: 'Department',
    slug: 'department',
    title: 'Departamentos',
    description: 'Los 32 departamentos y Bogota D.C.',
    icon: Icons.map_outlined,
    fromJson: Department.fromJson,
  ),
  president(
    path: 'President',
    slug: 'president',
    title: 'Presidentes',
    description: 'Historial de presidentes de Colombia.',
    icon: Icons.account_balance_outlined,
    fromJson: President.fromJson,
  ),
  touristicAttraction(
    path: 'TouristicAttraction',
    slug: 'touristic-attraction',
    title: 'Atracciones turisticas',
    description: 'Lugares para visitar en todo el pais.',
    icon: Icons.landscape_outlined,
    fromJson: TouristicAttraction.fromJson,
  ),
  typicalDish(
    path: 'TypicalDish',
    slug: 'typical-dish',
    title: 'Platos tipicos',
    description: 'Gastronomia tradicional colombiana.',
    icon: Icons.restaurant_outlined,
    fromJson: TypicalDish.fromJson,
  ),
  region(
    path: 'Region',
    slug: 'region',
    title: 'Regiones',
    description: 'Regiones naturales de Colombia.',
    icon: Icons.public_outlined,
    fromJson: Region.fromJson,
  );

  const ApiEndpoint({
    required this.path,
    required this.slug,
    required this.title,
    required this.description,
    required this.icon,
    required this.fromJson,
  });

  final String path;
  final String slug;
  final String title;
  final String description;
  final IconData icon;
  final EntityParser fromJson;

  static ApiEndpoint? fromSlug(String? slug) {
    for (final endpoint in ApiEndpoint.values) {
      if (endpoint.slug == slug) return endpoint;
    }
    return null;
  }
}
