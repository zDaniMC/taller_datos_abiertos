/// Contrato comun de todos los modelos de API Colombia.
///
/// Permite que el listado y el detalle sean genericos: cada modelo sabe
/// como presentarse (titulo, subtitulo, imagen, detalles) y como
/// serializarse (toJson).
abstract class ApiEntity {
  const ApiEntity();

  int get id;
  String get title;
  String? get subtitle;
  String? get imageUrl;
  String? get description;

  /// Pares etiqueta -> valor que se muestran en la pantalla de detalle.
  Map<String, String> get details;

  Map<String, dynamic> toJson();
}
