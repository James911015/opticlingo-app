import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flashcard_model.dart';

// 1. El Contrato (Interface)
// Define: "Quien quiera ser un DataSource, debe saber traer flashcards"
abstract interface class StudyRemoteDataSource {
  Future<List<FlashcardModel>> getFlashcards(
    String sourceLang,
    String targetLang,
  );

  Future<void> logStudySession(int cardId, bool isCorrect);
}

// 2. La Implementación Real
class StudyRemoteDataSourceImpl implements StudyRemoteDataSource {
  final http.Client client;

  // Inyectamos el cliente HTTP. Esto facilita el testing más adelante.
  StudyRemoteDataSourceImpl({required this.client});

  // --- IMPORTANTE: CONFIGURACIÓN DE LA URL ---
  // Si usas Emulador Android: Usa '10.0.2.2' en lugar de 'localhost'
  // Si usas iOS o Web: Usa 'localhost'
  // Si usas tu VPS real: Pon la IP pública de tu servidor
  @override
  Future<List<FlashcardModel>> getFlashcards(
    String sourceLang,
    String targetLang,
  ) async {
    final baseUrl = Uri.parse('http://72.62.169.13:8080/api');

    final uri = Uri.parse(
      '$baseUrl/flashcards?source=$sourceLang&target=$targetLang',
    );

    try {
      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => FlashcardModel.fromJson(json)).toList();
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<void> logStudySession(int cardId, bool isCorrect) async {
    final baseUrl =
        'http://72.62.169.13:8080/api'; // Asegúrate de tener tu IP aquí
    final uri = Uri.parse('$baseUrl/progress'); // Asumimos este endpoint

    try {
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'flashcardId': cardId,
          'isCorrect': isCorrect,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al guardar progreso: ${response.statusCode}');
      }
    } catch (e) {
      // En una app real, aquí guardaríamos en base de datos local (SQLite)
      // para reintentar cuando vuelva el internet (Offline First).
      // Por ahora, solo imprimimos el error.
      print("Error enviando progreso: $e");
      throw Exception('Error de conexión');
    }
  }
}
