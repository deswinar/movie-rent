import 'package:flutter/material.dart';

class AppEmpty extends StatelessWidget {
  final String message;

  const AppEmpty({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
      ),
    );
  }
}
