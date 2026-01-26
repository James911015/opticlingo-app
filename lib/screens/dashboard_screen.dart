import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'study_screen.dart'; // Importante: Conectamos con la pantalla de estudio

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              _buildHeader(),
              const SizedBox(height: 30),

              // SECCIÓN: ACTIVE COURSES
              _buildSectionTitle("Active Courses", showSeeAll: true),
              const SizedBox(height: 16),

              // TARJETA DEL CURSO (Aquí está el botón importante)
              _buildActiveCourseCard(context),

              const SizedBox(height: 30),

              // SECCIÓN: TODAY'S FOCUS
              _buildSectionTitle("Today's Focus"),
              const SizedBox(height: 16),
              _buildFocusItem(
                icon: Icons.chat_bubble_outline,
                color: Colors.blue.shade100,
                iconColor: Colors.blue,
                title: "Basics of Conversation",
                subtitle: "5 min • Spanish",
                isCompleted: false,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4B89F3),
        unselectedItemColor: Colors.grey.shade400,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: "Learn"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Rank"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xFF4B89F3),
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back,",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const Text(
                  "James Arias 👋",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE0B2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
              SizedBox(width: 4),
              Text(
                "12",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {bool showSeeAll = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        if (showSeeAll)
          const Text("See All", style: TextStyle(color: Color(0xFF4B89F3))),
      ],
    );
  }

  Widget _buildActiveCourseCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text("🇪🇸", style: TextStyle(fontSize: 20)),
              ),
              const Icon(Icons.more_horiz, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Spanish",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            "to English",
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
          const SizedBox(height: 20),

          CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 10.0,
            percent: 0.45,
            center: const Text(
              "45%",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF4B89F3),
              ),
            ),
            progressColor: const Color(0xFF4B89F3),
            backgroundColor: const Color(0xFFE3F2FD),
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(height: 20),

          // --- AQUÍ ESTÁ LA NAVEGACIÓN ---
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navegamos a la pantalla de estudio que conectamos con BLoC
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudyScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5F7FA),
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              child: const Text("Continue Learning"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusItem({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isCompleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
