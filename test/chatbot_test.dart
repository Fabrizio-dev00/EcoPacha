import 'package:flutter_test/flutter_test.dart';

import 'package:ecopacha/services/local_keyword_chatbot_service.dart';

void main() {
  final bot = LocalKeywordChatbotService();

  test('responde preguntas frecuentes por palabra clave', () async {
    expect(await bot.ask('¿Dónde boto una botella de aceite?'),
        contains('aceite'));
    expect(await bot.ask('¿El papel con grasa se recicla?'), contains('resto'));
    expect(await bot.ask('¿Qué hago con pilas usadas?'), contains('peligrosos'));
    expect(await bot.ask('¿Cómo reciclo una botella PET?'), contains('amarillo'));
  });

  test('una pregunta desconocida devuelve el mensaje de respaldo', () async {
    expect(await bot.ask('zxcvbnm'), contains('aprendiendo'));
  });

  test('expone preguntas rápidas para la interfaz', () {
    expect(bot.quickQuestions, isNotEmpty);
  });
}
