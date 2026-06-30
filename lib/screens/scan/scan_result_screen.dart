import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/recycling_provider.dart';
import '../../providers/user_progress_provider.dart';
import '../../widgets/recycling_result_card.dart';

/// Muestra el resultado de la clasificación y permite confirmar el reciclaje.
class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecyclingProvider>();
    final result = provider.result;

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: result == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No hay un resultado para mostrar. Vuelve a escanear.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.go('/scan'),
                      child: const Text('Escanear'),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (provider.imagePath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(provider.imagePath!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),
                RecyclingResultCard(result: result),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => _confirm(context, provider),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Confirmar reciclaje'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    provider.reset();
                    context.go('/scan');
                  },
                  child: const Text('Escanear otro'),
                ),
              ],
            ),
    );
  }

  Future<void> _confirm(BuildContext context, RecyclingProvider provider) async {
    final result = provider.result;
    if (result == null) return;

    // Captura referencias antes del await para no usar el context tras la asíncrona.
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final progress = context.read<UserProgressProvider>();

    await progress.addRecyclingResult(result, imageUrl: provider.imagePath);
    provider.markConfirmed();
    provider.reset();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          '¡Reciclaje confirmado! +${result.ecoPointsAwarded} EcoPuntos 🌱',
        ),
      ),
    );
    // Devuelve la pestaña Escanear a su raíz y lleva al usuario al Inicio.
    router.go('/scan');
    router.go('/home');
  }
}
