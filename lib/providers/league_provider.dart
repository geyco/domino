import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart';
import '../models/team.dart';
import '../models/match.dart';
import '../models/round.dart';

class LeagueProvider extends ChangeNotifier {
  List<Player> _players = [];
  List<Team> _teams = [];
  List<MatchModel> _matchHistory = [];
  bool _isLoading = true;

  List<Player> get players => _players;
  List<Team> get teams => _teams;
  List<MatchModel> get matchHistory => _matchHistory;
  bool get isLoading => _isLoading;

  LeagueProvider() {
    loadData();
  }

  // Carga los datos almacenados localmente o genera datos mock de ejemplo
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      
      final playersJson = prefs.getString('players');
      final teamsJson = prefs.getString('teams');
      final historyJson = prefs.getString('history');

      if (playersJson != null && teamsJson != null) {
        final List decodedPlayers = jsonDecode(playersJson);
        _players = decodedPlayers.map((p) => Player.fromJson(p)).toList();

        final List decodedTeams = jsonDecode(teamsJson);
        _teams = decodedTeams.map((t) => Team.fromJson(t)).toList();

        if (historyJson != null) {
          final List decodedHistory = jsonDecode(historyJson);
          _matchHistory = decodedHistory.map((m) => MatchModel.fromJson(m)).toList();
        }
      } else {
        // Inicializar datos mock si no hay almacenamiento previo (para que la app no empiece vacía)
        _initMockData();
      }
    } catch (e) {
      _initMockData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Inicializa datos de prueba atractivos para la liga real (Especial Mayo)
  void _initMockData() {
    _players = [
      Player(id: 'juan', name: 'Juan Pérez', photoUrl: 'juan.png', wins: 12, losses: 4, capicuas: 8, pasosCorridos: 5),
      Player(id: 'javier', name: 'Javier Abreu', photoUrl: 'javier.png', wins: 49, losses: 31, capicuas: 13), // 80 juegos
      Player(id: 'moises', name: 'Moises Mena', photoUrl: 'moises.png', wins: 46, losses: 33, capicuas: 10), // 79 juegos
      Player(id: 'pablo', name: 'Pablo', photoUrl: 'pablo.png', wins: 44, losses: 31, capicuas: 9), // 75 juegos
      Player(id: 'sam', name: 'Sam', photoUrl: 'sam.png', wins: 42, losses: 28, capicuas: 14), // 70 juegos
      Player(id: 'joaquin', name: 'Jose Joaquin Sanchez', photoUrl: 'joaquin.png', wins: 41, losses: 27, capicuas: 8), // 68 juegos
      Player(id: 'rene', name: 'Rene', photoUrl: 'rene.png', wins: 39, losses: 30, capicuas: 15), // 69 juegos
      Player(id: 'atiles', name: 'Atiles', photoUrl: 'atiles.png', wins: 37, losses: 23, capicuas: 13), // 60 juegos
      Player(id: 'massiel', name: 'Massiel', photoUrl: 'massiel.png', wins: 34, losses: 24, capicuas: 6), // 58 juegos
      Player(id: 'jayden', name: 'Mr. Jayden Sanz!', photoUrl: 'jayden.png', wins: 33, losses: 22, capicuas: 7), // 55 juegos
      Player(id: 'chalia', name: 'Chalia', photoUrl: 'chalia.png', wins: 32, losses: 25, capicuas: 5), // 57 juegos
      Player(id: 'luini', name: 'Luini', photoUrl: 'luini.png', wins: 25, losses: 5, capicuas: 4), // 30 juegos (0.83)
      Player(id: 'jc', name: 'JC', photoUrl: 'jc.png', wins: 31, losses: 12, capicuas: 8), // 43 juegos (0.72)
      Player(id: 'aileen', name: 'Aileen', photoUrl: 'aileen.png', wins: 22, losses: 9, capicuas: 6), // 31 juegos (0.71)
      Player(id: 'santana', name: 'Luis Santana', photoUrl: 'santana.png', wins: 27, losses: 12, capicuas: 7), // 39 juegos (0.69)
      Player(id: 'raymond', name: 'Raymond', photoUrl: 'raymond.png', wins: 28, losses: 13, capicuas: 8), // 41 juegos (0.68)
      Player(id: 'joan', name: 'Joan', photoUrl: 'joan.png', wins: 12, losses: 8, capicuas: 3),
      Player(id: 'frankys', name: 'Frankys A. Monegro', photoUrl: 'frankys.png', wins: 20, losses: 10, capicuas: 4),
      Player(id: 'mckinney', name: 'Mckinney', photoUrl: 'mckinney.png', wins: 15, losses: 8, capicuas: 2),
    ];

    // Parejas iniciales
    _teams = [
      Team(
        id: 'joaquin_moises',
        player1: _players.firstWhere((p) => p.id == 'joaquin'),
        player2: _players.firstWhere((p) => p.id == 'moises'),
        wins: 25,
        losses: 12,
      ),
      Team(
        id: 'moises_javier',
        player1: _players.firstWhere((p) => p.id == 'moises'),
        player2: _players.firstWhere((p) => p.id == 'javier'),
        wins: 18,
        losses: 12,
      ),
      Team(
        id: 'pablo_atiles',
        player1: _players.firstWhere((p) => p.id == 'pablo'),
        player2: _players.firstWhere((p) => p.id == 'atiles'),
        wins: 11,
        losses: 6,
      ),
      Team(
        id: 'frankys_jayden',
        player1: _players.firstWhere((p) => p.id == 'frankys'),
        player2: _players.firstWhere((p) => p.id == 'jayden'),
        wins: 12,
        losses: 3,
      ),
      Team(
        id: 'luini_mckinney',
        player1: _players.firstWhere((p) => p.id == 'luini'),
        player2: _players.firstWhere((p) => p.id == 'mckinney'),
        wins: 9,
        losses: 1,
      ),
      Team(
        id: 'sam_joan',
        player1: _players.firstWhere((p) => p.id == 'sam'),
        player2: _players.firstWhere((p) => p.id == 'joan'),
        wins: 7,
        losses: 1,
      ),
    ];

    _matchHistory = [
      MatchModel(
        id: '152',
        teamA: _teams[0], // Joaquin y Moises
        teamB: _teams[1], // Moises y Javier
        rounds: [],
        limitPoints: 200,
        date: DateTime.now().subtract(const Duration(days: 1)),
        isFinished: true,
        winnerTeamId: 'joaquin_moises',
      )
    ];

    saveData();
  }

  Future<void> saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('players', jsonEncode(_players.map((p) => p.toJson()).toList()));
      await prefs.setString('teams', jsonEncode(_teams.map((t) => t.toJson()).toList()));
      await prefs.setString('history', jsonEncode(_matchHistory.map((m) => m.toJson()).toList()));
    } catch (_) {
      // Ignorar fallos de persistencia en web/test
    }
  }

  // Agrega o retorna una pareja para dos jugadores
  Team getOrCreateTeam(Player p1, Player p2) {
    // Ordenar IDs para consistencia en parejas
    final ids = [p1.id, p2.id]..sort();
    final teamId = '${ids[0]}_${ids[1]}';

    final existingIndex = _teams.indexWhere((t) => t.id == teamId);
    if (existingIndex != -1) {
      return _teams[existingIndex];
    }

    final newTeam = Team(
      id: teamId,
      player1: p1.id == ids[0] ? p1 : p2,
      player2: p1.id == ids[0] ? p2 : p1,
      wins: 0,
      losses: 0,
    );
    _teams.add(newTeam);
    saveData();
    notifyListeners();
    return newTeam;
  }

  // Agrega un jugador nuevo a la liga
  void addPlayer(String name) {
    final newId = name.toLowerCase().replaceAll(' ', '_') + '_${DateTime.now().millisecond}';
    final newPlayer = Player(
      id: newId,
      name: name,
      photoUrl: 'default.png',
    );
    _players.add(newPlayer);
    saveData();
    notifyListeners();
  }

  // Registra el resultado de una partida y actualiza estadísticas globales
  void recordFinishedMatch(MatchModel finishedMatch) {
    _matchHistory.insert(0, finishedMatch);

    final String winnerId = finishedMatch.winnerTeamId!;
    final bool isTeamAWinner = finishedMatch.teamA.id == winnerId;
    
    final winningTeam = isTeamAWinner ? finishedMatch.teamA : finishedMatch.teamB;
    final losingTeam = isTeamAWinner ? finishedMatch.teamB : finishedMatch.teamA;

    // 1. Actualizar estadísticas de equipos en la lista principal
    _updateTeamStats(winningTeam.id, isWin: true);
    _updateTeamStats(losingTeam.id, isWin: false);

    // 2. Actualizar estadísticas individuales de jugadores en la lista principal
    // Para los ganadores
    _updatePlayerStats(winningTeam.player1.id, isWin: true, matchRounds: finishedMatch.rounds, isTeamA: isTeamAWinner);
    _updatePlayerStats(winningTeam.player2.id, isWin: true, matchRounds: finishedMatch.rounds, isTeamA: isTeamAWinner);
    // Para los perdedores
    _updatePlayerStats(losingTeam.player1.id, isWin: false, matchRounds: finishedMatch.rounds, isTeamA: !isTeamAWinner);
    _updatePlayerStats(losingTeam.player2.id, isWin: false, matchRounds: finishedMatch.rounds, isTeamA: !isTeamAWinner);

    saveData();
    notifyListeners();
  }

  void _updateTeamStats(String teamId, {required bool isWin}) {
    final idx = _teams.indexWhere((t) => t.id == teamId);
    if (idx != -1) {
      final t = _teams[idx];
      _teams[idx] = t.copyWith(
        wins: isWin ? t.wins + 1 : t.wins,
        losses: isWin ? t.losses : t.losses + 1,
      );
    }
  }

  void _updatePlayerStats(
    String playerId, {
    required bool isWin,
    required List<Round> matchRounds,
    required bool isTeamA,
  }) {
    final idx = _players.indexWhere((p) => p.id == playerId);
    if (idx != -1) {
      final p = _players[idx];
      
      // Contar capicúas y pasos corridos que sucedieron en esta partida
      int capicuasSum = 0;
      int pasosCorridosSum = 0;

      for (var r in matchRounds) {
        final earnedA = r.scoreA > 0;
        final earnedB = r.scoreB > 0;
        
        if ((isTeamA && earnedA) || (!isTeamA && earnedB)) {
          if (r.winReason == 'Capicúa') {
            capicuasSum++;
          } else if (r.winReason == 'Paso Corrido') {
            pasosCorridosSum++;
          }
        }
      }

      _players[idx] = p.copyWith(
        wins: isWin ? p.wins + 1 : p.wins,
        losses: isWin ? p.losses : p.losses + 1,
        capicuas: p.capicuas + capicuasSum,
        pasosCorridos: p.pasosCorridos + pasosCorridosSum,
      );
    }
  }

  // --- Tops y Premios de Liga ---

  List<Player> _getPlayersWithStatsForMonth(int month, int year) {
    if (month == 5 && year == 2026) {
      // Para Mayo 2026, retornamos los jugadores con sus estadísticas de Mayo 2026
      return [
        Player(id: 'juan', name: 'Juan Pérez', photoUrl: 'juan.png', wins: 12, losses: 4, capicuas: 8, pasosCorridos: 5),
        Player(id: 'javier', name: 'Javier Abreu', photoUrl: 'javier.png', wins: 49, losses: 31, capicuas: 13),
        Player(id: 'moises', name: 'Moises Mena', photoUrl: 'moises.png', wins: 46, losses: 33, capicuas: 10),
        Player(id: 'pablo', name: 'Pablo', photoUrl: 'pablo.png', wins: 44, losses: 31, capicuas: 9),
        Player(id: 'sam', name: 'Sam', photoUrl: 'sam.png', wins: 42, losses: 28, capicuas: 14),
        Player(id: 'joaquin', name: 'Jose Joaquin Sanchez', photoUrl: 'joaquin.png', wins: 41, losses: 27, capicuas: 8),
        Player(id: 'rene', name: 'Rene', photoUrl: 'rene.png', wins: 39, losses: 30, capicuas: 15),
        Player(id: 'atiles', name: 'Atiles', photoUrl: 'atiles.png', wins: 37, losses: 23, capicuas: 13),
        Player(id: 'massiel', name: 'Massiel', photoUrl: 'massiel.png', wins: 34, losses: 24, capicuas: 6),
        Player(id: 'jayden', name: 'Mr. Jayden Sanz!', photoUrl: 'jayden.png', wins: 33, losses: 22, capicuas: 7),
        Player(id: 'chalia', name: 'Chalia', photoUrl: 'chalia.png', wins: 32, losses: 25, capicuas: 5),
        Player(id: 'luini', name: 'Luini', photoUrl: 'luini.png', wins: 25, losses: 5, capicuas: 4),
        Player(id: 'jc', name: 'JC', photoUrl: 'jc.png', wins: 31, losses: 12, capicuas: 8),
        Player(id: 'aileen', name: 'Aileen', photoUrl: 'aileen.png', wins: 22, losses: 9, capicuas: 6),
        Player(id: 'santana', name: 'Luis Santana', photoUrl: 'santana.png', wins: 27, losses: 12, capicuas: 7),
        Player(id: 'raymond', name: 'Raymond', photoUrl: 'raymond.png', wins: 28, losses: 13, capicuas: 8),
        Player(id: 'joan', name: 'Joan', photoUrl: 'joan.png', wins: 12, losses: 8, capicuas: 3),
        Player(id: 'frankys', name: 'Frankys A. Monegro', photoUrl: 'frankys.png', wins: 20, losses: 10, capicuas: 4),
        Player(id: 'mckinney', name: 'Mckinney', photoUrl: 'mckinney.png', wins: 15, losses: 8, capicuas: 2),
      ];
    }

    // Filtrar partidas del mes/año seleccionado
    final monthlyMatches = _matchHistory.where((m) =>
        m.isFinished && m.date.month == month && m.date.year == year).toList();

    // Crear mapa de estadísticas por ID de jugador
    final Map<String, Map<String, int>> playerStats = {};
    for (var p in _players) {
      playerStats[p.id] = {
        'wins': 0,
        'losses': 0,
        'capicuas': 0,
        'pasosCorridos': 0,
      };
    }

    for (var match in monthlyMatches) {
      final winnerId = match.winnerTeamId;
      if (winnerId == null) continue;

      final teamAId = match.teamA.id;
      final teamBId = match.teamB.id;

      final isTeamAWinner = teamAId == winnerId;
      final winningTeam = isTeamAWinner ? match.teamA : match.teamB;
      final losingTeam = isTeamAWinner ? match.teamB : match.teamA;

      // Actualizar victorias/derrotas de jugadores
      for (var pId in [winningTeam.player1.id, winningTeam.player2.id]) {
        playerStats.putIfAbsent(pId, () => {'wins': 0, 'losses': 0, 'capicuas': 0, 'pasosCorridos': 0});
        playerStats[pId]!['wins'] = (playerStats[pId]!['wins'] ?? 0) + 1;
      }
      for (var pId in [losingTeam.player1.id, losingTeam.player2.id]) {
        playerStats.putIfAbsent(pId, () => {'wins': 0, 'losses': 0, 'capicuas': 0, 'pasosCorridos': 0});
        playerStats[pId]!['losses'] = (playerStats[pId]!['losses'] ?? 0) + 1;
      }

      // Contar capicuas y pasos corridos en rounds
      for (var r in match.rounds) {
        final earnedA = r.scoreA > 0;
        final earnedB = r.scoreB > 0;

        if (r.winReason == 'Capicúa') {
          final winningRoundTeam = earnedA ? match.teamA : match.teamB;
          for (var pId in [winningRoundTeam.player1.id, winningRoundTeam.player2.id]) {
            playerStats.putIfAbsent(pId, () => {'wins': 0, 'losses': 0, 'capicuas': 0, 'pasosCorridos': 0});
            playerStats[pId]!['capicuas'] = (playerStats[pId]!['capicuas'] ?? 0) + 1;
          }
        } else if (r.winReason == 'Paso Corrido') {
          final winningRoundTeam = earnedA ? match.teamA : match.teamB;
          for (var pId in [winningRoundTeam.player1.id, winningRoundTeam.player2.id]) {
            playerStats.putIfAbsent(pId, () => {'wins': 0, 'losses': 0, 'capicuas': 0, 'pasosCorridos': 0});
            playerStats[pId]!['pasosCorridos'] = (playerStats[pId]!['pasosCorridos'] ?? 0) + 1;
          }
        }
      }
    }

    // Retornar lista de jugadores con estadísticas de este mes
    return _players.map((p) {
      final stats = playerStats[p.id] ?? {'wins': 0, 'losses': 0, 'capicuas': 0, 'pasosCorridos': 0};
      return p.copyWith(
        wins: stats['wins'] ?? 0,
        losses: stats['losses'] ?? 0,
        capicuas: stats['capicuas'] ?? 0,
        pasosCorridos: stats['pasosCorridos'] ?? 0,
      );
    }).toList();
  }

  List<Team> _getTeamsWithStatsForMonth(int month, int year) {
    if (month == 5 && year == 2026) {
      // Para Mayo 2026, retornamos las parejas iniciales estáticas
      return [
        Team(
          id: 'joaquin_moises',
          player1: _players.firstWhere((p) => p.id == 'joaquin'),
          player2: _players.firstWhere((p) => p.id == 'moises'),
          wins: 25,
          losses: 12,
        ),
        Team(
          id: 'moises_javier',
          player1: _players.firstWhere((p) => p.id == 'moises'),
          player2: _players.firstWhere((p) => p.id == 'javier'),
          wins: 18,
          losses: 12,
        ),
        Team(
          id: 'pablo_atiles',
          player1: _players.firstWhere((p) => p.id == 'pablo'),
          player2: _players.firstWhere((p) => p.id == 'atiles'),
          wins: 11,
          losses: 6,
        ),
        Team(
          id: 'frankys_jayden',
          player1: _players.firstWhere((p) => p.id == 'frankys'),
          player2: _players.firstWhere((p) => p.id == 'jayden'),
          wins: 12,
          losses: 3,
        ),
        Team(
          id: 'luini_mckinney',
          player1: _players.firstWhere((p) => p.id == 'luini'),
          player2: _players.firstWhere((p) => p.id == 'mckinney'),
          wins: 9,
          losses: 1,
        ),
        Team(
          id: 'sam_joan',
          player1: _players.firstWhere((p) => p.id == 'sam'),
          player2: _players.firstWhere((p) => p.id == 'joan'),
          wins: 7,
          losses: 1,
        ),
      ];
    }

    // Filtrar partidas del mes/año seleccionado
    final monthlyMatches = _matchHistory.where((m) =>
        m.isFinished && m.date.month == month && m.date.year == year).toList();

    // Agrupar estadísticas por ID de pareja
    final Map<String, Map<String, int>> teamStats = {};
    for (var t in _teams) {
      teamStats[t.id] = {
        'wins': 0,
        'losses': 0,
      };
    }

    for (var match in monthlyMatches) {
      final winnerId = match.winnerTeamId;
      if (winnerId == null) continue;

      final teamAId = match.teamA.id;
      final teamBId = match.teamB.id;

      final isTeamAWinner = teamAId == winnerId;
      final winningTeam = isTeamAWinner ? match.teamA : match.teamB;
      final losingTeam = isTeamAWinner ? match.teamB : match.teamA;

      // Asegurar que existan en el mapa
      teamStats.putIfAbsent(winningTeam.id, () => {'wins': 0, 'losses': 0});
      teamStats.putIfAbsent(losingTeam.id, () => {'wins': 0, 'losses': 0});

      teamStats[winningTeam.id]!['wins'] = (teamStats[winningTeam.id]!['wins'] ?? 0) + 1;
      teamStats[losingTeam.id]!['losses'] = (teamStats[losingTeam.id]!['losses'] ?? 0) + 1;
    }

    // Filtrar para mostrar solo parejas activas en ese mes
    final List<Team> activeTeams = [];
    for (var t in _teams) {
      final stats = teamStats[t.id];
      if (stats != null && (stats['wins']! > 0 || stats['losses']! > 0)) {
        activeTeams.add(t.copyWith(
          wins: stats['wins'] ?? 0,
          losses: stats['losses'] ?? 0,
        ));
      }
    }

    // También agregar parejas dinámicas creadas que no estaban en la lista _teams inicial
    for (var match in monthlyMatches) {
      final teamA = match.teamA;
      final teamB = match.teamB;
      for (var team in [teamA, teamB]) {
        if (!activeTeams.any((t) => t.id == team.id)) {
          final stats = teamStats[team.id] ?? {'wins': 0, 'losses': 0};
          activeTeams.add(team.copyWith(
            wins: stats['wins'] ?? 0,
            losses: stats['losses'] ?? 0,
          ));
        }
      }
    }

    return activeTeams;
  }

  List<Player> getTopCapicuas(int month, int year) {
    final monthlyPlayers = _getPlayersWithStatsForMonth(month, year);
    final list = List<Player>.from(monthlyPlayers)
      ..sort((a, b) => b.capicuas.compareTo(a.capicuas));
    return list.where((p) => p.capicuas > 0).toList();
  }

  List<Player> getTopPlayersByRatio(int month, int year) {
    final monthlyPlayers = _getPlayersWithStatsForMonth(month, year);
    // Para el mes de mock se exige mínimo 15, para otros meses basta con 1 juego
    final minGames = (month == 5 && year == 2026) ? 15 : 1;
    final list = monthlyPlayers.where((p) => p.totalGames >= minGames).toList();
    list.sort((a, b) => b.winRate.compareTo(a.winRate));
    return list;
  }

  List<Map<String, dynamic>> getTopJornadas(int month, int year) {
    if (month == 5 && year == 2026) {
      return [
        {
          'teamName': 'Frankys y Jayden',
          'record': '12 victorias - 3 derrotas',
          'date': 'Jornada 29 de Mayo',
          'rank': 1,
        },
        {
          'teamName': 'Luini y Mckinney',
          'record': '9 victorias - 1 derrota',
          'date': '16 de Mayo',
          'rank': 2,
        },
        {
          'teamName': 'Sam y Joan',
          'record': '7 victorias - 1 derrota',
          'date': '9 de Mayo',
          'rank': 3,
        },
      ];
    }

    final monthlyMatches = _matchHistory.where((m) =>
        m.isFinished && m.date.month == month && m.date.year == year).toList();

    if (monthlyMatches.isEmpty) {
      return [];
    }

    // Agrupar por fecha de jornada (sin hora) y ID de equipo
    // Mapa: "yyyy-MM-dd_teamId" -> {'wins': X, 'losses': Y, 'team': Team, 'date': DateTime}
    final Map<String, Map<String, dynamic>> group = {};

    for (var match in monthlyMatches) {
      final dateStr = "${match.date.year}-${match.date.month.toString().padLeft(2, '0')}-${match.date.day.toString().padLeft(2, '0')}";
      final winnerId = match.winnerTeamId;
      if (winnerId == null) continue;

      for (var team in [match.teamA, match.teamB]) {
        final key = "${dateStr}_${team.id}";
        group.putIfAbsent(key, () => {
          'wins': 0,
          'losses': 0,
          'team': team,
          'date': match.date,
        });

        final isWin = team.id == winnerId;
        if (isWin) {
          group[key]!['wins'] = group[key]!['wins'] + 1;
        } else {
          group[key]!['losses'] = group[key]!['losses'] + 1;
        }
      }
    }

    final list = group.values.toList();
    // Ordenar por victorias descendente, luego por derrotas ascendente
    list.sort((a, b) {
      final winsCompare = b['wins'].compareTo(a['wins']);
      if (winsCompare != 0) return winsCompare;
      return a['losses'].compareTo(b['losses']);
    });

    final List<Map<String, dynamic>> result = [];
    int rank = 1;
    for (var item in list.take(3)) {
      final team = item['team'] as Team;
      final date = item['date'] as DateTime;
      final wins = item['wins'] as int;
      final losses = item['losses'] as int;

      if (wins == 0) continue;

      final recordStr = "$wins victoria${wins == 1 ? '' : 's'} - $losses derrota${losses == 1 ? '' : 's'}";
      final dateStr = "${date.day} de ${_getMonthName(date.month)}";

      result.add({
        'teamName': team.displayName,
        'record': recordStr,
        'date': dateStr,
        'rank': rank++,
      });
    }

    return result;
  }

  Map<String, String> getMonthlySummary(int month, int year) {
    if (month == 5 && year == 2026) {
      return {
        'player': 'Javier Abreu',
        'pair': 'Moises Mena / Jose Joaquin Sanchez',
        'impact': 'Frankys A. Monegro / Mr. Jayden Sanz! (12-3)',
        'effective': 'Luis Santana',
        'capicuasMvp': 'El Presi (Rene)',
      };
    }

    final monthlyPlayers = _getPlayersWithStatsForMonth(month, year);
    final monthlyTeams = _getTeamsWithStatsForMonth(month, year);
    final topJornadas = getTopJornadas(month, year);

    String player = 'Ninguno';
    if (monthlyPlayers.isNotEmpty) {
      final sortedByWins = List<Player>.from(monthlyPlayers)
        ..sort((a, b) => b.wins.compareTo(a.wins));
      if (sortedByWins.first.wins > 0) {
        player = "${sortedByWins.first.name} (${sortedByWins.first.wins} victorias)";
      }
    }

    String pair = 'Ninguna';
    if (monthlyTeams.isNotEmpty) {
      final sortedTeams = List<Team>.from(monthlyTeams)
        ..sort((a, b) => b.wins.compareTo(a.wins));
      if (sortedTeams.first.wins > 0) {
        pair = "${sortedTeams.first.displayName} (${sortedTeams.first.wins} victorias)";
      }
    }

    String impact = 'Ninguno';
    if (topJornadas.isNotEmpty) {
      impact = "${topJornadas.first['teamName']} (${topJornadas.first['record']})";
    }

    String effective = 'Ninguno';
    final activePlayers = monthlyPlayers.where((p) => p.totalGames > 0).toList();
    if (activePlayers.isNotEmpty) {
      activePlayers.sort((a, b) => b.winRate.compareTo(a.winRate));
      effective = "${activePlayers.first.name} (${(activePlayers.first.winRate * 100).toStringAsFixed(0)}% efectividad)";
    }

    String capicuasMvp = 'Ninguno';
    final capicuasPlayers = monthlyPlayers.where((p) => p.capicuas > 0).toList();
    if (capicuasPlayers.isNotEmpty) {
      capicuasPlayers.sort((a, b) => b.capicuas.compareTo(a.capicuas));
      capicuasMvp = "${capicuasPlayers.first.name} (${capicuasPlayers.first.capicuas} Capicúas)";
    }

    return {
      'player': player,
      'pair': pair,
      'impact': impact,
      'effective': effective,
      'capicuasMvp': capicuasMvp,
    };
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
}
