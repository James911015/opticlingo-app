import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/study_session/domain/entities/flashcard.dart';
import '../features/study_session/domain/repositories/study_repository.dart';
import '../features/study_session/presentation/bloc/study_bloc.dart';
import '../features/study_session/presentation/bloc/study_event.dart';
import '../features/study_session/presentation/bloc/study_state.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. PROVEER EL BLOC
    // Aquí creamos la instancia del Bloc y le inyectamos el Repositorio
    // que viene del 'RepositoryProvider' en el main.dart
    return BlocProvider(
      create: (context) =>
          StudyBloc(repository: context.read<StudyRepository>())
            ..add(const GetFlashcardsEvent(sourceLang: 'es', targetLang: 'en')),

      // 2. CONSTRUIR LA VISTA
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Learning Session",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
          // 3. ESCUCHAR LOS ESTADOS
          child: BlocBuilder<StudyBloc, StudyState>(
            builder: (context, state) {
              // ESTADO: CARGANDO
              if (state is StudyLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // ESTADO: ERROR
              if (state is StudyError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(state.message, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Reintentar
                          context.read<StudyBloc>().add(
                            const GetFlashcardsEvent(
                              sourceLang: 'es',
                              targetLang: 'en',
                            ),
                          );
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }

              // ESTADO: CARGADO (ÉXITO)
              if (state is StudyLoaded) {
                // Si no hay cartas
                if (state.flashcards.isEmpty) {
                  return const Center(
                    child: Text("No flashcards found for this course."),
                  );
                }

                // Si hay cartas, mostramos el visor (FlashcardView)
                // Usamos la primera carta de la lista como ejemplo
                return FlashcardView(flashcard: state.flashcards[0]);
              }

              return const SizedBox.shrink(); // Estado inicial
            },
          ),
        ),
      ),
    );
  }
}

// --- WIDGET SEPARADO PARA LA TARJETA (Lógica visual de girar) ---
class FlashcardView extends StatefulWidget {
  final Flashcard flashcard;
  const FlashcardView({super.key, required this.flashcard});

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView> {
  bool isRevealed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // IMAGEN (Viene del Backend ahora)
                _buildImageCard(),
                const SizedBox(height: 30),
                // TEXTO (Pregunta o Respuesta)
                if (!isRevealed) _buildQuestion() else _buildAnswer(),
              ],
            ),
          ),
        ),
        _buildBottomButton(),
      ],
    );
  }

  Widget _buildImageCard() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          // Usamos la URL que viene de la entidad Flashcard
          // Nota: Como tu backend devuelve rutas relativas ('/images/...'),
          // quizás necesitemos concatenar la URL base si no es completa.
          // Por ahora asumimos que es una URL o usamos un placeholder si falla.
          child: Image.network(
            // Truco: Si la ruta empieza con http, úsala. Si no, usa placeholder.
            widget.flashcard.imagePath.startsWith('http')
                ? widget.flashcard.imagePath
                : 'https://cdn-icons-png.flaticon.com/512/415/415733.png', // Fallback
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    return Column(
      children: [
        Text(
          widget.flashcard.sourceWord,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Tap reveal to see translation",
          style: TextStyle(fontSize: 16, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildAnswer() {
    return Column(
      children: [
        Text(
          widget.flashcard.targetWord,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          widget.flashcard.phonetic ?? "",
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[400],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: !isRevealed
          ? ElevatedButton(
              onPressed: () => setState(() => isRevealed = true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B89F3),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Reveal Answer",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: _actionButton("I forgot", const Color(0xFFFF6B6B)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _actionButton("I knew it", const Color(0xFF2ECC71)),
                ),
              ],
            ),
    );
  }

  Widget _actionButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {
        // Aquí iría la lógica para pasar a la siguiente carta
        // Por ahora solo reseteamos para efectos de demo
        setState(() => isRevealed = false);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
