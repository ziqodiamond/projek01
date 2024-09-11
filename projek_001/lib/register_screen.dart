import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart'; // Impor untuk kembali ke halaman login

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  // Fungsi untuk register ke API
  Future<void> register() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost/projek01/register.php'), // Ganti URL sesuai dengan IP server kamu
        body: {
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = json.decode(response.body);

      setState(() {
        isLoading = false;
      });

      if (data['status'] == 'success') {
        // Berhasil register, kembali ke halaman login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // Gagal register, tampilkan pesan error dari API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  data['error'] ?? 'Registration failed. Please try again.')),
        );
      }
    } catch (error) {
      // Jika ada error di jaringan atau hal lain
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: register, // Panggil fungsi register
                    child: Text('Register'),
                  ),
          ],
        ),
      ),
    );
  }
}
