import 'package:equatable/equatable.dart';

abstract class StudyEvent extends Equatable {
  const StudyEvent();

  @override
  List<Object> get props => [];
}

// Evento: El usuario (o la pantalla) pide cargar las flashcards
class GetFlashcardsEvent extends StudyEvent {
  final String sourceLang;
  final String targetLang;

  const GetFlashcardsEvent({
    required this.sourceLang,
    required this.targetLang,
  });

  @override
  List<Object> get props => [sourceLang, targetLang];
}
