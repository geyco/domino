import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/league_provider.dart';
import '../providers/match_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/glass_card.dart';
import 'scanner_screen.dart';

class LiveMatchScreen extends StatelessWidget {
  const LiveMatchScreen({super.key});

  // Diálogo de celebración al ganar la partida
  void _showWinnerDialog(BuildContext context, String winnerName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: GlassCard(
              borderColor: DominoTheme.gold,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: DominoTheme.gold,
                    size: 80,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¡PARTIDA COMPLETADA!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: DominoTheme.gold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ganadores:',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    winnerName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'Volver al Inicio',
                    gradientColors: const [DominoTheme.gold, Color(0xFFE65100)],
                    onPressed: () {
                      // Guardar en la historia de la liga
                      final matchProvider = Provider.of<MatchProvider>(context, listen: false);
                      final leagueProvider = Provider.of<LeagueProvider>(context, listen: false);
                      
                      final finishedMatch = matchProvider.getFinishedMatch();
                      leagueProvider.recordFinishedMatch(finishedMatch);
                      
                      matchProvider.reset();
                      
                      // Volver al Home principal
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Navega al escáner y procesa el puntaje
  Future<void> _openScanner(BuildContext context, MatchProvider match) async {
    final int? points = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (context) => const ScannerScreen()),
    );

    if (points != null && points > 0) {
      match.addRoundScore(points, match.currentTurn, 'Dominada', details: 'Fichas restantes');
      _checkMatchEnd(context, match);
    }
  }

  void _checkMatchEnd(BuildContext context, MatchProvider match) {
    if (match.isFinished) {
      final winnerName = match.winnerTeamId == match.teamA!.id
          ? match.teamA!.displayName
          : match.teamB!.displayName;
      _showWinnerDialog(context, winnerName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final match = Provider.of<MatchProvider>(context);

    if (!match.hasActiveMatch) {
      return const Scaffold(
        body: Center(
          child: Text('No hay partida activa en este momento.'),
        ),
      );
    }

    final scoreA = match.scoreA;
    final scoreB = match.scoreB;
    final limit = match.limitPoints;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Partida en Vivo', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Botón Deshacer última jugada (Crucial para corregir errores)
          if (match.rounds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.undo, color: DominoTheme.textMuted),
              tooltip: 'Deshacer última anotación',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: DominoTheme.cardColor,
                    title: const Text('¿Deshacer jugada?'),
                    content: const Text('Se eliminará la última anotación del marcador.'),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text('Deshacer', style: TextStyle(color: DominoTheme.neonRed)),
                        onPressed: () {
                          match.undoLastRound();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cabecera ID Partida
              Center(
                child: Text(
                  'PARTIDA #${match.matchId}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: DominoTheme.gold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Marcador Principal (A vs B)
              Row(
                children: [
                  // Equipo A Card
                  Expanded(
                    child: GlassCard(
                      borderColor: DominoTheme.neonBlue.withOpacity(match.currentTurn == 'Equipo A' ? 0.8 : 0.1),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            match.teamA!.player1.name.split(' ')[0],
                            style: const TextStyle(fontSize: 12, color: DominoTheme.textMuted),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            match.teamA!.player2.name.split(' ')[0],
                            style: const TextStyle(fontSize: 12, color: DominoTheme.textMuted),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '$scoreA',
                            style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: DominoTheme.neonBlue),
                          ),
                          const SizedBox(height: 6),
                          // Puntos restantes
                          Text(
                            'Meta: $limit',
                            style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.4)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('VS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: DominoTheme.textMuted)),
                  ),
                  // Equipo B Card
                  Expanded(
                    child: GlassCard(
                      borderColor: DominoTheme.neonRed.withOpacity(match.currentTurn == 'Equipo B' ? 0.8 : 0.1),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            match.teamB!.player1.name.split(' ')[0],
                            style: const TextStyle(fontSize: 12, color: DominoTheme.textMuted),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            match.teamB!.player2.name.split(' ')[0],
                            style: const TextStyle(fontSize: 12, color: DominoTheme.textMuted),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '$scoreB',
                            style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: DominoTheme.neonRed),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Meta: $limit',
                            style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.4)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Turno actual interactivo
              GestureDetector(
                onTap: () => match.switchTurn(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: DominoTheme.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.swap_horiz, size: 16, color: DominoTheme.textMuted),
                      const SizedBox(width: 8),
                      Text(
                        'Turno para Anotar: ',
                        style: const TextStyle(color: DominoTheme.textMuted, fontSize: 14),
                      ),
                      Text(
                        match.currentTurn == 'Equipo A' ? 'EQUIPO A' : 'EQUIPO B',
                        style: TextStyle(
                          color: match.currentTurn == 'Equipo A' ? DominoTheme.neonBlue : DominoTheme.neonRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Historial de Rondas en esta Partida
              const Text('Rondas de Partida', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 8),
              Expanded(
                child: match.rounds.isEmpty
                    ? Center(
                        child: Text(
                          'Aún no hay puntos registrados.\n¡Usa las acciones de abajo para sumar!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 13, height: 1.5),
                        ),
                      )
                    : ListView.builder(
                        itemCount: match.rounds.length,
                        itemBuilder: (context, index) {
                          final round = match.rounds[index];
                          final isScoreA = round.scoreA > 0;
                          final points = isScoreA ? round.scoreA : round.scoreB;
                          final teamName = isScoreA ? 'Equipo A' : 'Equipo B';
                          final teamColor = isScoreA ? DominoTheme.neonBlue : DominoTheme.neonRed;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: DominoTheme.cardColor.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white.withOpacity(0.03)),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: teamColor.withOpacity(0.15),
                                    child: Text(
                                      isScoreA ? 'A' : 'B',
                                      style: TextStyle(color: teamColor, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          round.winReason,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                        if (round.details.isNotEmpty)
                                          Text(
                                            round.details,
                                            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '+$points pts',
                                    style: TextStyle(color: teamColor, fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 12),

              // Botones de Acciones del Anotador
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      // Registrar Puntos Ordinarios (Abre escáner/cámara)
                      Expanded(
                        child: CustomButton(
                          text: 'Registrar Puntos',
                          icon: Icons.add_circle_outline,
                          gradientColors: const [Color(0xFFFFA000), Color(0xFFFFB300)],
                          onPressed: () => _openScanner(context, match),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Bono de Capicúa
                      Expanded(
                        child: CustomButton(
                          text: 'Capicúa +30',
                          icon: Icons.star_border,
                          height: 44,
                          gradientColors: const [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                          onPressed: () {
                            match.addBonusScore(30, match.currentTurn, 'Capicúa');
                            _checkMatchEnd(context, match);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Bono de Paso Corrido
                      Expanded(
                        child: CustomButton(
                          text: 'Paso Corrido +30',
                          icon: Icons.flash_on,
                          height: 44,
                          gradientColors: const [Color(0xFF00838F), Color(0xFF00ACC1)],
                          onPressed: () {
                            match.addBonusScore(30, match.currentTurn, 'Paso Corrido');
                            _checkMatchEnd(context, match);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Botón Cerrar Dominada (Cierre de mano)
                  CustomButton(
                    text: 'Cerrar Dominada / Trancado',
                    icon: Icons.lock_outline,
                    height: 44,
                    color: DominoTheme.green,
                    onPressed: () => _openScanner(context, match),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
