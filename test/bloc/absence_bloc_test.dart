import 'package:bloc_test/bloc_test.dart';
import 'package:employee_leave_manager/bloc/absence_bloc.dart';
import 'package:employee_leave_manager/bloc/absence_event.dart';
import 'package:employee_leave_manager/bloc/absence_state.dart';
import 'package:employee_leave_manager/models/absence.dart';
import 'package:employee_leave_manager/models/absence_status.dart';
import 'package:employee_leave_manager/models/absence_type.dart';
import 'package:employee_leave_manager/models/filters/absence_filter_model.dart';
import 'package:employee_leave_manager/models/member.dart';
import 'package:employee_leave_manager/repository/absence_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAbsenceRepository extends Mock implements AbsenceRepository {}

/// Extension to add a copyWith method to the Absence class for easier testing.
extension AbsenceCopyWith on Absence {
  Absence copyWith({
    int? id,
    int? userId,
    DateTime? startDate,
    DateTime? endDate,
    AbsenceType? type,
    Member? member,
    String? memberNote,
    String? admitterNote,
    DateTime? confirmedAt,
    DateTime? rejectedAt,
    AbsenceStatus? status,
  }) {
    return Absence(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      member: member ?? this.member,
      memberNote: memberNote ?? this.memberNote,
      admitterNote: admitterNote ?? this.admitterNote,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      status: status ?? this.status,
    );
  }
}

