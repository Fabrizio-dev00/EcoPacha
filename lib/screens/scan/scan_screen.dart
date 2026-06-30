import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/recycling_provider.dart';

/// Pantalla para tomar o subir una foto de un residuo y analizarla.
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pick(ImageSource source) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1280,
        imageQuality: 85,
      );
      if (file == null || !mounted) return;

      final provider = context.read<RecyclingProvider>();
      await provider.analyze(file.path);
      if (!mounted) return;

      if (provider.status == ScanStatus.success) {
        context.push('/scan/result');
      } else if (provider.status == ScanStatus.error) {
        messenger.showSnackBar(
          SnackBar(content: Text(provider.error ?? 'Error al analizar.')),
        );
      }
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('No se pudo acceder a la cámara o galería.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final analyzing = context.watch<RecyclingProvider>().isAnalyzing;
    final imagePath = context.watch<RecyclingProvider>().imagePath;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navScan)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(child: _Preview(imagePath: imagePath)),
            const SizedBox(height: 20),
            if (analyzing)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Analizando el residuo...'),
                  ],
                ),
              )
            else ...[
              FilledButton.icon(
                onPressed: () => _pick(ImageSource.camera),
                icon: const Icon(Icons.photo_camera),
                label: const Text('Tomar foto'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _pick(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Subir imagen'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  final String? imagePath;

  const _Preview({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: imagePath == null
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image_outlined,
                        size: 64, color: AppColors.primary),
                    SizedBox(height: 12),
                    Text(
                      'Toma o sube una foto del residuo para clasificarlo.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : Image.file(
              File(imagePath!),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
    );
  }
}
