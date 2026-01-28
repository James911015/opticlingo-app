import '../../domain/entities/flashcard.dart';

class FlashcardModel extends Flashcard {
  // 1. Constructor
  // Simplemente recibe los datos y se los pasa al padre (super)
  const FlashcardModel({
    required super.imagePath,
    required super.sourceWord,
    required super.targetWord,
    required super.id,
    super.phonetic,
  });

  // 2. Factory: fromJson
  // Este es el traductor. Convierte el Mapa (JSON) en un Objeto Dart.
  factory FlashcardModel.fromJson(Map<String, dynamic> json) {
    return FlashcardModel(
      // Usamos los nombres exactos que vienen de tu API Spring Boot
      // Agregamos '??' (null coalescing) para proteger la app si un campo viene nulo
      imagePath: json['imagePath'],
      sourceWord: json['sourceWord'],
      targetWord: json['targetWord'],
      phonetic: json['phonetic'],
      id: json['id'],
    );
  }

  // 3. Método: toJson (Opcional por ahora)
  // Útil si alguna vez necesitas enviar datos DE VUELTA al servidor
  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'sourceWord': sourceWord,
      'targetWord': targetWord,
      'phonetic': phonetic,
    };
  }
}
