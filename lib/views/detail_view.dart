import 'package:flutter/material.dart';

import '../models/api_endpoint.dart';
import '../models/api_entity.dart';
import '../models/touristic_attraction.dart';
import '../services/api_exception.dart';
import '../services/colombia_service.dart';
import '../widgets/detail_row.dart';
import '../widgets/state_views.dart';
import 'list_view.dart' show LoadStatus;

/// Detalle completo de un registro: GET /{Endpoint}/{id}.
///
/// Recibe el endpoint y el id por parametros de ruta, y opcionalmente el
/// titulo (query param) para mostrarlo en la AppBar mientras carga.
class DetailView extends StatefulWidget {
  const DetailView({
    super.key,
    required this.endpoint,
    required this.id,
    this.initialTitle,
  });

  final ApiEndpoint endpoint;
  final int id;
  final String? initialTitle;

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  LoadStatus _status = LoadStatus.loading;
  ApiEntity? _entity;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _status = LoadStatus.loading);
    try {
      final entity = await colombiaService.getById(widget.endpoint, widget.id);
      if (!mounted) return;
      setState(() {
        _entity = entity;
        _status = LoadStatus.success;
      });
    } on ApiException catch (e) {
      _fail(e.toString());
    } catch (_) {
      _fail('Ocurrio un error inesperado.');
    }
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() {
      _errorMessage = message;
      _status = LoadStatus.error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = _entity?.title ?? widget.initialTitle ?? widget.endpoint.title;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: switch (_status) {
        LoadStatus.loading => const LoadingView(message: 'Cargando detalle...'),
        LoadStatus.error => ErrorView(message: _errorMessage, onRetry: _load),
        LoadStatus.success => _buildContent(_entity!),
      },
    );
  }

  Widget _buildContent(ApiEntity entity) {
    final textTheme = Theme.of(context).textTheme;
    final images = entity is TouristicAttraction && entity.images.isNotEmpty
        ? entity.images
        : [if (entity.imageUrl != null) entity.imageUrl!];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (images.isNotEmpty) ...[
          _ImageHeader(images: images),
          const SizedBox(height: 16),
        ],
        Text(entity.title,
            style: textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        if (entity.subtitle != null) ...[
          const SizedBox(height: 4),
          Text(entity.subtitle!, style: textTheme.titleSmall),
        ],
        const SizedBox(height: 16),
        if (entity.description != null) ...[
          Text(entity.description!, style: textTheme.bodyLarge),
          const SizedBox(height: 16),
        ],
        if (entity.details.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (final row in entity.details.entries)
                    DetailRow(label: row.key, value: row.value),
                ],
              ),
            ),
          ),
        const SizedBox(height: 12),
        Text(
          'ID ${entity.id} · GET /${widget.endpoint.path}/${entity.id}',
          style: textTheme.labelSmall,
        ),
      ],
    );
  }
}

class _ImageHeader extends StatelessWidget {
  const _ImageHeader({required this.images});

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            images[index],
            height: 220,
            width: images.length == 1
                ? MediaQuery.sizeOf(context).width - 32
                : 300,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 300,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.image_not_supported_outlined, size: 48),
            ),
            loadingBuilder: (context, child, progress) => progress == null
                ? child
                : const SizedBox(
                    width: 300,
                    child: Center(child: CircularProgressIndicator()),
                  ),
          ),
        ),
      ),
    );
  }
}
