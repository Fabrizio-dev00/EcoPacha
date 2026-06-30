/// Usuario dentro del ranking semanal.
class LeaderboardUser {
  final String id;
  final String name;
  final String? avatarUrl;
  final int ecoPoints;
  final int position;

  const LeaderboardUser({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.ecoPoints,
    required this.position,
  });

  LeaderboardUser copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    int? ecoPoints,
    int? position,
  }) {
    return LeaderboardUser(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      ecoPoints: ecoPoints ?? this.ecoPoints,
      position: position ?? this.position,
    );
  }

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      ecoPoints: (json['ecoPoints'] as num).toInt(),
      position: (json['position'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'ecoPoints': ecoPoints,
      'position': position,
    };
  }
}
