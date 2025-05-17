import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/absence.dart';
import '../models/member.dart';
import 'absence_repository.dart';

const absencesPath = 'assets/mock_data/absences.json';
const membersPath = 'assets/mock_data/members.json';

/// Mock implementation of AbsenceRepository. This class simulates fetching the data from local JSON files.
class MockAbsenceRepository implements AbsenceRepository {
  @override
  Future<List<Absence>> fetchAbsences() async {
    try {
      final absencesData = await _loadMockJson(absencesPath);
      final members = await fetchMembers();

      return (absencesData['payload'] as List).map((json) {
        final userId = json['userId'];
        final member = members.firstWhere(
          (m) => m.userId == userId,
          orElse: () => Member.empty(),
        );
        return Absence.fromJson(json, member);
      }).toList();
    } catch (e) {
      debugPrint('Mock repository error: $e');
      rethrow;
    }
  }

  @override
  Future<List<Member>> fetchMembers() async {
    try {
      final membersData = await _loadMockJson(membersPath);
      return (membersData['payload'] as List)
          .map((json) => Member.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Mock repository error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _loadMockJson(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString) as Map<String, dynamic>;
  }
}
