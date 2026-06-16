import 'player.dart';

class Team {
  final String id;
  final Player player1;
  final Player player2;
  final int wins;
  final int losses;

  Team({
    required this.id,
    required this.player1,
    required this.player2,
    this.wins = 0,
    this.losses = 0,
  });

  String get displayName => "${player1.name} y ${player2.name}";

  Team copyWith({
    Player? player1,
    Player? player2,
    int? wins,
    int? losses,
  }) {
    return Team(
      id: id,
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player1': player1.toJson(),
      'player2': player2.toJson(),
      'wins': wins,
      'losses': losses,
    };
  }

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? '',
      player1: Player.fromJson(json['player1'] ?? {}),
      player2: Player.fromJson(json['player2'] ?? {}),
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
    );
  }
}
