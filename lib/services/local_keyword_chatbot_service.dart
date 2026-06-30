import 'chatbot_service.dart';

/// Regla de respuesta: si la pregunta contiene alguna palabra clave, responde.
class _Rule {
  final List<String> keywords;
  final String answer;

  const _Rule(this.keywords, this.answer);
}

/// Implementación local del EcoBot basada en palabras clave.
/// Sin conexión ni IA; ideal para el MVP y las demos sin internet.
class LocalKeywordChatbotService implements ChatbotService {
  @override
  List<String> get quickQuestions => const [
        '¿Dónde boto una botella de aceite?',
        '¿El papel con grasa se recicla?',
        '¿Qué hago con pilas usadas?',
        '¿Cómo reciclo una botella PET?',
      ];

  @override
  Future<String> ask(String question) async {
    final q = question.toLowerCase();
    for (final rule in _rules) {
      if (rule.keywords.any(q.contains)) {
        return rule.answer;
      }
    }
    return _fallback;
  }

  static const String _fallback =
      'Aún estoy aprendiendo sobre eso. 🐦 Prueba preguntando por PET, papel, '
      'vidrio, metal, pilas, aceite, orgánicos o electrónicos.';

  // El orden importa: las reglas más específicas van primero.
  static const List<_Rule> _rules = [
    _Rule(
      ['aceite'],
      'El aceite usado NO va al desagüe ni al reciclaje común. Guárdalo en una '
          'botella cerrada y llévalo a un punto de acopio de aceite. ♻️',
    ),
    _Rule(
      ['grasa', 'servilleta', 'papel'],
      'El papel con grasa o comida (servilletas, cajas de pizza manchadas) NO '
          'se recicla: va al contenedor de resto. El papel limpio sí se recicla. 📄',
    ),
    _Rule(
      ['pila', 'pilas', 'bateria', 'batería'],
      'Las pilas usadas son residuos peligrosos. No las tires a la basura: '
          'llévalas a un punto de acopio de pilas. 🔋',
    ),
    _Rule(
      ['vidrio', 'frasco'],
      'El vidrio (botellas y frascos) va al contenedor verde. Enjuágalo y '
          'retira tapas. No incluyas vidrios de ventana ni espejos. 🍾',
    ),
    _Rule(
      ['pet', 'plástico', 'plastico'],
      'Para reciclar una botella PET: vacíala, enjuágala, apláshala y deposítala '
          'en el contenedor amarillo. Quita la tapa. 🥤',
    ),
    _Rule(
      ['cartón', 'carton', 'caja'],
      'El cartón limpio y seco va al contenedor azul. Aplánalo para ahorrar '
          'espacio. El cartón con grasa no se recicla. 📦',
    ),
    _Rule(
      ['electrónico', 'electronico', 'cable', 'cargador', 'celular'],
      'Los residuos electrónicos (RAEE) se llevan a puntos de acopio especiales. '
          'No los mezcles con la basura común. 💻',
    ),
    _Rule(
      ['orgánico', 'organico', 'comida', 'compost', 'cáscara', 'cascara'],
      'Los residuos orgánicos pueden ir al compost: cáscaras y restos '
          'vegetales. Evita carnes y lácteos en el compost casero. 🍎',
    ),
    _Rule(
      ['metal', 'lata', 'aluminio'],
      'Las latas de metal y aluminio van al contenedor amarillo. Enjuágalas y '
          'apláshalas. El aluminio se recicla infinitas veces. 🥫',
    ),
  ];
}
