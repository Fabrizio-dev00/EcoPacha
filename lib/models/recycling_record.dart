import 'recycling_result.dart';

/// Registro de un reciclaje confirmado por el usuario.
class RecyclingRecord {
  final String id;
  final String userId;
  final String? imageUrl; // ruta local o URL remota (Fase 8)
  final RecyclingResult result;
  final DateTime confirmedAt;

  const RecyclingRecord({
    required this.id,
    required this.userId,
    this.imageUrl,
    required this.result,
    required this.confirmedAt,
  });

  RecyclingRecord copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    RecyclingResult? result,
    DateTime? confirmedAt,
  }) {
    return RecyclingRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      result: result ?? this.result,
      confirmedAt: confirmedAt ?? this.confirmedAt,
    );
  }

  factory RecyclingRecord.fromJson(Map<String, dynamic> json) {
    return RecyclingRecord(
      id: json['id'] as String,
      userId: json['userId'] as String,
      imageUrl: json['imageUrl'] as String?,
      result: RecyclingResult.fromJson(json['result'] as Map<String, dynamic>),
      confirmedAt: DateTime.parse(json['confirmedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
      'result': result.toJson(),
      'confirmedAt': confirmedAt.toIso8601String(),
    };
  }
}
