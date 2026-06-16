class Round {
  final int scoreA;
  final int scoreB;
  final String winReason; // 'Dominada', 'Capicúa', 'Paso Corrido', 'Paso Cerrado'
  final String details;

  Round({
    required this.scoreA,
    required this.scoreB,
    required this.winReason,
    this.details = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'scoreA': scoreA,
      'scoreB': scoreB,
      'winReason': winReason,
      'details': details,
    };
  }

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
      scoreA: json['scoreA'] ?? 0,
      scoreB: json['scoreB'] ?? 0,
      winReason: json['winReason'] ?? '',
      details: json['details'] ?? '',
    );
  }
}
