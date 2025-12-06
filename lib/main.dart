import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/app_user.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const ResponsiApp());
}

class ResponsiApp extends StatefulWidget {
  const ResponsiApp({super.key});

  @override
  State<ResponsiApp> createState() => _ResponsiAppState();
}

class _ResponsiAppState extends State<ResponsiApp> {
  Future<AppUser?> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final name = prefs.getString('name');
    final email = prefs.getString('email');

    if (token != null && name != null && email != null) {
      return AppUser(id: 0, name: name, email: email, token: token);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.grey[800]!;
    final accentColor = Colors.grey[600]!;

    return MaterialApp(
      title: 'Responsi 2 Mobile Paket 1 (H1D023007)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: accentColor,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 1.4),
          ),
          labelStyle: const TextStyle(fontSize: 14),
        ),
      ),
      home: FutureBuilder<AppUser?>(
        future: _checkLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (!snapshot.hasData) {
            return const LoginPage();
          }
          final user = snapshot.data;
          if (user == null || user.token.isEmpty) {
            return const LoginPage();
          }
          return HomePage(user: user);
        },
      ),
    );
  }
}
