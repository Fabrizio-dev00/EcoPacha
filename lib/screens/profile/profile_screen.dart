import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/achievements.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../models/recycling_record.dart';
import '../../models/recycling_result.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_progress_provider.dart';

/// Pantalla de perfil del usuario.
/// Las cifras de progreso vienen de [UserProgressProvider] (fuente única).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final progress = context.watch<UserProgressProvider>();
    final user = auth.user;
    final theme = Theme.of(context);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navProfile)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.primaryLight,
              child: Text(
                _initials(user.name),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              user.name,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              user.isGuest ? 'Modo invitado' : user.email,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                children: [
                  _Stat(
                    label: AppStrings.ecoPoints,
                    value: Formatters.points(progress.ecoPoints),
                  ),
                  _Stat(label: AppStrings.level, value: '${progress.level}'),
                  _Stat(
                    label: AppStrings.streak,
                    value: '${progress.streakDays}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.recycling, color: AppColors.primary),
              title: const Text('Residuos reciclados'),
              trailing: Text(
                '${progress.totalRecycledItems}',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Insignias'),
          const SizedBox(height: 8),
          _BadgesWrap(
            achievements: Achievements.forProgress(
              totalRecycledItems: progress.totalRecycledItems,
              streakDays: progress.streakDays,
              level: progress.level,
              ecoPoints: progress.ecoPoints,
            ),
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Historial de reciclaje'),
          const SizedBox(height: 8),
          _History(records: progress.records),
          if (user.isGuest) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Estás en modo invitado. Tu progreso se guarda solo en este dispositivo.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 28),
          OutlinedButton.icon(
            onPressed: () => context.read<AuthProvider>().signOut(),
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts[1][0]).toUpperCase();
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _BadgesWrap extends StatelessWidget {
  final List<Achievement> achievements;

  const _BadgesWrap({required this.achievements});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final achievement in achievements)
          _BadgeTile(achievement: achievement),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final Achievement achievement;

  const _BadgeTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unlocked = achievement.unlocked;
    return Tooltip(
      message: achievement.description,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: unlocked
              ? AppColors.primary.withValues(alpha: 0.10)
              : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: unlocked
                ? AppColors.primary.withValues(alpha: 0.4)
                : Colors.black12,
          ),
        ),
        child: Column(
          children: [
            Icon(
              unlocked ? achievement.icon : Icons.lock_outline,
              color: unlocked ? AppColors.primary : Colors.grey,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              achievement.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    unlocked ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _History extends StatelessWidget {
  final List<RecyclingRecord> records;

  const _History({required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.history, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Aún no has reciclado nada. ¡Escanea tu primer residuo!',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      );
    }
    final recent = records.take(10).toList();
    return Column(
      children: [
        for (final record in recent) _HistoryTile(record: record),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final RecyclingRecord record;

  const _HistoryTile({required this.record});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = record.result;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.surfaceMuted,
          child: Icon(Icons.recycling, color: AppColors.primary),
        ),
        title: Text(
          result.material,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${result.category.label} · ${Formatters.shortDate(record.confirmedAt)}',
        ),
        trailing: Text(
          '+${result.ecoPointsAwarded}',
          style: theme.textTheme.titleSmall
              ?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
