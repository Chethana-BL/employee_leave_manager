import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/absence_bloc.dart';
import '../bloc/absence_event.dart';
import '../bloc/absence_state.dart';
import '../models/filters/absence_filter_model.dart';
import '../models/member.dart';
import '../repository/absence_repository_factory.dart';
import '../widgets/absence_data_table.dart';
import '../widgets/absence_overview.dart';
import '../widgets/error_message_widget.dart';
import '../widgets/export_ical_button.dart';
import '../widgets/filters/filter_applied_chips.dart';
import '../widgets/filters/filter_button.dart';
import '../widgets/filters/filter_dialog.dart';
import '../widgets/no_absences_found.dart';
import '../widgets/page_controls.dart';

class AbsenceScreen extends StatefulWidget {
  const AbsenceScreen({super.key});

  @override
  State<AbsenceScreen> createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<AbsenceScreen> {
  AbsenceFilterModel currentFilters = AbsenceFilterModel();
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
            filters: currentFilters,
          ),
        );
  }

  void _triggerFilter(AbsenceFilterModel updatedFilters) {
    setState(() {
      currentFilters = updatedFilters;
      _currentPage = 0;
    });
    _loadAbsences();
  }

  /// Storing members locally to support filtering UI. In a larger app, this could move to a dedicated bloc/provider.
  void _loadMembers() async {
    final members = await AbsenceRepositoryFactory.create(DataSourceType.api)
        .fetchMembers();
    setState(() {
      allMembers = members;
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return FilterDialog(
          allMembers: allMembers,
          initialFilters: currentFilters,
          onClear: () {
            Navigator.of(context).pop();
            _triggerFilter(AbsenceFilterModel());
          },
          onApply: (filters) {
            Navigator.of(context).pop();
            _triggerFilter(filters);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeFilterCount = currentFilters.activeCount;

    return Scaffold(
      appBar: AppBar(title: const Text('Absence Manager')),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: FilterButton(
                    activeFilterCount: activeFilterCount,
                    onPressed: _showFilterDialog,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilterAppliedChips(
                    filters: currentFilters,
                    onFilterChanged: (newFilters) => _triggerFilter(newFilters),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Divider(height: 24),

          Expanded(
            child: BlocBuilder<AbsenceBloc, AbsenceState>(
              builder: (context, state) {
                if (state is AbsenceLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AbsenceError) {
                  return ErrorMessageWidget(
                    onRetry: () => _loadAbsences(),
                  );
                } else if (state is AbsenceLoaded) {
                  if (state.currentPageAbsences.isEmpty) {
                    return const NoAbsencesFound();
                  }

                  return Column(
                    children: [
                      AbsenceOverview(
                        fromIndex: state.fromIndex + 1,
                        toIndex: state.toIndex,
                        totalItems: state.totalItems,
                      ),

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
                          setState(() => _currentPage++);
                          _loadAbsences();
                        },
                        onPreviousPage: () {
                          setState(() => _currentPage--);
                          _loadAbsences();
                        },
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ExportAbsencesButton(
                          absences: state.currentPageAbsences,
                        ),
                      ),
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
