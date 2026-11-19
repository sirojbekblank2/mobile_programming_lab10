
import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'services/classifier.dart';
import 'services/history_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final classifier = await Classifier.load();
    final history = HistoryService();

    runApp(
      ClassifierApp(
        classifier: classifier,
        history: history,
      ),
    );
  } catch (e) {
    runApp(StartupErrorApp(error: e.toString()));
  }
}

class ClassifierApp extends StatefulWidget {
  const ClassifierApp({
    super.key,
    required this.classifier,
    required this.history,
  });

  final Classifier classifier;
  final HistoryService history;

  @override
  State<ClassifierApp> createState() => _ClassifierAppState();
}

class _ClassifierAppState extends State<ClassifierApp> {
  @override
  void dispose() {
    widget.classifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Object Lens',
      theme: AppTheme.light,
      home: WelcomeScreen(
        classifier: widget.classifier,
        history: widget.history,
      ),
    );
  }
}

class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({
    super.key,
    required this.error,
  });

  final String error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 56,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Unable to load the model',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  error,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
