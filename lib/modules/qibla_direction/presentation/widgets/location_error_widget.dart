import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:flutter/material.dart';

class LocationErrorWidget extends StatelessWidget {
  const LocationErrorWidget({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    const box = SizedBox(height: 32);
    const errorColor = Color(0xffb00020);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.location_off, size: 150, color: errorColor),
          box,
          Text(message, style: const TextStyle(color: errorColor, fontWeight: FontWeight.bold)),
          box,
          ElevatedButton(onPressed: onRetry, child: Text('Retry'.translated)),
        ],
      ),
    );
  }
}
