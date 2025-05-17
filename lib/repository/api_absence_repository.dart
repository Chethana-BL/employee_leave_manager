import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/absence.dart';
import '../models/member.dart';
import 'absence_repository.dart';

/// Implementation of AbsenceRepository that fetches data from an API.
class ApiAbsenceRepository implements AbsenceRepository {
  ApiAbsenceRepository({required this.baseUrl});
  final String baseUrl;

  @override
  Future<List<Absence>> fetchAbsences() async {
    final absencesUrl = Uri.parse('$baseUrl/absences');
    final members = await fetchMembers();

    final response = await http.get(absencesUrl);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final absencesJson = data['payload'] as List;

      return absencesJson.map((json) {
        final userId = json['userId'];
        final member = members.firstWhere(
          (m) => m.userId == userId,
          orElse: () => Member.empty(),
        );
        return Absence.fromJson(json, member);
      }).toList();
    } else {
      throw Exception('Failed to load absences: ${response.statusCode}');
    }
  }

  @override
  Future<List<Member>> fetchMembers() async {
    final membersUrl = Uri.parse('$baseUrl/members');
    final response = await http.get(membersUrl);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final membersJson = data['payload'] as List;

      return membersJson.map((json) => Member.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load members: ${response.statusCode}');
    }
  }
}
