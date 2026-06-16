import 'package:flutter/material.dart';

class DominoTileWidget extends StatelessWidget {
  final int top;
  final int bottom;
  final double size;
  final VoidCallback? onTap;
  final bool isSelected;

  const DominoTileWidget({
    super.key,
    required this.top,
    required this.bottom,
    this.size = 60,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = size;
    final height = size * 1.8;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFD54F) : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFB300) : const Color(0xFFBDC3C7),
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Mitad Superior
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(size * 0.12),
                  child: _DominoDots(dots: top, size: size),
                ),
              ),
            ),
            // Linea Divisoria Central
            Container(
              height: 2,
              color: const Color(0xFF7F8C8D),
              margin: const EdgeInsets.symmetric(horizontal: 4),
            ),
            // Mitad Inferior
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(size * 0.12),
                  child: _DominoDots(dots: bottom, size: size),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DominoDots extends StatelessWidget {
  final int dots;
  final double size;

  const _DominoDots({required this.dots, required this.size});

  @override
  Widget build(BuildContext context) {
    final dotSize = size * 0.12;

    // Retorna las posiciones de los puntos en una matriz de 3x3
    List<bool> getDotPositions(int count) {
      // Index correspondientes a una lista de 9 posiciones (0 a 8) en una matriz 3x3
      // 0 1 2
      // 3 4 5
      // 6 7 8
      switch (count) {
        case 0:
          return List.filled(9, false);
        case 1:
          return [
            false, false, false,
            false, true,  false,
            false, false, false,
          ];
        case 2:
          return [
            true,  false, false,
            false, false, false,
            false, false, true,
          ];
        case 3:
          return [
            true,  false, false,
            false, true,  false,
            false, false, true,
          ];
        case 4:
          return [
            true,  false, true,
            false, false, false,
            true,  false, true,
          ];
        case 5:
          return [
            true,  false, true,
            false, true,  false,
            true,  false, true,
          ];
        case 6:
          return [
            true,  false, true,
            true,  false, true,
            true,  false, true,
          ];
        default:
          return List.filled(9, false);
      }
    }

    final positions = getDotPositions(dots);

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        final hasDot = positions[index];
        return Center(
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hasDot ? const Color(0xFF1E272C) : Colors.transparent,
            ),
          ),
        );
      },
    );
  }
}
