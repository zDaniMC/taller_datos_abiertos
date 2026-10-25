import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/api_endpoint.dart';
import '../views/dashboard_view.dart';
import '../views/detail_view.dart';
import '../views/list_view.dart';
import '../widgets/state_views.dart';

/// Rutas con nombre de la app.
///
///   /                                        -> dashboard
///   /list/:endpoint                          -> list
///   /list/:endpoint/detail/:id?name=<titulo> -> detail
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) => _NotFoundView(
      message: 'La ruta "${state.uri}" no existe.',
    ),
    routes: [
      GoRoute(
        name: 'dashboard',
        path: '/',
        builder: (context, state) => const DashboardView(),
        routes: [
          GoRoute(
            name: 'list',
            path: 'list/:endpoint',
            builder: (context, state) {
              final endpoint =
                  ApiEndpoint.fromSlug(state.pathParameters['endpoint']);
              if (endpoint == null) {
                return const _NotFoundView(message: 'Endpoint desconocido.');
              }
              return EndpointListView(endpoint: endpoint);
            },
            routes: [
              GoRoute(
                name: 'detail',
                path: 'detail/:id',
                builder: (context, state) {
                  final endpoint =
                      ApiEndpoint.fromSlug(state.pathParameters['endpoint']);
                  final id = int.tryParse(state.pathParameters['id'] ?? '');
                  if (endpoint == null || id == null) {
                    return const _NotFoundView(
                        message: 'Registro no valido.');
                  }
                  return DetailView(
                    endpoint: endpoint,
                    id: id,
                    initialTitle: state.uri.queryParameters['name'],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _NotFoundView extends StatelessWidget {
  const _NotFoundView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('No encontrado')),
      body: ErrorView(
        message: message,
        actionLabel: 'Ir al inicio',
        onRetry: () => context.goNamed('dashboard'),
      ),
    );
  }
}
