import 'package:bloc_test/bloc_test.dart';
import 'package:employee_leave_manager/bloc/absence_bloc.dart';
import 'package:employee_leave_manager/bloc/absence_event.dart';
import 'package:employee_leave_manager/bloc/absence_state.dart';
import 'package:employee_leave_manager/models/absence.dart';
import 'package:employee_leave_manager/models/absence_status.dart';
import 'package:employee_leave_manager/models/absence_type.dart';
import 'package:employee_leave_manager/models/member.dart';
import 'package:employee_leave_manager/repository/absence_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAbsenceRepository extends Mock implements AbsenceRepository {}

void main() {
  late AbsenceRepository repository;
  late AbsenceBloc bloc;

  final mockMember = Member(
    id: 1,
    userId: 1,
    name: 'John',
    image: 'https://example.com/image.jpg',
    crewId: 101,
  );

  final mockAbsence = Absence(
    id: 100,
    userId: 1,
    startDate: DateTime(2024, 5, 1),
    endDate: DateTime(2024, 5, 5),
    memberNote: 'Sick leave',
    admitterNote: null,
    type: AbsenceType.sickness,
    confirmedAt: DateTime(2024, 5, 2),
    rejectedAt: null,
    member: mockMember,
    status: AbsenceStatus.confirmed,
  );

  setUp(() {
    repository = MockAbsenceRepository();
    bloc = AbsenceBloc(repository: repository);
  });

  tearDown(() {
    bloc.close();
  });

  group('AbsenceBloc', () {
    blocTest<AbsenceBloc, AbsenceState>(
      'emits [Loading, Loaded] when LoadAbsences is added',
      build: () {
        when(() => repository.fetchAbsences())
            .thenAnswer((_) async => [mockAbsence]);

        return bloc;
      },
      act: (bloc) => bloc.add(const LoadAbsences(page: 0)),
      expect: () => [
        AbsenceLoading(),
        AbsenceLoaded(
          currentPageAbsences: [mockAbsence],
          currentPage: 0,
          totalPages: 1,
          totalItems: 1,
          fromIndex: 0,
          toIndex: 1,
        )
      ],
    );

    blocTest<AbsenceBloc, AbsenceState>(
      'emits [Loading, Error] when repository throws exception',
      build: () {
        when(() => repository.fetchAbsences())
            .thenThrow(Exception('Failed to load'));

        return bloc;
      },
      act: (bloc) => bloc.add(const LoadAbsences(page: 1)),
      expect: () => [
        AbsenceLoading(),
        isA<AbsenceError>(),
      ],
    );
  });
}
