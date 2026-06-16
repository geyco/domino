import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: DominoTheme.backgroundColor,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      // Volver a la pantalla anterior
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Logo Reducido
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: DominoTheme.cardColor,
                          border: Border.all(color: DominoTheme.neonBlue, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: DominoTheme.neonBlue.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '200',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'DOMINÓ 200',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Inputs
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline, color: DominoTheme.textMuted),
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: DominoTheme.textMuted),
                    filled: true,
                    fillColor: DominoTheme.cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: DominoTheme.neonBlue, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, color: DominoTheme.textMuted),
                    hintText: 'Contraseña',
                    hintStyle: const TextStyle(color: DominoTheme.textMuted),
                    filled: true,
                    fillColor: DominoTheme.cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: DominoTheme.neonBlue, width: 1.5),
                    ),
                    suffixIcon: const Icon(Icons.visibility_off_outlined, color: DominoTheme.textMuted),
                  ),
                ),
                const SizedBox(height: 32),
                // Botones
                CustomButton(
                  text: 'Iniciar Sesión',
                  gradientColors: const [DominoTheme.neonRed, Color(0xFFC62828)],
                  onPressed: _navigateToHome,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Crear Cuenta',
                  gradientColors: const [Color(0xFF0D47A1), Color(0xFF1976D2)],
                  onPressed: _navigateToHome,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _navigateToHome,
                  child: const Text(
                    'Entrar como Invitado',
                    style: TextStyle(
                      color: DominoTheme.neonBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
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
