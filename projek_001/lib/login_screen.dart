import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_screen.dart'; // Pastikan ini diimpor untuk navigasi ke halaman Home

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  // Fungsi untuk login ke API
  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Kirim permintaan POST ke API
      final response = await http.post(
        Uri.parse(
            'http://localhost/projek01/login.php'), // Ganti URL sesuai API-mu
        headers: {'Content-Type': 'application/json'}, // Header JSON
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      // Debugging: Cetak status dan body respons
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Cek jika status code adalah 200
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          isLoading = false;
        });

        if (data['success'] == true) {
          // Berhasil login, pindah ke halaman Home
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          // Gagal login, tampilkan pesan error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ??
                  'Login failed. Please check your credentials'),
            ),
          );
        }
      } else {
        // Tampilkan pesan jika status code bukan 200
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error. Please try again later.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Debugging: Cetak error
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator() // Menampilkan loading spinner saat proses
                : ElevatedButton(
                    onPressed: login, // Panggil fungsi login
                    child: Text('Login'),
                  ),
            TextButton(
              onPressed: () {
                // Pindah ke halaman register
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
