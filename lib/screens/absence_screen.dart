import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/absence_bloc.dart';
import '../bloc/absence_event.dart';
import '../bloc/absence_state.dart';

import '../widgets/absence_data_table.dart';
import '../widgets/page_controls.dart';

class AbsenceScreen extends StatefulWidget {
  const AbsenceScreen({super.key});

  @override
  State<AbsenceScreen> createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<AbsenceScreen> {
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadAbsences();
  }

  void _loadAbsences() {
    context.read<AbsenceBloc>().add(
          LoadAbsences(
            page: _currentPage,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absence Manager'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<AbsenceBloc, AbsenceState>(
              builder: (context, state) {
                if (state is AbsenceLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AbsenceError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is AbsenceLoaded) {
                  if (state.currentPageAbsences.isEmpty) {
                    return const Center(child: Text('No absences found.'));
                  }

                  return Column(
                    children: [
                      Center(
                        child: Text(
                            '${state.fromIndex} - ${state.toIndex} of ${state.totalItems} absences'),
                      ),
                      const Divider(height: 24),
                      // Absence data table
                      AbsenceDataTable(
                        absences: state.currentPageAbsences,
                        currentPage: state.currentPage,
                        totalPages: state.totalPages,
                        totalCount: state.totalItems,
                        itemsPerPage: 10,
                      ),
                      const SizedBox(height: 10),
                      // Pagination controls
                      PageControls(
                        currentPage: state.currentPage,
                        totalPages: state.totalPages,
                        onNextPage: () {
                          setState(() {
                            _currentPage++;
                          });
                          _loadAbsences();
                        },
                        onPreviousPage: () {
                          setState(() {
                            _currentPage--;
                          });
                          _loadAbsences();
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }

                return const Center(child: Text('Please wait...'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
