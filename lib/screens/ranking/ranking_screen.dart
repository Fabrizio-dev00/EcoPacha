import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../models/leaderboard_user.dart';
import '../../providers/leaderboard_provider.dart';

/// Ranking semanal con el top 3 destacado.
class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<LeaderboardProvider>();
      if (provider.status == LoadStatus.idle) provider.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeaderboardProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ranking semanal')),
      body: switch (provider.status) {
        LoadStatus.idle ||
        LoadStatus.loading =>
          const Center(child: CircularProgressIndicator()),
        LoadStatus.error => _ErrorView(
            message: provider.error,
            onRetry: () => context.read<LeaderboardProvider>().load(),
          ),
        LoadStatus.success => _RankingContent(users: provider.users),
      },
    );
  }
}

class _RankingContent extends StatelessWidget {
  final List<LeaderboardUser> users;

  const _RankingContent({required this.users});

  @override
  Widget build(BuildContext context) {
    final top = users.take(3).toList();
    final rest = users.skip(3).toList();
    return Column(
      children: [
        const SizedBox(height: 20),
        _Podium(top: top),
        const Divider(height: 28),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: rest.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) => _RankRow(user: rest[index]),
          ),
        ),
      ],
    );
  }
}

class _Podium extends StatelessWidget {
  final List<LeaderboardUser> top;

  const _Podium({required this.top});

  @override
  Widget build(BuildContext context) {
    LeaderboardUser? at(int i) => i < top.length ? top[i] : null;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (at(1) != null) _PodiumItem(user: at(1)!, height: 84, medal: '🥈'),
        if (at(0) != null) _PodiumItem(user: at(0)!, height: 112, medal: '🥇'),
        if (at(2) != null) _PodiumItem(user: at(2)!, height: 64, medal: '🥉'),
      ],
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final LeaderboardUser user;
  final double height;
  final String medal;

  const _PodiumItem({
    required this.user,
    required this.height,
    required this.medal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(medal, style: const TextStyle(fontSize: 24)),
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primaryLight,
            child: Text(_initials(user.name),
                style: const TextStyle(
                    color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 80,
            child: Text(
              user.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Text('${user.ecoPoints}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Container(
            width: 80,
            height: height,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.turquoise],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 8),
            child: Text('${user.position}°',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    return parts.first[0].toUpperCase();
  }
}

class _RankRow extends StatelessWidget {
  final LeaderboardUser user;

  const _RankRow({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMe = user.name == 'Tú';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? AppColors.surfaceMuted : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isMe ? AppColors.primary : AppColors.surfaceMuted,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text('${user.position}',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(
                  color: AppColors.primaryDark, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(user.name,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: isMe ? FontWeight.bold : null)),
          ),
          Text('${user.ecoPoints}',
              style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(width: 4),
          Text('pts',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 56, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(message ?? 'Ocurrió un error.', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}
