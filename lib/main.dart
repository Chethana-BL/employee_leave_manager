import 'package:flutter/material.dart';

void main() {
  runApp(const AbsenceManagerApp());
}

class AbsenceManagerApp extends StatelessWidget {
  const AbsenceManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absence Manager',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const DummyHomePage(),
    );
  }
}

class DummyHomePage extends StatelessWidget {
  const DummyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absence Manager'),
      ),
      body: const Center(
        child: Text('Welcome to Absence Manager!'),
      ),
    );
  }
}
