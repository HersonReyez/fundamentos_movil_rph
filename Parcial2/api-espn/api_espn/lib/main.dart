import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NflApp());
}

class NflApp extends StatelessWidget {
  const NflApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESPN NFL Scoreboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200], // Fondo ligeramente gris para resaltar las tarjetas
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}