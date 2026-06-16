import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../models/player.dart';
import '../providers/league_provider.dart';
import '../providers/match_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/glass_card.dart';
import 'create_match_screen.dart';
import 'live_match_screen.dart';
import 'ligas_screen.dart';
import 'ranking_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Retorna la pantalla del marcador activa o el configurador de partida
  Widget _buildMatchTab() {
    final match = Provider.of<MatchProvider>(context);
    if (match.hasActiveMatch) {
      return const LiveMatchScreen();
    } else {
      return const CreateMatchScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final league = Provider.of<LeagueProvider>(context);

    // Lista de vistas asociadas a la barra de navegación
    final List<Widget> pages = [
      _DashboardView(onTabChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      }),
      const LigasScreen(),
      _buildMatchTab(),
      const RankingScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Ligas'),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_outline), activeIcon: Icon(Icons.play_circle), label: 'Partida'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), activeIcon: Icon(Icons.emoji_events), label: 'Ranking'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

// Vista interna del Dashboard (Inicio)
class _DashboardView extends StatelessWidget {
  final ValueChanged<int> onTabChanged;

  const _DashboardView({required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    final league = Provider.of<LeagueProvider>(context);

    // Datos del jugador de ejemplo (Juan Pérez)
    final juan = league.players.firstWhere(
      (p) => p.id == 'juan',
      orElse: () => league.players.isNotEmpty 
          ? league.players.first 
          : Player(id: 'guest', name: 'Invitado', photoUrl: '', wins: 0, losses: 0),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cabecera superior
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Bandera de República Dominicana
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 18,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(3),
                            image: const DecorationImage(
                              image: NetworkImage('https://flagcdn.com/w80/do.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'DOMINÓ 200',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                        ),
                      ],
                    ),
                    // Foto/Avatar de Juan
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: DominoTheme.gold.withOpacity(0.2),
                      child: const Icon(Icons.person, color: DominoTheme.gold, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Mensaje de Bienvenida
                Text(
                  '¡Bienvenido, ${juan.name.split(' ')[0]}!',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),

                // Tarjeta de estadísticas rápidas ("Estadísticas")
                GlassCard(
                  borderColor: Colors.white.withOpacity(0.08),
                  child: Column(
                    children: [
                      const Text(
                        'Estadísticas Personales',
                        style: TextStyle(color: DominoTheme.textMuted, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn('Ganadas', '${juan.wins}', DominoTheme.neonBlue),
                          _buildDivider(),
                          _buildStatColumn('Capicúas', '${juan.capicuas}', DominoTheme.gold),
                          _buildDivider(),
                          _buildStatColumn('P. Corrido', '${juan.pasosCorridos}', DominoTheme.neonRed),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Botón principal: Crear Partida
                CustomButton(
                  text: 'Crear Partida',
                  icon: Icons.add,
                  gradientColors: const [Color(0xFFFFA000), Color(0xFFFFB300)],
                  height: 52,
                  onPressed: () {
                    // Cambia al tab de partida
                    onTabChanged(2);
                  },
                ),
                const SizedBox(height: 20),

                // Grid de accesos rápidos
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.45,
                  children: [
                    _buildGridCard(
                      title: 'Ligas',
                      subtitle: 'Rotación Viernes',
                      icon: Icons.calendar_today,
                      iconColor: DominoTheme.neonBlue,
                      onTap: () => onTabChanged(1),
                    ),
                    _buildGridCard(
                      title: 'Ranking',
                      subtitle: 'Tablas de la Liga',
                      icon: Icons.emoji_events,
                      iconColor: DominoTheme.gold,
                      onTap: () => onTabChanged(3),
                    ),
                    _buildGridCard(
                      title: 'Mi Perfil',
                      subtitle: 'Logros y Nivel',
                      icon: Icons.person,
                      iconColor: DominoTheme.neonRed,
                      onTap: () => onTabChanged(4),
                    ),
                    // Card ilustrativa de dominó
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: DominoTheme.glassDecoration(
                        borderColor: Colors.white.withOpacity(0.04),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildMiniTile(top: 6, bottom: 6),
                              const SizedBox(width: 6),
                              Transform.rotate(
                                angle: 0.3,
                                child: _buildMiniTile(top: 6, bottom: 5),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: DominoTheme.textMuted, fontSize: 12)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 32, color: Colors.white.withOpacity(0.08));
  }

  Widget _buildGridCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: DominoTheme.textMuted, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildMiniTile({required int top, required int bottom}) {
    return Container(
      width: 20,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 3, offset: Offset(1, 2))],
      ),
      child: Column(
        children: [
          Expanded(child: Center(child: Text('$top', style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)))),
          Container(height: 1, color: Colors.grey),
          Expanded(child: Center(child: Text('$bottom', style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)))),
        ],
      ),
    );
  }
}
