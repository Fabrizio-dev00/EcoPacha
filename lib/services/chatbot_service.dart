/// Contrato del asistente educativo EcoBot.
///
/// El MVP usa [LocalKeywordChatbotService] (respuestas por palabras clave). En
/// la Fase 8 se puede añadir AiChatbotService que consuma un backend seguro.
abstract class ChatbotService {
  /// Responde una pregunta del usuario sobre reciclaje.
  Future<String> ask(String question);

  /// Preguntas frecuentes sugeridas para la interfaz.
  List<String> get quickQuestions;
}
