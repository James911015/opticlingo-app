import '../entities/flashcard.dart';

// 'abstract class' en Dart funciona como una Interface en Java/C#.
// Define un contrato: "Quien quiera ser un StudyRepository, DEBE tener estos métodos".
abstract class StudyRepository {
  // Método: getFlashcards
  // - Recibe: idioma origen y destino (Strings).
  // - Devuelve: Un 'Future' (porque va a tardar un poco) que contendrá una Lista de 'Flashcard'.
  Future<List<Flashcard>> getFlashcards(String sourceLang, String targeLang);

  // NUEVO MÉTODO:
  // Recibe el ID de la carta y si la supiste (true) o no (false)
  Future<void> logStudySession(int cardId, bool isCorrect);
}
