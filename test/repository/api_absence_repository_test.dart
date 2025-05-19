import 'package:employee_leave_manager/models/absence.dart';
import 'package:employee_leave_manager/models/absence_type.dart';
import 'package:employee_leave_manager/models/member.dart';
import 'package:employee_leave_manager/repository/api_absence_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  const baseUrl = 'http://example.com';

  // Sample JSON payloads
  const membersJson = '''
  {
    "payload": [
      {
        "crewId": 1,
        "id": 1,
        "image": "image_url",
        "name": "John Doe",
        "userId": 101
      }
    ]
  }
  ''';

  const absencesJson = '''
  {
    "payload": [
      {
        "id": 1,
        "userId": 101,
        "type": "vacation",
        "status": "confirmed",
        "startDate": "2023-01-01",
        "endDate": "2023-01-05"
      }
    ]
  }
  ''';

  group('ApiAbsenceRepository', () {
    test('fetchMembers returns list of Members when http response is 200',
        () async {
      // Mock HTTP client returns membersJson when URL ends with /members
      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/members')) {
          return http.Response(membersJson, 200);
        } else if (request.url.path.endsWith('/absences')) {
          return http.Response(absencesJson, 200);
        }
        return http.Response('Not Found', 404);
      });
      final repo = ApiAbsenceRepository(baseUrl: baseUrl, client: mockClient);

      final members = await repo.fetchMembers();

      expect(members, isA<List<Member>>());
      expect(members.length, 1);
      expect(members.first.name, 'John Doe');
    });

    test('fetchMembers throws on non-200 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 500);
      });

      final repo = ApiAbsenceRepository(baseUrl: baseUrl, client: mockClient);

      expect(() => repo.fetchMembers(), throwsException);
    });

    test('fetchAbsences returns list of Absences on 200 response', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/members')) {
          return http.Response(membersJson, 200);
        } else if (request.url.path.endsWith('/absences')) {
          return http.Response(absencesJson, 200);
        }
        return http.Response('Not Found', 404);
      });

      final repo = ApiAbsenceRepository(baseUrl: baseUrl, client: mockClient);

      final absences = await repo.fetchAbsences();

      expect(absences, isA<List<Absence>>());
      expect(absences.length, 1);
      expect(absences.first.type.label.toLowerCase(), 'vacation');
    });

    test('fetchAbsences throws on non-200 response', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/members')) {
          return http.Response(membersJson, 200);
        } else if (request.url.path.endsWith('/absences')) {
          return http.Response('Error', 500);
        }
        return http.Response('Not Found', 404);
      });

      final repo = ApiAbsenceRepository(baseUrl: baseUrl, client: mockClient);

      expect(() => repo.fetchAbsences(), throwsException);
    });
  });
}
