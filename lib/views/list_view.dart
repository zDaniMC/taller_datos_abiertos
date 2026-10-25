import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/api_endpoint.dart';
import '../models/api_entity.dart';
import '../services/api_exception.dart';
import '../services/colombia_service.dart';
import '../widgets/entity_list_tile.dart';
import '../widgets/state_views.dart';

enum LoadStatus { loading, success, error }

/// Listado de un endpoint (GET) con estados cargando / exito / error.
class EndpointListView extends StatefulWidget {
  const EndpointListView({super.key, required this.endpoint});

  final ApiEndpoint endpoint;

  @override
  State<EndpointListView> createState() => _EndpointListViewState();
}

class _EndpointListViewState extends State<EndpointListView> {
  LoadStatus _status = LoadStatus.loading;
  List<ApiEntity> _items = const [];
  String _errorMessage = '';
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool forceRefresh = false}) async {
    setState(() => _status = LoadStatus.loading);
    try {
      final items = await colombiaService.getAll(
        widget.endpoint,
        forceRefresh: forceRefresh,
      );
      if (!mounted) return;
      setState(() {
        _items = items;
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

  List<ApiEntity> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _items;
    return _items
        .where((item) => item.title.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.endpoint.title)),
      body: switch (_status) {
        LoadStatus.loading => const LoadingView(),
        LoadStatus.error => ErrorView(
            message: _errorMessage,
            onRetry: () => _load(forceRefresh: true),
          ),
        LoadStatus.success => _buildList(),
      },
    );
  }

  Widget _buildList() {
    final items = _filtered;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Buscar en ${widget.endpoint.title.toLowerCase()}',
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('${items.length} resultados',
                style: Theme.of(context).textTheme.labelMedium),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const EmptyView()
              : RefreshIndicator(
                  onRefresh: () => _load(forceRefresh: true),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: EntityListTile(
                          entity: item,
                          onTap: () => context.pushNamed(
                            'detail',
                            pathParameters: {
                              'endpoint': widget.endpoint.slug,
                              'id': '${item.id}',
                            },
                            queryParameters: {'name': item.title},
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
