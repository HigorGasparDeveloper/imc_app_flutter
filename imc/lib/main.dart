import 'package:flutter/material.dart';
import 'components/formulario.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Cálculo de IMC"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        body: Formulario(),
      ),
    );
  }
}
