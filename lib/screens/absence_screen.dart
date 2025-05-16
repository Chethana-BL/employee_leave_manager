import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/absence_bloc.dart';
import '../bloc/absence_event.dart';
import '../bloc/absence_state.dart';
import '../models/absence_status.dart';
import '../models/absence_type.dart';
import '../models/member.dart';
import '../repository/absence_repository_factory.dart';
import '../widgets/absence_data_table.dart';
import '../widgets/absence_filter.dart';
import '../widgets/absence_overview.dart';
import '../widgets/export_iCal_button.dart';
import '../widgets/page_controls.dart';

class AbsenceScreen extends StatefulWidget {
  const AbsenceScreen({super.key});

  @override
  State<AbsenceScreen> createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<AbsenceScreen> {
  AbsenceType? selectedTypeFilter;
  AbsenceStatus? selectedStatusFilter;
  DateTimeRange? selectedDateRange;
  Member? selectedMemberFilter;
  List<Member> allMembers = [];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadAbsences();
    _loadMembers();
  }

  void _loadAbsences() {
    context.read<AbsenceBloc>().add(
          LoadAbsences(
            page: _currentPage,
            typeFilter: selectedTypeFilter,
            statusFilter: selectedStatusFilter,
            dateRangeFilter: selectedDateRange,
            memberFilter: selectedMemberFilter,
          ),
        );
  }

  void _triggerFilter() {
    setState(() {
      _currentPage = 0;
    });
    _loadAbsences();
  }

  /// Storing members locally to support filtering UI. In a larger app, this could move to a dedicated bloc/provider.
  void _loadMembers() async {
    final members = await AbsenceRepositoryFactory.create(DataSourceType.mock)
        .fetchMembers();
    setState(() {
      allMembers = members;
    });
  }

  void _resetFilters() {
    setState(() {
      selectedTypeFilter = null;
      selectedStatusFilter = null;
      selectedMemberFilter = null;
      selectedDateRange = null;
      _currentPage = 0;
    });
    _loadAbsences();
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
          // 🧩 Filter bar
          AbsenceFilter(
            selectedType: selectedTypeFilter,
            selectedStatus: selectedStatusFilter,
            selectedDateRange: selectedDateRange,
            selectedEmployee: selectedMemberFilter,
            allMembers: allMembers,
            onTypeChanged: (type) {
              setState(() => selectedTypeFilter = type);
              _triggerFilter();
            },
            onStatusChanged: (status) {
              setState(() => selectedStatusFilter = status);
              _triggerFilter();
            },
            onDateRangeChanged: (range) {
              setState(() => selectedDateRange = range);
              _triggerFilter();
            },
            onEmployeeChanged: (member) {
              setState(() => selectedMemberFilter = member);
              _triggerFilter();
            },
            onClearFilters: _resetFilters,
          ),
          const SizedBox(width: 10),
          const Divider(height: 24),

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
                      AbsenceOverview(
                        fromIndex: state.fromIndex + 1,
                        toIndex: state.toIndex,
                        totalItems: state.totalItems,
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
                      ExportAbsencesButton(absences: state.currentPageAbsences)
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
