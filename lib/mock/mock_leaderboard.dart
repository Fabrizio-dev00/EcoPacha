import '../models/leaderboard_user.dart';

/// Ranking semanal simulado. Se conectará a Firestore en Fase 7/8.
const List<LeaderboardUser> mockLeaderboard = [
  LeaderboardUser(id: 'u1', name: 'María Quispe', ecoPoints: 1280, position: 1),
  LeaderboardUser(id: 'u2', name: 'Diego Rojas', ecoPoints: 1150, position: 2),
  LeaderboardUser(id: 'u3', name: 'Lucía Mendoza', ecoPoints: 990, position: 3),
  LeaderboardUser(id: 'u4', name: 'Carlos Huamán', ecoPoints: 870, position: 4),
  LeaderboardUser(id: 'u5', name: 'Ana Flores', ecoPoints: 760, position: 5),
  LeaderboardUser(id: 'u6', name: 'José Ramírez', ecoPoints: 640, position: 6),
  LeaderboardUser(id: 'u7', name: 'Valeria Castro', ecoPoints: 520, position: 7),
  LeaderboardUser(id: 'u8', name: 'Tú', ecoPoints: 480, position: 8),
];
