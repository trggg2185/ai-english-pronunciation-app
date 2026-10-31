class UserModel {
  final String id;
  final String name;
  final String email;
  final int dailyTargetMinutes; // Mục tiêu học tập hàng ngày (phút)
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.dailyTargetMinutes = 15,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'dailyTargetMinutes': dailyTargetMinutes,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] as String,
        name: map['name'] as String,
        email: map['email'] as String,
        dailyTargetMinutes: (map['dailyTargetMinutes'] as num?)?.toInt() ?? 15,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}

