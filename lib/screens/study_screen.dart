import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/study_session/domain/entities/flashcard.dart';
import '../features/study_session/domain/repositories/study_repository.dart';
import '../features/study_session/presentation/bloc/study_bloc.dart';
import '../features/study_session/presentation/bloc/study_event.dart';
import '../features/study_session/presentation/bloc/study_state.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  // Estado Local: ¿En qué carta vamos?
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StudyBloc(repository: context.read<StudyRepository>())
            ..add(const GetFlashcardsEvent(sourceLang: 'es', targetLang: 'en')),

      child: Scaffold(
        backgroundColor: Colors.white,
        // Usamos BlocBuilder para escuchar si ya llegaron los datos
        body: BlocBuilder<StudyBloc, StudyState>(
          builder: (context, state) {
            // 1. ESTADO CARGANDO
            if (state is StudyLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. ESTADO ERROR
            if (state is StudyError) {
              return Center(
                child: Text(state.message),
              ); // Simplificado por brevedad
            }

            // 3. ESTADO CARGADO (Éxito)
            if (state is StudyLoaded) {
              final flashcards = state.flashcards;

              // Validación: Si la lista está vacía
              if (flashcards.isEmpty)
                return const Center(child: Text("No cards found."));

              // Validación: ¿Ya terminamos todas las cartas?
              if (currentIndex >= flashcards.length) {
                return _buildCompletionScreen(context);
              }

              // Si hay cartas, mostramos la interfaz principal
              return SafeArea(
                child: Column(
                  children: [
                    // --- HEADER CON PROGRESO ---
                    _buildHeader(currentIndex + 1, flashcards.length),

                    // --- BARRA DE PROGRESO VISUAL ---
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 10,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value:
                              (currentIndex + 1) /
                              flashcards.length, // Cálculo dinámico
                          minHeight: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF4B89F3),
                          ),
                        ),
                      ),
                    ),

                    // --- LA CARTA (Pasa la carta actual según el índice) ---
                    // Usamos 'Key' para forzar que el widget se reconstruya y se voltee
                    // al cambiar de carta (resetear el estado de revelado)
                    Expanded(
                      child: FlashcardView(
                        key: ValueKey(currentIndex),
                        flashcard: flashcards[currentIndex],
                        onNext: () {
                          // Lógica: Avanzar al siguiente índice
                          setState(() {
                            currentIndex++;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(int current, int total) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.grey),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        children: [
          Text(
            "LEARNING",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "$current/$total",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _buildCompletionScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF2ECC71), size: 80),
          const SizedBox(height: 20),
          const Text(
            "Session Completed!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Back to Dashboard"),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET DE LA TARJETA (MODIFICADO) ---
class FlashcardView extends StatefulWidget {
  final Flashcard flashcard;
  final VoidCallback onNext; // Callback para avisar al padre que pase la carta

  const FlashcardView({
    super.key,
    required this.flashcard,
    required this.onNext,
  });

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
                _buildImageCard(),
                const SizedBox(height: 30),
                if (!isRevealed) _buildQuestion() else _buildAnswer(),
              ],
            ),
          ),
        ),
        _buildBottomButton(),
      ],
    );
  }

  // ... (Los métodos _buildImageCard, _buildQuestion y _buildAnswer son iguales al anterior) ...
  // ... (Cópialos del código anterior o avísame si los necesitas de nuevo) ...
  // Por brevedad, aquí solo pongo los que cambian o son vitales:

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
          // Usamos placeholder si la URL falla o es nula
          child: Image.network(
            widget.flashcard.imagePath.startsWith('http')
                ? widget.flashcard.imagePath
                : 'https://cdn-icons-png.flaticon.com/512/415/415733.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image, size: 50, color: Colors.grey),
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
        // AQUÍ ESTÁ EL CAMBIO CLAVE:
        // En lugar de solo resetear, llamamos a 'onNext' para que el padre avance el índice.
        widget.onNext();
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
