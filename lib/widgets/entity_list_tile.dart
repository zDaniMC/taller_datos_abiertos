import 'package:flutter/material.dart';

import '../models/api_entity.dart';
import 'network_thumb.dart';

/// Fila del listado: miniatura (si existe), titulo y subtitulo.
class EntityListTile extends StatelessWidget {
  const EntityListTile({super.key, required this.entity, required this.onTap});

  final ApiEntity entity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final subtitle = entity.subtitle;

    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: NetworkThumb(
          url: entity.imageUrl,
          size: 56,
          fallback: CircleAvatar(
            radius: 28,
            backgroundColor: scheme.primaryContainer,
            child: Text(
              entity.title.isEmpty ? '?' : entity.title[0].toUpperCase(),
              style: TextStyle(color: scheme.onPrimaryContainer),
            ),
          ),
        ),
        title: Text(entity.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: subtitle == null
            ? null
            : Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
