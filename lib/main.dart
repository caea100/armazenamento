import 'package:flutter/material.dart';
import 'screens/lista_item.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estoque',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ListaItem(),
    );
  }
}
