import 'package:flutter/material.dart';

class MainCardBackground extends StatelessWidget {
  final Color categoryColor;

  const MainCardBackground({
    super.key,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/inspiration.png',
          fit: BoxFit.cover,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                categoryColor.withValues(alpha: 0.12),
                categoryColor.withValues(alpha: 0.26),
                Colors.black.withValues(alpha: 0.58),
              ],
            ),
          ),
        ),
      ],
    );
  }
}