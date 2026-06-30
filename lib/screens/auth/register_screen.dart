import 'package:flutter/material.dart';
import '../../widgets/placeholder_view.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Crear cuenta',
      icon: Icons.person_add_alt,
      subtitle: 'Registro de usuario (Fase 2).',
    );
  }
}
