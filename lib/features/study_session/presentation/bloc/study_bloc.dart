import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opticlingo_app/features/study_session/domain/repositories/study_repository.dart';
import 'package:opticlingo_app/features/study_session/presentation/bloc/study_event.dart';
import 'package:opticlingo_app/features/study_session/presentation/bloc/study_state.dart';

class StudyBloc extends Bloc<StudyEvent, StudyState> {
  // Dependencia: Necesitamos el Repositorio para trabajar
  final StudyRepository repository;

  StudyBloc({required this.repository}) : super(StudyInitial()) {
    // Registramos el manejador del evento
    on<GetFlashcardsEvent>(_onGetFlashcards);
  }

  // Lógica separada para mantener el código limpio
  Future<void> _onGetFlashcards(
    GetFlashcardsEvent event,
    Emitter<StudyState> emit,
  ) async {
    // 1. Emitimos "Cargando" para que la UI muestre el spinner
    emit(StudyLoading());
    try {
      // 2. Pedimos los datos al repositorio
      final flashcards = await repository.getFlashcards(
        event.sourceLang,
        event.targetLang,
      );
      // 3. Si todo sale bien, emitimos "Cargado"
      emit(StudyLoaded(flashcards: flashcards));
    } catch (e) {
      // 4. Si falla, emitimos "Error"
      emit(StudyError(message: e.toString()));
    }
  }
}
