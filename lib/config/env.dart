import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Acceso centralizado a las variables de entorno (.env).
class Env {
  Env._();

  static const String _defaultBaseUrl = 'https://api-colombia.com/api/v1';
  static const int _defaultTimeoutSeconds = 15;

  static String? _read(String key) =>
      dotenv.isInitialized ? dotenv.maybeGet(key) : null;

  /// URL base de la API (sin slash final).
  static String get apiBaseUrl {
    final value = _read('API_BASE_URL');
    final url = (value == null || value.trim().isEmpty)
        ? _defaultBaseUrl
        : value.trim();
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  /// Tiempo maximo de espera por peticion.
  static Duration get requestTimeout {
    final seconds = int.tryParse(_read('REQUEST_TIMEOUT_SECONDS') ?? '');
    return Duration(seconds: seconds ?? _defaultTimeoutSeconds);
  }
}
