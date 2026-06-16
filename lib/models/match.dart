import 'team.dart';
import 'round.dart';

class MatchModel {
  final String id;
  final Team teamA;
  final Team teamB;
  final List<Round> rounds;
  final int limitPoints;
  final DateTime date;
  final bool isFinished;
  final String? winnerTeamId;

  MatchModel({
    required this.id,
    required this.teamA,
    required this.teamB,
    required this.rounds,
    this.limitPoints = 200,
    required this.date,
    this.isFinished = false,
    this.winnerTeamId,
  });

  int get scoreA => rounds.fold(0, (sum, round) => sum + round.scoreA);
  int get scoreB => rounds.fold(0, (sum, round) => sum + round.scoreB);

  MatchModel copyWith({
    Team? teamA,
    Team? teamB,
    List<Round>? rounds,
    int? limitPoints,
    DateTime? date,
    bool? isFinished,
    String? winnerTeamId,
  }) {
    return MatchModel(
      id: id,
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      rounds: rounds ?? this.rounds,
      limitPoints: limitPoints ?? this.limitPoints,
      date: date ?? this.date,
      isFinished: isFinished ?? this.isFinished,
      winnerTeamId: winnerTeamId ?? this.winnerTeamId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teamA': teamA.toJson(),
      'teamB': teamB.toJson(),
      'rounds': rounds.map((r) => r.toJson()).toList(),
      'limitPoints': limitPoints,
      'date': date.toIso8601String(),
      'isFinished': isFinished,
      'winnerTeamId': winnerTeamId,
    };
  }

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'] ?? '',
      teamA: Team.fromJson(json['teamA'] ?? {}),
      teamB: Team.fromJson(json['teamB'] ?? {}),
      rounds: (json['rounds'] as List? ?? [])
          .map((r) => Round.fromJson(r))
          .toList(),
      limitPoints: json['limitPoints'] ?? 200,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      isFinished: json['isFinished'] ?? false,
      winnerTeamId: json['winnerTeamId'],
    );
  }
}
