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
    'daily_target_minutes': dailyTargetMinutes,
    'created_at': createdAt.toIso8601String(),
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'] as String,
    name: map['name'] as String,
    email: map['email'] as String,
    dailyTargetMinutes: map['daily_target_minutes'] as int? ?? 15,
    createdAt: DateTime.parse(map['created_at'] as String),
  );

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? dailyTargetMinutes,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      dailyTargetMinutes: dailyTargetMinutes ?? this.dailyTargetMinutes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
