import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:onomatopoeia_app/core/themes/theme_provider.dart';
import 'package:onomatopoeia_app/data/models/onomatopoeia_model.dart';
import 'package:onomatopoeia_app/data/models/user_model.dart';
import 'package:onomatopoeia_app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(OnomatopoeiaAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(AchievementAdapter());
  Hive.registerAdapter(AchievementTypeAdapter());

  // Open boxes
  await Hive.openBox<Onomatopoeia>('onomatopoeia_box');
  await Hive.openBox<User>('user_box');
  await Hive.openBox('settings_box');
  await Hive.openBox('achievements_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const OnomatopoeiaApp(),
    );
  }
}