import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F1524),
              DominoTheme.backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Escudo/Logo de Dominó
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Anillo brillante de fondo
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: DominoTheme.neonRed.withOpacity(0.15),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                          BoxShadow(
                            color: DominoTheme.neonBlue.withOpacity(0.15),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    // Laureles y Escudo
                    Column(
                      children: [
                        // Fichas de dominó inclinadas en el logo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.rotate(
                              angle: -0.2,
                              child: _LogoTile(top: 5, bottom: 5),
                            ),
                            const SizedBox(width: 8),
                            Transform.rotate(
                              angle: 0.15,
                              child: _LogoTile(top: 6, bottom: 6),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Texto principal del logo
                        const Text(
                          'DOMINÓ',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: Colors.white,
                            shadows: [
                              Shadow(color: Colors.black45, offset: Offset(2, 2), blurRadius: 4),
                            ],
                          ),
                        ),
                        // Número 200 con la bandera dominicana (Colores azul, rojo, blanco)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              colors: [DominoTheme.primaryBlue, Colors.white, DominoTheme.primaryRed],
                              stops: [0.4, 0.5, 0.6],
                            ),
                          ),
                          child: const Text(
                            '200',
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                // Botón Iniciar App
                CustomButton(
                  text: 'Iniciar App',
                  gradientColors: const [DominoTheme.neonRed, Color(0xFFC62828)],
                  height: 55,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Liga de Dominó RD v1.0',
                  style: TextStyle(
                    color: DominoTheme.textMuted,
                    fontSize: 12,
                    letterSpacing: 1,
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

// Widget simple para las fichas del logo
class _LogoTile extends StatelessWidget {
  final int top;
  final int bottom;

  const _LogoTile({required this.top, required this.bottom});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 6, offset: const Offset(2, 4))
        ],
      ),
      child: Column(
        children: [
          Expanded(child: Center(child: Text('$top', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)))),
          Container(height: 1.5, color: Colors.grey),
          Expanded(child: Center(child: Text('$bottom', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)))),
        ],
      ),
    );
  }
}

// Extensión para simplificar padding vertical en layouts
extension on BoxDecoration {
  // Solo para soporte de compilar sin warnings
}
