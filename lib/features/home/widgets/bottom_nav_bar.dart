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
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.home_rounded,
                label: 'Inicio',
                onTap: onTap,
              ),
              _NavItem(
                index: 1,
                currentIndex: currentIndex,
                icon: Icons.bookmark_rounded,
                label: 'Guardadas',
                onTap: onTap,
              ),
              _NavItem(
                index: 2,
                currentIndex: currentIndex,
                icon: Icons.person_rounded,
                label: 'Perfil',
                onTap: onTap,
              ),
            ],
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

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isSelected ? 26 : 24,
              color: isSelected ? Colors.black87 : Colors.black54,
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.black87 : Colors.black54,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
