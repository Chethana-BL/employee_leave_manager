import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/absence_bloc.dart';
import 'repository/absence_repository_factory.dart';
import 'screens/absence_screen.dart';

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
      home: BlocProvider(
        create: (context) => AbsenceBloc(
            repository: AbsenceRepositoryFactory.create(DataSourceType.mock)),
        child: const AbsenceScreen(),
      ),
    );
  }
}
