// lib/widgets/responsive_layout_wrapper.dart
import 'package:flutter/material.dart';

class ResponsiveLayoutWrapper extends StatelessWidget {
  final Widget child;

  // Le damos un ancho máximo más pequeño para formularios
  final double maxWidth;

  const ResponsiveLayoutWrapper({
    super.key,
    required this.child,
    this.maxWidth = 800, // 800px es bueno para formularios
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
