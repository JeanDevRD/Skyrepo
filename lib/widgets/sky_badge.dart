import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SkyBadge extends StatelessWidget {
  final String categoria;
  const SkyBadge({super.key, required this.categoria});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CircleAvatar(
      backgroundColor: scheme.primary.withOpacity(0.15),
      foregroundColor: scheme.primary,
      child: Icon(AppTheme.iconoCategoria(categoria), size: 20),
    );
  }
}