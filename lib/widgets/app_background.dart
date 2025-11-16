import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

// OPCIÓN 1: MESH GRADIENT (MUY MODERNO - COMO APPLE)
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8F9FC), Color(0xFFEDF0F7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // Múltiples gradientes superpuestos (mesh effect)
        Positioned(
          top: -150,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF667EEA).withValues(alpha: 0.3),
                  const Color(0xFF667EEA).withValues(alpha: 0.15),
                  const Color(0xFF667EEA).withValues(alpha: 0.05),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
        ),

        Positioned(
          top: 100,
          right: -80,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFF6B9D).withValues(alpha: 0.25),
                  const Color(0xFFFF6B9D).withValues(alpha: 0.12),
                  const Color(0xFFFF6B9D).withValues(alpha: 0.04),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: -100,
          left: 50,
          child: Container(
            width: 380,
            height: 380,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF4FACFE).withValues(alpha: 0.28),
                  const Color(0xFF4FACFE).withValues(alpha: 0.14),
                  const Color(0xFF4FACFE).withValues(alpha: 0.05),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 150,
          right: 80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFECA57).withValues(alpha: 0.2),
                  const Color(0xFFFECA57).withValues(alpha: 0.1),
                  const Color(0xFFFECA57).withValues(alpha: 0.03),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
        ),

        SafeArea(child: child),
      ],
    );
  }
}

// OPCIÓN 2: GLASSMORPHISM CON BLUR
class AppBackgroundGlass extends StatelessWidget {
  final Widget child;

  const AppBackgroundGlass({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        Positioned(
          top: -100,
          right: -80,
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),

        Positioned(
          bottom: -80,
          left: -60,
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),

        Positioned(
          top: 200,
          left: 60,
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),

        SafeArea(child: child),
      ],
    );
  }
}

// OPCIÓN 3: OLAS EN LA PARTE INFERIOR
class AppBackgroundWaves extends StatelessWidget {
  final Widget child;

  const AppBackgroundWaves({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF5F7FA), Color(0xFFE8EBF0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            painter: _WavePainter(),
            size: Size(MediaQuery.of(context).size.width, 250),
          ),
        ),

        SafeArea(child: child),
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Ola 1 (más transparente)
    paint.color = const Color(0xFF2D5BFF).withValues(alpha: 0.15);
    final path1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.15,
        size.width * 0.5,
        size.height * 0.3,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.45,
        size.width,
        size.height * 0.3,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path1, paint);

    // Ola 2
    paint.color = const Color(0xFF00A6FB).withValues(alpha: 0.2);
    final path2 = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.35,
        size.width * 0.5,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.65,
        size.width,
        size.height * 0.5,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path2, paint);

    // Ola 3 (más sólida)
    paint.color = const Color(0xFF6B5FFF).withValues(alpha: 0.25);
    final path3 = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.55,
        size.width * 0.5,
        size.height * 0.7,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.85,
        size.width,
        size.height * 0.7,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) => false;
}

// OPCIÓN 4: FORMAS GEOMÉTRICAS MODERNAS
class AppBackgroundShapes extends StatelessWidget {
  final Widget child;

  const AppBackgroundShapes({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF5F7FA), Color(0xFFE3E7ED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        CustomPaint(painter: _ShapesPainter(), size: Size.infinite),

        SafeArea(child: child),
      ],
    );
  }
}

class _ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Círculo grande arriba izquierda
    paint.color = const Color(0xFF667EEA).withValues(alpha: 0.12);
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.2), 120, paint);

    // Cuadrado rotado arriba derecha
    paint.color = const Color(0xFFFF6B9D).withValues(alpha: 0.1);
    canvas.save();
    canvas.translate(size.width * 0.85, size.height * 0.15);
    canvas.rotate(math.pi / 4);
    canvas.drawRect(const Rect.fromLTWH(-70, -70, 140, 140), paint);
    canvas.restore();

    // Triángulo abajo izquierda
    paint.color = const Color(0xFF4FACFE).withValues(alpha: 0.13);
    final trianglePath = Path()
      ..moveTo(size.width * 0.1, size.height * 0.85)
      ..lineTo(size.width * 0.25, size.height * 0.75)
      ..lineTo(size.width * 0.3, size.height * 0.9)
      ..close();
    canvas.drawPath(trianglePath, paint);

    // Círculo mediano abajo derecha
    paint.color = const Color(0xFFFECA57).withValues(alpha: 0.15);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.8), 90, paint);
  }

  @override
  bool shouldRepaint(_ShapesPainter oldDelegate) => false;
}
