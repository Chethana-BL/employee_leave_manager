import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/absence.dart';
import '../models/member.dart';

const absencesPath = 'assets/mock_data/absences.json';
const membersPath = 'assets/mock_data/members.json';

/// AbsenceRepository: currently responsible for fetching absence data from a local JSON file.
/// TODO: Replace with actual API calls in the future.

class AbsenceRepository {
  AbsenceRepository();

  Future<List<Absence>> fetchAbsences() async {
    try {
      final absencesData = await _loadMockJson(absencesPath);

      final members = await fetchMembers();

      final absences = (absencesData['payload'] as List).map((json) {
        final userId = json['userId'];
        final member = members.firstWhere(
          (m) => m.userId == userId,
          orElse: () => Member.empty(),
        );
        return Absence.fromJson(json, member);
      }).toList();

      return absences;
    } catch (e) {
      debugPrint('Repository error: $e');
      rethrow;
    }
  }

  Future<List<Member>> fetchMembers() async {
    try {
      final membersData = await _loadMockJson(membersPath);

      return (membersData['payload'] as List)
          .map((json) => Member.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Repository error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _loadMockJson(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString) as Map<String, dynamic>;
  }
}
