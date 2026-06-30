/// Usuario de la aplicación.
class AppUser {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final int ecoPoints;
  final int level;
  final int streakDays;
  final int totalRecycledItems;
  final bool isGuest;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.ecoPoints = 0,
    this.level = 1,
    this.streakDays = 0,
    this.totalRecycledItems = 0,
    this.isGuest = false,
    required this.createdAt,
  });

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    int? ecoPoints,
    int? level,
    int? streakDays,
    int? totalRecycledItems,
    bool? isGuest,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      ecoPoints: ecoPoints ?? this.ecoPoints,
      level: level ?? this.level,
      streakDays: streakDays ?? this.streakDays,
      totalRecycledItems: totalRecycledItems ?? this.totalRecycledItems,
      isGuest: isGuest ?? this.isGuest,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      ecoPoints: (json['ecoPoints'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      totalRecycledItems: (json['totalRecycledItems'] as num?)?.toInt() ?? 0,
      isGuest: json['isGuest'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'ecoPoints': ecoPoints,
      'level': level,
      'streakDays': streakDays,
      'totalRecycledItems': totalRecycledItems,
      'isGuest': isGuest,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
