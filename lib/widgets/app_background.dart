import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo degradado
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF9FAFB), Color(0xFFEAEAFB)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Círculo superior izquierdo
        Positioned(
          top: -60,
          left: -60,
          child: _blurCircle(
            200,
            const Color(0xFF6A11CB).withValues(alpha: 0.2),
          ),
        ),

        // Círculo inferior derecho
        Positioned(
          bottom: -80,
          right: -40,
          child: _blurCircle(
            250,
            const Color(0xFFFF5E9C).withValues(alpha: 0.2),
          ),
        ),

        // Contenido de la pantalla
        SafeArea(child: child),
      ],
    );
  }

  Widget _blurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 120, spreadRadius: 60)],
      ),
    );
  }
}
