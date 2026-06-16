import 'package:flutter/material.dart';
import '../theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color>? gradientColors;
  final Color? color;
  final IconData? icon;
  final double height;
  final double radius;
  final double fontSize;
  final bool isOutline;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradientColors,
    this.color,
    this.icon,
    this.height = 50,
    this.radius = 12,
    this.fontSize = 16,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    // Si no se proveen colores, usar degradado azul por defecto
    final defaultGradient = gradientColors ?? [DominoTheme.primaryBlue, DominoTheme.neonBlue];

    return Container(
      height: height,
      decoration: isOutline 
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: color ?? DominoTheme.neonBlue, width: 2),
            )
          : DominoTheme.gradientButtonDecoration(
              colors: color != null ? [color!, color!] : defaultGradient,
              radius: radius,
            ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
