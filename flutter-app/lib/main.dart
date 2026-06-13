import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/vocabulary/data/datasources/word_remote_data_source_impl.dart';
import 'features/vocabulary/data/repositories/word_repository_impl.dart';
import 'features/vocabulary/domain/usecases/add_word.dart';
import 'features/vocabulary/domain/usecases/get_words.dart';
import 'features/vocabulary/domain/usecases/delete_word.dart';
import 'features/vocabulary/presentation/pages/vocabulary_screen.dart';
import 'features/vocabulary/presentation/providers/words_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Instantiate Clean Architecture dependencies
  final remoteDataSource = WordRemoteDataSourceImpl();
  final repository = WordRepositoryImpl(remoteDataSource: remoteDataSource);
  final getWordsUseCase = GetWords(repository);
  final addWordUseCase = AddWord(repository);
  final deleteWordUseCase = DeleteWord(repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WordsProvider(
            getWordsUseCase: getWordsUseCase,
            addWordUseCase: addWordUseCase,
            deleteWordUseCase: deleteWordUseCase,
          )..fetchWords(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WordsProvider>(context);
    
    return MaterialApp(
      title: 'LingoBreeze',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: provider.themeMode,
      home: const VocabularyScreen(),
    );
  }
}
