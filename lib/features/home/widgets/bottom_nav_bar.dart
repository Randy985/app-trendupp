import 'dart:ui';
import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.9),
                  Colors.white.withValues(alpha: 0.7),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  index: 0,
                  currentIndex: currentIndex,
                  icon: Icons.home_rounded,
                  label: 'Inicio',
                  onTap: onTap,
                  activeColor: const Color(0xFF667EEA),
                ),
                _NavItem(
                  index: 1,
                  currentIndex: currentIndex,
                  icon: Icons.bookmark_rounded,
                  label: 'Guardadas',
                  onTap: onTap,
                  activeColor: const Color(0xFFFF6B9D),
                ),
                _NavItem(
                  index: 2,
                  currentIndex: currentIndex,
                  icon: Icons.person_rounded,
                  label: 'Perfil',
                  onTap: onTap,
                  activeColor: const Color(0xFF4FACFE),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final String label;
  final ValueChanged<int> onTap;
  final Color activeColor;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 16,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono con animación
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              padding: EdgeInsets.all(isSelected ? 8 : 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor.withValues(alpha: 0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: isSelected ? 26 : 24,
                color: isSelected ? activeColor : Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 4),

            // Label con animación
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              style: TextStyle(
                fontSize: isSelected ? 12 : 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? activeColor : Colors.grey.shade600,
                letterSpacing: 0.3,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// VERSIÓN ALTERNATIVA: Estilo iOS/Minimalista
class CustomBottomNavMinimal extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavMinimal({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _MinimalNavItem(
              index: 0,
              currentIndex: currentIndex,
              icon: Icons.home_rounded,
              label: 'Inicio',
              onTap: onTap,
            ),
            _MinimalNavItem(
              index: 1,
              currentIndex: currentIndex,
              icon: Icons.bookmark_rounded,
              label: 'Guardadas',
              onTap: onTap,
            ),
            _MinimalNavItem(
              index: 2,
              currentIndex: currentIndex,
              icon: Icons.person_rounded,
              label: 'Perfil',
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _MinimalNavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final String label;
  final ValueChanged<int> onTap;

  const _MinimalNavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentIndex == index;
    const primaryColor = Color(0xFF667EEA);

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutCubic,
              transform: Matrix4.identity()..scale(isSelected ? 1.1 : 1.0),
              child: Icon(
                icon,
                size: 26,
                color: isSelected ? primaryColor : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutCubic,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? primaryColor : Colors.grey.shade500,
              ),
              child: Text(label),
            ),
            const SizedBox(height: 4),
            // Indicador de línea
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutCubic,
              width: isSelected ? 30 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// VERSIÓN ALTERNATIVA 3: Estilo Flotante con Indicador Grande
class CustomBottomNavFloating extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavFloating({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withValues(alpha: 0.3),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _FloatingNavItem(
            index: 0,
            currentIndex: currentIndex,
            icon: Icons.home_rounded,
            onTap: onTap,
          ),
          _FloatingNavItem(
            index: 1,
            currentIndex: currentIndex,
            icon: Icons.bookmark_rounded,
            onTap: onTap,
          ),
          _FloatingNavItem(
            index: 2,
            currentIndex: currentIndex,
            icon: Icons.person_rounded,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _FloatingNavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final ValueChanged<int> onTap;

  const _FloatingNavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        width: isSelected ? 70 : 50,
        height: isSelected ? 70 : 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: isSelected ? 28 : 24,
          color: isSelected ? Colors.white : Colors.grey.shade500,
        ),
      ),
    );
  }
}
