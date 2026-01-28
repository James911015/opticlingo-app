import 'package:equatable/equatable.dart';

class Flashcard extends Equatable {
  //Definimos las propiedades inmutables
  //Una vez creadas no pueden ser modificadas

  final int id;
  final String imagePath;
  final String sourceWord;
  final String targetWord;
  final String? phonetic;

  //Constructor constante, Ayuda a Flutter a  optimizar memoria.
  //Le decimos: Si dos objetos tienen estos mismos valores en este lista,
  //entonces son iguales.
  const Flashcard({
    required this.id,
    required this.imagePath,
    required this.sourceWord,
    required this.targetWord,
    this.phonetic,
  });

  @override
  List<Object?> get props => [id, imagePath, sourceWord, targetWord, phonetic];
}
