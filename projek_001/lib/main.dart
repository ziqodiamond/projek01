import 'package:flutter/material.dart';
import 'login_screen.dart'; // Impor halaman login
import 'register_screen.dart'; // Impor halaman register
import 'home_screen.dart'; // Impor halaman home
import 'splash_screen.dart'; // Impor halaman splash screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projek 001',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Tentukan halaman splash sebagai halaman awal
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
