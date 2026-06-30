import '../models/challenge.dart';

/// Retos diarios de ejemplo (se reemplazarán por datos reales en Firebase).
const List<Challenge> mockDailyChallenges = [
  Challenge(
    id: 'c1',
    title: 'Escanea 5 reciclables',
    description: 'Usa el escáner para identificar 5 residuos hoy.',
    target: 5,
    progress: 2,
    rewardEcoPoints: 50,
    type: ChallengeType.escanear,
  ),
  Challenge(
    id: 'c2',
    title: 'Recicla plástico 3 días',
    description: 'Mantén el hábito reciclando plástico durante 3 días.',
    target: 3,
    progress: 1,
    rewardEcoPoints: 60,
    type: ChallengeType.reciclarRacha,
  ),
  Challenge(
    id: 'c3',
    title: 'Aprende 3 consejos',
    description: 'Pregunta a EcoBot y aprende 3 consejos de reciclaje.',
    target: 3,
    progress: 0,
    rewardEcoPoints: 30,
    type: ChallengeType.aprender,
  ),
  Challenge(
    id: 'c4',
    title: 'Lleva pilas al acopio',
    description: 'Deposita pilas usadas en un punto de acopio autorizado.',
    target: 1,
    progress: 0,
    rewardEcoPoints: 40,
    type: ChallengeType.llevarAcopio,
  ),
];
