import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:opticlingo_app/features/study_session/data/datasources/study_remote_datasource.dart';
import 'package:opticlingo_app/features/study_session/data/repositories/study_repository_impl.dart';
import 'package:opticlingo_app/features/study_session/domain/repositories/study_repository.dart';
import 'package:opticlingo_app/features/study_session/presentation/bloc/study_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opticlingo_app/screens/dashboard_screen.dart';

void main() {
  final client = http.Client();

  final remoteDataSource = StudyRemoteDataSourceImpl(client: client);

  final studyRepository = StudyRepositoryImpl(
    remoteDataSource: remoteDataSource,
  );

  runApp(OpticLingoApp(studyRepository: studyRepository));
}

class OpticLingoApp extends StatelessWidget {
  final StudyRepository studyRepository;
  const OpticLingoApp({Key? key, required this.studyRepository})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: studyRepository,
      child: MaterialApp(
        title: 'OpticLingo',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF5F7FA),
          primaryColor: const Color(0xFF4B89F3),
          fontFamily: 'Poppins',
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: const Color(0xFF4B89F3),
          ),
          useMaterial3: true,
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}
