import 'package:employee_leave_manager/models/member.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Member Model', () {
    test('fromJson creates Member from full JSON', () {
      final json = {
        'crewId': 1,
        'id': 10,
        'image': 'https://example.com/image.png',
        'name': 'Alice',
        'userId': 42,
      };

      final member = Member.fromJson(json);

      expect(member.crewId, 1);
      expect(member.id, 10);
      expect(member.image, 'https://example.com/image.png');
      expect(member.name, 'Alice');
      expect(member.userId, 42);
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'crewId': 2,
        'id': 20,
        'userId': 84,
      };

      final member = Member.fromJson(json);

      expect(member.crewId, 2);
      expect(member.id, 20);
      expect(member.image, '');
      expect(member.name, '');
      expect(member.userId, 84);
    });

    test('empty factory returns default values', () {
      final member = Member.empty();

      expect(member.crewId, 0);
      expect(member.id, 0);
      expect(member.image, '');
      expect(member.name, 'Unknown');
      expect(member.userId, 0);
    });
  });
}
