/// Member class represents a member of a crew.
class Member {
  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      crewId: json['crewId'],
      id: json['id'],
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      userId: json['userId'],
    );
  }

  Member({
    required this.crewId,
    required this.id,
    required this.image,
    required this.name,
    required this.userId,
  });

  final int crewId;
  final int id;
  final String image;
  final String name;
  final int userId;
}
