import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppError({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry'))
          ],
        ),
      ),
    );
  }
}
