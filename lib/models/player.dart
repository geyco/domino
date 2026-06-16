class Player {
  final String id;
  final String name;
  final String photoUrl;
  final int wins;
  final int losses;
  final int capicuas;
  final int pasosCorridos;

  int get totalGames => wins + losses;
  double get winRate => totalGames > 0 ? wins / totalGames : 0.0;

  Player({
    required this.id,
    required this.name,
    required this.photoUrl,
    this.wins = 0,
    this.losses = 0,
    this.capicuas = 0,
    this.pasosCorridos = 0,
  });

  Player copyWith({
    String? name,
    String? photoUrl,
    int? wins,
    int? losses,
    int? capicuas,
    int? pasosCorridos,
  }) {
    return Player(
      id: id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      capicuas: capicuas ?? this.capicuas,
      pasosCorridos: pasosCorridos ?? this.pasosCorridos,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'wins': wins,
      'losses': losses,
      'capicuas': capicuas,
      'pasosCorridos': pasosCorridos,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
      capicuas: json['capicuas'] ?? 0,
      pasosCorridos: json['pasosCorridos'] ?? 0,
    );
  }
}
