import 'package:flutter/material.dart';
import '../models/team.dart';
import '../models/round.dart';
import '../models/match.dart';

class MatchProvider extends ChangeNotifier {
  Team? _teamA;
  Team? _teamB;
  List<Round> _rounds = [];
  int _limitPoints = 200;
  String _currentTurn = 'Equipo A';
  bool _isFinished = false;
  String? _winnerTeamId;
  String _matchId = '';

  Team? get teamA => _teamA;
  Team? get teamB => _teamB;
  List<Round> get rounds => _rounds;
  int get limitPoints => _limitPoints;
  String get currentTurn => _currentTurn;
  bool get isFinished => _isFinished;
  String? get winnerTeamId => _winnerTeamId;
  String get matchId => _matchId;

  int get scoreA => _rounds.fold(0, (sum, round) => sum + round.scoreA);
  int get scoreB => _rounds.fold(0, (sum, round) => sum + round.scoreB);

  bool get hasActiveMatch => _teamA != null && _teamB != null;

  void startMatch(Team a, Team b, int limit) {
    _teamA = a;
    _teamB = b;
    _rounds = [];
    _limitPoints = limit;
    _currentTurn = 'Equipo A';
    _isFinished = false;
    _winnerTeamId = null;
    _matchId = (100 + (DateTime.now().millisecond % 900)).toString(); // Genera ID de partida mock (ej: #153)
    notifyListeners();
  }

  // Agrega puntuación ordinaria de fin de ronda (Dominada)
  void addRoundScore(int points, String team, String winReason, {String details = ''}) {
    if (_isFinished) return;

    final isTeamA = team == 'Equipo A';
    final round = Round(
      scoreA: isTeamA ? points : 0,
      scoreB: isTeamA ? 0 : points,
      winReason: winReason,
      details: details,
    );

    _rounds.add(round);
    _checkWinCondition();
    
    // Cambiar turno automáticamente al equipo contrario
    _currentTurn = isTeamA ? 'Equipo B' : 'Equipo A';
    
    notifyListeners();
  }

  // Permite agregar bonos como Capicúa (+30) o Paso Corrido (+30) en cualquier momento
  void addBonusScore(int bonusPoints, String team, String bonusReason) {
    if (_isFinished) return;

    final isTeamA = team == 'Equipo A';
    final round = Round(
      scoreA: isTeamA ? bonusPoints : 0,
      scoreB: isTeamA ? 0 : bonusPoints,
      winReason: bonusReason,
      details: 'Bono Adicional',
    );

    _rounds.add(round);
    _checkWinCondition();
    notifyListeners();
  }

  void switchTurn() {
    _currentTurn = _currentTurn == 'Equipo A' ? 'Equipo B' : 'Equipo A';
    notifyListeners();
  }

  void undoLastRound() {
    if (_rounds.isNotEmpty) {
      _rounds.removeLast();
      // Volver a verificar victoria
      _isFinished = false;
      _winnerTeamId = null;
      notifyListeners();
    }
  }

  void _checkWinCondition() {
    final currentScoreA = scoreA;
    final currentScoreB = scoreB;

    if (currentScoreA >= _limitPoints) {
      _isFinished = true;
      _winnerTeamId = _teamA!.id;
    } else if (currentScoreB >= _limitPoints) {
      _isFinished = true;
      _winnerTeamId = _teamB!.id;
    }
  }

  MatchModel getFinishedMatch() {
    return MatchModel(
      id: _matchId,
      teamA: _teamA!,
      teamB: _teamB!,
      rounds: List.from(_rounds),
      limitPoints: _limitPoints,
      date: DateTime.now(),
      isFinished: true,
      winnerTeamId: _winnerTeamId,
    );
  }

  void reset() {
    _teamA = null;
    _teamB = null;
    _rounds = [];
    _isFinished = false;
    _winnerTeamId = null;
    _matchId = '';
    notifyListeners();
  }
}
