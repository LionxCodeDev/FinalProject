import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lionxcode_finalproject/Theme/theme.dart';
import 'package:lionxcode_finalproject/pages/login_page.dart';
import 'package:lionxcode_finalproject/providers/menu_provider.dart';
import 'package:lionxcode_finalproject/providers/provider.dart';
import 'package:lionxcode_finalproject/services/home.dart';
import 'package:lionxcode_finalproject/services/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PreferenciasUsuario.configurePrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (((_) => MenuProvider()))),
      ],
      child: MaterialApp(
        theme: myTheme,
        debugShowCheckedModeBanner: false,
        title: 'JAP',
        routes: {
          'home': (context) => const Home(),
          'login': (context) => Provide(key: const Key('key-user'), child: const LogInPage()),
        },
        initialRoute: 'home',
      ),
    );
  }
}

