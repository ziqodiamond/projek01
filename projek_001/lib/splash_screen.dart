import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Set timer untuk berpindah ke halaman login setelah 3 detik
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo atau gambar splash screen
            Icon(Icons.store, size: 100, color: Colors.deepPurple),
            SizedBox(height: 20),
            Text(
              'Projek 001',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
