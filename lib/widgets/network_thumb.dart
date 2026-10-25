import 'package:flutter/material.dart';

/// Miniatura redonda de red con fallback si no hay URL o falla la carga.
class NetworkThumb extends StatelessWidget {
  const NetworkThumb({
    super.key,
    required this.url,
    required this.size,
    required this.fallback,
  });

  final String? url;
  final double size;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    final imageUrl = url;
    if (imageUrl == null) return SizedBox.square(dimension: size, child: fallback);

    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            SizedBox.square(dimension: size, child: fallback),
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : SizedBox.square(dimension: size, child: fallback),
      ),
    );
  }
}
