import 'package:opticlingo_app/features/study_session/data/datasources/study_remote_datasource.dart';
import 'package:opticlingo_app/features/study_session/data/models/flashcard_model.dart';
import 'package:opticlingo_app/features/study_session/domain/repositories/study_repository.dart';

class StudyRepositoryImpl implements StudyRepository {
  // Dependemos del DataSource (el que habla con la API)
  final StudyRemoteDataSource remoteDataSource;

  StudyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<FlashcardModel>> getFlashcards(
    String sourceLang,
    String targetLang,
  ) async {
    try {
      // 1. Llamamos a la API (Data Source)
      // Esto nos devuelve List<FlashcardModel>
      final remoteData = await remoteDataSource.getFlashcards(
        sourceLang,
        targetLang,
      );

      // 2. Retornamos los datos
      // AQUÍ ESTÁ LA MAGIA DE LISKOV (L de SOLID):
      // Como 'FlashcardModel' extiende de 'Flashcard', podemos devolverlo directamente.
      // El Dominio recibe lo que pidió (Flashcard) sin saber que en realidad son Modelos.
      return remoteData;
    } catch (e) {
      // Si algo falla, relanzamos el error.
      // En una app más avanzada, aquí convertiríamos la "Exception" técnica
      // en un "Failure" de negocio (ej: 'ServerFailure', 'InternetFailure').
      throw Exception('Error al obtener flashcards: $e');
    }
  }
}
