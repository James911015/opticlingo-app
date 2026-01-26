import 'package:equatable/equatable.dart';
import 'package:opticlingo_app/features/study_session/domain/entities/flashcard.dart';

abstract class StudyState extends Equatable {
  const StudyState();

  @override
  List<Object> get props => [];
}

// Estado inicial: No estamos haciendo nada
class StudyInitial extends StudyState {}

// Estado: Estamos cargando (mostrando el spinner)
class StudyLoading extends StudyState {}

// Estado: ¡Éxito! Tenemos los datos listos
class StudyLoaded extends StudyState {
  final List<Flashcard> flashcards;

  const StudyLoaded({required this.flashcards});

  @override
  List<Object> get props => [flashcards];
}

// Estado: Hubo un error
class StudyError extends StudyState {
  final String message;

  const StudyError({required this.message});

  @override
  List<Object> get props => [message];
}
