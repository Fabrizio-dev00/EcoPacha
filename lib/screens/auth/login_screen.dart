import 'package:flutter/material.dart';
import '../../widgets/placeholder_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Iniciar sesión',
      icon: Icons.login,
      subtitle: 'Inicio de sesión y modo invitado (Fase 2).',
    );
  }
}
