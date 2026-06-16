import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'providers/league_provider.dart';
import 'providers/match_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LeagueProvider()),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
      ],
      child: const DominoStatsApp(),
    ),
  );
}

class DominoStatsApp extends StatelessWidget {
  const DominoStatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Domino 200',
      debugShowCheckedModeBanner: false,
      theme: DominoTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
