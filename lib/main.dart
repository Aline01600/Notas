import 'package:flutter/material.dart';
import 'notas_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Notas',
      home: const NotasPage(),
    );
  }
}