extension MemberCopyWith on Member {
  Member copyWith({
    int? id,
    int? userId,
    String? name,
    String? image,
    int? crewId,
  }) {
    return Member(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      image: image ?? this.image,
      crewId: crewId ?? this.crewId,
    );
  }
}

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
      act: (bloc) =>
          bloc.add(LoadAbsences(page: 0, filters: AbsenceFilterModel())),
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
      act: (bloc) =>
          bloc.add(LoadAbsences(page: 1, filters: AbsenceFilterModel())),
      expect: () => [
        AbsenceLoading(),
        isA<AbsenceError>(),
      ],
    );

    blocTest<AbsenceBloc, AbsenceState>(
      'emits [AbsenceLoading, AbsenceLoaded] and forces fresh fetch when forceRefresh=true',
      build: () {
        when(() => repository.fetchAbsences())
            .thenAnswer((_) async => [mockAbsence]);

        return bloc;
      },
      act: (bloc) async {
        bloc.add(LoadAbsences(page: 0, filters: AbsenceFilterModel()));
        await Future.delayed(Duration.zero);
        bloc.add(LoadAbsences(
          page: 0,
          filters: AbsenceFilterModel(),
          forceRefresh: true,
        ));
      },
      expect: () => [
        AbsenceLoading(),
        isA<AbsenceLoaded>(),
        AbsenceLoading(),
        isA<AbsenceLoaded>(),
      ],
      verify: (bloc) => verify(() => repository.fetchAbsences()).called(2),
    );
  });

  group('Absence Bloc Filter', () {
    blocTest<AbsenceBloc, AbsenceState>(
      'filters absences by type correctly',
      build: () {
        final absenceOtherType = AbsenceType.vacation;

        when(() => repository.fetchAbsences()).thenAnswer((_) async => [
              mockAbsence,
              mockAbsence.copyWith(type: absenceOtherType, id: 101),
            ]);

        return bloc;
      },
      act: (bloc) => bloc.add(LoadAbsences(
        page: 0,
        filters: AbsenceFilterModel(type: AbsenceType.sickness),
      )),
      expect: () => [
        AbsenceLoading(),
        AbsenceLoaded(
          currentPageAbsences: [mockAbsence],
          currentPage: 0,
          totalPages: 1,
          totalItems: 1,
          fromIndex: 0,
          toIndex: 1,
        ),
      ],
    );

    blocTest<AbsenceBloc, AbsenceState>(
      'filters absences by status correctly',
      build: () {
        when(() => repository.fetchAbsences()).thenAnswer((_) async => [
              mockAbsence,
              mockAbsence.copyWith(
                status: AbsenceStatus.rejected,
                id: 102,
              ),
            ]);

        return bloc;
      },
      act: (bloc) => bloc.add(LoadAbsences(
        page: 0,
        filters: AbsenceFilterModel(status: AbsenceStatus.confirmed),
      )),
      expect: () => [
        AbsenceLoading(),
        AbsenceLoaded(
          currentPageAbsences: [mockAbsence],
          currentPage: 0,
          totalPages: 1,
          totalItems: 1,
          fromIndex: 0,
          toIndex: 1,
        ),
      ],
    );

    blocTest<AbsenceBloc, AbsenceState>(
      'filters absences by employee correctly',
      build: () {
        final otherMember = mockMember.copyWith(userId: 999);

        when(() => repository.fetchAbsences()).thenAnswer((_) async => [
              mockAbsence,
              mockAbsence.copyWith(member: otherMember, id: 103),
            ]);

        return bloc;
      },
      act: (bloc) => bloc.add(LoadAbsences(
        page: 0,
        filters: AbsenceFilterModel(employee: mockMember),
      )),
      expect: () => [
        AbsenceLoading(),
        AbsenceLoaded(
          currentPageAbsences: [mockAbsence],
          currentPage: 0,
          totalPages: 1,
          totalItems: 1,
          fromIndex: 0,
          toIndex: 1,
        ),
      ],
    );

    blocTest<AbsenceBloc, AbsenceState>(
      'filters absences by date range correctly',
      build: () {
        final inRangeAbsence = mockAbsence;
        final outOfRangeAbsence = mockAbsence.copyWith(
          startDate: DateTime(2025, 1, 1),
          id: 104,
        );

        when(() => repository.fetchAbsences()).thenAnswer((_) async => [
              inRangeAbsence,
              outOfRangeAbsence,
            ]);

        return bloc;
      },
      act: (bloc) {
        final filter = AbsenceFilterModel(
          dateRange: DateTimeRange(
            start: DateTime(2024, 4, 30),
            end: DateTime(2024, 5, 2),
          ),
        );
        bloc.add(LoadAbsences(page: 0, filters: filter));
      },
      expect: () => [
        AbsenceLoading(),
        AbsenceLoaded(
          currentPageAbsences: [mockAbsence],
          currentPage: 0,
          totalPages: 1,
          totalItems: 1,
          fromIndex: 0,
          toIndex: 1,
        ),
      ],
    );
  });
  group('Absence Bloc Pagination', () {
    blocTest<AbsenceBloc, AbsenceState>(
      'paginates absences correctly when more than pageSize items',
      build: () {
        final absences = List.generate(25, (index) {
          return mockAbsence.copyWith(id: 200 + index);
        });
        when(() => repository.fetchAbsences())
            .thenAnswer((_) async => absences);

        return bloc;
      },
      act: (bloc) => bloc.add(LoadAbsences(
          page: 1,
          filters:
              AbsenceFilterModel())), // page 1, 0-indexed, so this is the 2nd page
      expect: () => [
        isA<AbsenceLoading>(),
        predicate<AbsenceLoaded>(
            (state) =>
                state.currentPageAbsences.length == 10 &&
                state.currentPage == 1 &&
                state.totalPages == 3 &&
                state.fromIndex == 10 &&
                state.toIndex == 20,
            'matches expected AbsenceLoaded values'),
      ],
    );
    blocTest<AbsenceBloc, AbsenceState>(
      'paginates absences correctly when less than pageSize items',
      build: () {
        final absences = List.generate(5, (index) {
          return mockAbsence.copyWith(id: 300 + index);
        });
        when(() => repository.fetchAbsences())
            .thenAnswer((_) async => absences);

        return bloc;
      },
      act: (bloc) => bloc.add(LoadAbsences(
          page: 0,
          filters:
              AbsenceFilterModel())), // page 0, 0-indexed, so this is the 1st page
      expect: () => [
        isA<AbsenceLoading>(),
        predicate<AbsenceLoaded>(
            (state) =>
                state.currentPageAbsences.length == 5 &&
                state.currentPage == 0 &&
                state.totalPages == 1 &&
                state.fromIndex == 0 &&
                state.toIndex == 5,
            'matches expected AbsenceLoaded values'),
      ],
    );

    blocTest<AbsenceBloc, AbsenceState>(
      'handles empty absence list correctly',
      build: () {
        when(() => repository.fetchAbsences()).thenAnswer((_) async => []);

        return bloc;
      },
      act: (bloc) => bloc.add(LoadAbsences(
          page: 0,
          filters:
              AbsenceFilterModel())), // page 0, 0-indexed, so this is the 1st page
      expect: () => [
        isA<AbsenceLoading>(),
        predicate<AbsenceLoaded>(
            (state) =>
                state.currentPageAbsences.isEmpty &&
                state.currentPage == 0 &&
                state.totalPages == 0 &&
                state.fromIndex == 0 &&
                state.toIndex == 0,
            'matches expected AbsenceLoaded values'),
      ],
    );
  });
}
