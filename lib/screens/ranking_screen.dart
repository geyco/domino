import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/league_provider.dart';
import '../widgets/glass_card.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedMonth = 5;
  int _selectedYear = 2026;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final league = Provider.of<LeagueProvider>(context);

    // Ordenar jugadores por victorias descendentemente
    final sortedPlayers = List.from(league.players)
      ..sort((a, b) => b.wins.compareTo(a.wins));

    // Ordenar parejas por victorias descendentemente
    final sortedTeams = List.from(league.teams)
      ..sort((a, b) => b.wins.compareTo(a.wins));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clasificación', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: DominoTheme.gold,
          labelColor: DominoTheme.gold,
          unselectedLabelColor: DominoTheme.textMuted,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'General'),
            Tab(text: 'Equipos'),
            Tab(text: 'Tops'),
          ],
        ),
      ),
      body: league.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Vista Clasificación General (Jugadores)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: ListView.builder(
                    itemCount: sortedPlayers.length,
                    itemBuilder: (context, index) {
                      final player = sortedPlayers[index];
                      final isTopThree = index < 3;
                      final rankColor = index == 0
                          ? DominoTheme.gold
                          : index == 1
                              ? const Color(0xFFBDC3C7)
                              : index == 2
                                  ? const Color(0xFFCD7F32)
                                  : DominoTheme.textMuted;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          borderColor: isTopThree ? rankColor.withOpacity(0.3) : null,
                          child: Row(
                            children: [
                              // Posición
                              Container(
                                width: 30,
                                alignment: Alignment.center,
                                child: isTopThree
                                    ? Icon(Icons.emoji_events, color: rankColor, size: 22)
                                    : Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: DominoTheme.textMuted,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              // Iniciales de foto simulada
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: isTopThree ? rankColor.withOpacity(0.15) : Colors.white10,
                                child: Text(
                                  player.name.substring(0, 1).toUpperCase(),
                                  style: TextStyle(
                                    color: isTopThree ? rankColor : Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              // Nombre del Jugador
                              Expanded(
                                child: Text(
                                  player.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              // Estadísticas Rápidas
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${player.wins} ganadas',
                                    style: TextStyle(
                                      color: isTopThree ? rankColor : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '${player.capicuas} Cap. | ${player.pasosCorridos} P.C.',
                                    style: const TextStyle(
                                      color: DominoTheme.textMuted,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Vista Clasificación por Equipos (Parejas)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: sortedTeams.isEmpty
                      ? Center(
                          child: Text(
                            'No hay parejas registradas todavía.',
                            style: TextStyle(color: Colors.white.withOpacity(0.35)),
                          ),
                        )
                      : ListView.builder(
                          itemCount: sortedTeams.length,
                          itemBuilder: (context, index) {
                            final team = sortedTeams[index];
                            final isTopThree = index < 3;
                            final rankColor = index == 0
                                ? DominoTheme.gold
                                : index == 1
                                    ? const Color(0xFFBDC3C7)
                                    : index == 2
                                        ? const Color(0xFFCD7F32)
                                        : DominoTheme.textMuted;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: GlassCard(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                borderColor: isTopThree ? rankColor.withOpacity(0.3) : null,
                                child: Row(
                                  children: [
                                    // Posición
                                    Container(
                                      width: 30,
                                      alignment: Alignment.center,
                                      child: isTopThree
                                          ? Icon(Icons.stars, color: rankColor, size: 22)
                                          : Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: DominoTheme.textMuted,
                                              ),
                                            ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Icono de Pareja
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.white10,
                                      child: const Icon(Icons.people, color: Colors.white70, size: 18),
                                    ),
                                    const SizedBox(width: 14),
                                    // Nombre de la Pareja
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            team.displayName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Récord: ${team.wins}G - ${team.losses}P',
                                            style: const TextStyle(color: DominoTheme.textMuted, fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Victorias
                                    Text(
                                      '${team.wins} Victorias',
                                      style: TextStyle(
                                        color: isTopThree ? rankColor : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // Vista Tops Mensuales Dinámicos
                _buildTopsTab(league),
              ],
            ),
    );
  }

  // --- Tops y Premios Mensuales ---

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: DominoTheme.gold),
          onPressed: () {
            setState(() {
              if (_selectedMonth == 1) {
                _selectedMonth = 12;
                _selectedYear--;
              } else {
                _selectedMonth--;
              }
            });
          },
        ),
        Text(
          "${_getMonthName(_selectedMonth).toUpperCase()} $_selectedYear",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: DominoTheme.gold),
          onPressed: () {
            setState(() {
              if (_selectedMonth == 12) {
                _selectedMonth = 1;
                _selectedYear++;
              } else {
                _selectedMonth++;
              }
            });
          },
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return '';
  }

  Widget _buildTopsTab(LeagueProvider league) {
    final summary = league.getMonthlySummary(_selectedMonth, _selectedYear);
    final topCapicuas = league.getTopCapicuas(_selectedMonth, _selectedYear);
    final topRatios = league.getTopPlayersByRatio(_selectedMonth, _selectedYear);
    final topJornadas = league.getTopJornadas(_selectedMonth, _selectedYear);

    final bool isEmpty = topCapicuas.isEmpty && topRatios.isEmpty && topJornadas.isEmpty &&
        (summary['player'] == 'Ninguno' || summary['player'] == '');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Selector de Mes
          GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            borderColor: Colors.white.withOpacity(0.05),
            child: _buildMonthSelector(),
          ),
          const SizedBox(height: 20),

          if (isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                children: [
                  Icon(Icons.query_stats, size: 64, color: Colors.white.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  Text(
                    'No hay datos para este mes',
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Registra partidas finalizadas en este mes para ver las estadísticas.',
                    style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else ...[
            // Cuadro de Honor / Resumen del Mes
            Text(
              '🏆 CUADRO DE HONOR - ${_getMonthName(_selectedMonth).toUpperCase()}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: DominoTheme.gold, letterSpacing: 1),
            ),
            const SizedBox(height: 12),
            
            GlassCard(
              borderColor: DominoTheme.gold.withOpacity(0.3),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildAwardRow(
                    icon: Icons.emoji_events,
                    title: 'Jugador del Mes 👑',
                    value: summary['player'] ?? '',
                    color: DominoTheme.gold,
                  ),
                  const Divider(color: Colors.white10, height: 16),
                  _buildAwardRow(
                    icon: Icons.people,
                    title: 'Pareja del Mes 👥',
                    value: summary['pair'] ?? '',
                    color: DominoTheme.neonBlue,
                  ),
                  const Divider(color: Colors.white10, height: 16),
                  _buildAwardRow(
                    icon: Icons.flash_on,
                    title: 'Mayor Impacto (Jornada) 💥',
                    value: summary['impact'] ?? '',
                    color: DominoTheme.neonRed,
                  ),
                  const Divider(color: Colors.white10, height: 16),
                  _buildAwardRow(
                    icon: Icons.psychology,
                    title: 'Jugador más Efectivo 🎯',
                    value: summary['effective'] ?? '',
                    color: DominoTheme.neonGreen,
                  ),
                  const Divider(color: Colors.white10, height: 16),
                  _buildAwardRow(
                    icon: Icons.star,
                    title: 'Capicúas MVP 🦾',
                    value: summary['capicuasMvp'] ?? '',
                    color: DominoTheme.gold,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Top Capicúas
            if (topCapicuas.isNotEmpty) ...[
              const Text(
                '🀄 TOP CAPICÚAS DEL MES',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(height: 10),
              _buildTopCapicuasSection(topCapicuas),
              const SizedBox(height: 24),
            ],

            // Top Ratios (Efectividad)
            if (topRatios.isNotEmpty) ...[
              const Text(
                '🧠 TOP JUGADORES MÁS EFECTIVOS (Ratio)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(height: 10),
              _buildTopRatiosSection(topRatios),
              const SizedBox(height: 24),
            ],

            // Top Jornadas (Mejor desempeño en una jornada)
            if (topJornadas.isNotEmpty) ...[
              const Text(
                '📅 MEJORES PAREJAS EN UNA JORNADA',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(height: 10),
              _buildTopJornadasSection(topJornadas),
              const SizedBox(height: 24),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildAwardRow({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: DominoTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopCapicuasSection(List<dynamic> list) {
    return Column(
      children: list.take(4).map((p) {
        return Card(
          color: DominoTheme.cardColor,
          margin: const EdgeInsets.only(bottom: 6),
          child: ListTile(
            dense: true,
            leading: CircleAvatar(
              radius: 12,
              backgroundColor: DominoTheme.gold.withOpacity(0.15),
              child: Text('${list.indexOf(p) + 1}', style: const TextStyle(color: DominoTheme.gold, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: DominoTheme.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${p.capicuas} Capicúas',
                style: const TextStyle(color: DominoTheme.gold, fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopRatiosSection(List<dynamic> list) {
    return Column(
      children: list.take(5).map((p) {
        return Card(
          color: DominoTheme.cardColor,
          margin: const EdgeInsets.only(bottom: 6),
          child: ListTile(
            dense: true,
            leading: CircleAvatar(
              radius: 12,
              backgroundColor: DominoTheme.neonGreen.withOpacity(0.15),
              child: Text('${list.indexOf(p) + 1}', style: const TextStyle(color: DominoTheme.neonGreen, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text('Récord: ${p.wins}G - ${p.losses}P (${p.totalGames} juegos)', style: const TextStyle(fontSize: 10, color: DominoTheme.textMuted)),
            trailing: Text(
              p.winRate.toStringAsFixed(2),
              style: const TextStyle(color: DominoTheme.neonGreen, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopJornadasSection(List<Map<String, dynamic>> list) {
    return Column(
      children: list.map((j) {
        return Card(
          color: DominoTheme.cardColor,
          margin: const EdgeInsets.only(bottom: 6),
          child: ListTile(
            dense: true,
            leading: CircleAvatar(
              radius: 12,
              backgroundColor: DominoTheme.neonRed.withOpacity(0.15),
              child: Text('${j['rank']}', style: const TextStyle(color: DominoTheme.neonRed, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            title: Text(j['teamName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text(j['date'], style: const TextStyle(fontSize: 10, color: DominoTheme.textMuted)),
            trailing: Text(
              j['record'],
              style: const TextStyle(color: DominoTheme.neonRed, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        );
      }).toList(),
    );
  }
}
