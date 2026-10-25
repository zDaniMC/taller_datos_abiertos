/// Helpers para parsear JSON de forma tolerante (la API a veces devuelve
/// numeros como texto o campos nulos).
int asInt(dynamic value, [int fallback = 0]) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? fallback;
}

double? asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse('$value');
}

String? asString(dynamic value) {
  if (value == null) return null;
  final text = '$value'.trim();
  return text.isEmpty ? null : text;
}

/// Convierte "2022-08-07T00:00:00" en "2022-08-07".
String? asDate(dynamic value) {
  final text = asString(value);
  if (text == null) return null;
  return text.length >= 10 ? text.substring(0, 10) : text;
}

String formatNumber(num value) {
  final digits = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    buffer.write(digits[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
  }
  return buffer.toString();
}
