import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/api_endpoint.dart';
import '../widgets/endpoint_card.dart';

/// Home: una card por cada endpoint seleccionado.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Datos Abiertos de Colombia')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Explora Colombia',
                      style: textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'Datos publicos de api-colombia.com. '
                    'Elige una categoria para ver su listado.',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 260,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemCount: ApiEndpoint.values.length,
              itemBuilder: (context, index) {
                final endpoint = ApiEndpoint.values[index];
                return EndpointCard(
                  endpoint: endpoint,
                  onTap: () => context.pushNamed(
                    'list',
                    pathParameters: {'endpoint': endpoint.slug},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
