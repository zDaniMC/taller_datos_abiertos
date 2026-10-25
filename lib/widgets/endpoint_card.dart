import 'package:flutter/material.dart';

import '../models/api_endpoint.dart';

/// Card del Dashboard que introduce un endpoint.
class EndpointCard extends StatelessWidget {
  const EndpointCard({super.key, required this.endpoint, required this.onTap});

  final ApiEndpoint endpoint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: scheme.secondary,
                child: Icon(endpoint.icon, color: scheme.onSecondary),
              ),
              const Spacer(),
              Text(
                endpoint.title,
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                endpoint.description,
                style: textTheme.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'GET /${endpoint.path}',
                style: textTheme.labelSmall?.copyWith(
                  color: scheme.primary,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
