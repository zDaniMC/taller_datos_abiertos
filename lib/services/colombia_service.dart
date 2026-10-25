import 'dart:convert';

import 'package:dio/dio.dart';

import '../config/env.dart';
import '../models/api_endpoint.dart';
import '../models/api_entity.dart';
import 'api_exception.dart';

/// Capa de acceso a API Colombia con Dio. Toda peticion HTTP de la app
/// pasa por aqui.
///
/// - Maneja status codes (200, 404, 429, 5xx) y los traduce a [ApiException].
/// - Traduce los errores de Dio (timeout, sin conexion) a mensajes claros.
/// - Guarda en memoria los listados: la API limita a 60 solicitudes por minuto
///   por IP y estos datos casi no cambian.
class ColombiaService {
  ColombiaService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: Env.apiBaseUrl,
                connectTimeout: Env.requestTimeout,
                receiveTimeout: Env.requestTimeout,
                headers: const {'Accept': 'application/json'},
                // Los status codes se evaluan manualmente en _get.
                validateStatus: (_) => true,
              ),
            );

  final Dio _dio;
  final Map<ApiEndpoint, List<ApiEntity>> _cache = {};

  /// GET {base}/{Endpoint}
  Future<List<ApiEntity>> getAll(
    ApiEndpoint endpoint, {
    bool forceRefresh = false,
  }) async {
    final cached = _cache[endpoint];
    if (!forceRefresh && cached != null) return cached;

    final body = await _get('/${endpoint.path}');
    if (body is! List) {
      throw const ApiException('La API devolvio un formato inesperado.');
    }

    final items = body
        .whereType<Map<String, dynamic>>()
        .map(endpoint.fromJson)
        .toList(growable: false);
    _cache[endpoint] = items;
    return items;
  }

  /// GET {base}/{Endpoint}/{id}
  Future<ApiEntity> getById(ApiEndpoint endpoint, int id) async {
    final body = await _get('/${endpoint.path}/$id');
    if (body is! Map<String, dynamic>) {
      throw const ApiException('La API devolvio un formato inesperado.');
    }
    return endpoint.fromJson(body);
  }

  Future<dynamic> _get(String path) async {
    final Response<dynamic> response;
    try {
      response = await _dio.get<dynamic>(path);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }

    final status = response.statusCode ?? 0;
    switch (status) {
      case 200:
        final data = response.data;
        if (data is String) {
          try {
            return jsonDecode(data);
          } on FormatException {
            throw const ApiException('No se pudo leer la respuesta de la API.');
          }
        }
        return data;
      case 404:
        throw ApiException('Recurso no encontrado.', statusCode: status);
      case 429:
        throw ApiException(
            'Demasiadas solicitudes. Espera un minuto e intenta de nuevo.',
            statusCode: status);
      default:
        if (status >= 500) {
          throw ApiException('El servidor tuvo un problema.',
              statusCode: status);
        }
        throw ApiException('Error inesperado al consultar la API.',
            statusCode: status);
    }
  }

  ApiException _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
            'La solicitud tardo demasiado. Intenta de nuevo.');
      case DioExceptionType.connectionError:
        return const ApiException(
            'No se pudo conectar. Revisa tu conexion a internet.');
      case DioExceptionType.cancel:
        return const ApiException('La solicitud fue cancelada.');
      default:
        return ApiException(
          'Error de red al consultar la API.',
          statusCode: e.response?.statusCode,
        );
    }
  }

  void dispose() => _dio.close();
}

/// Instancia unica usada por las vistas.
final ColombiaService colombiaService = ColombiaService();
