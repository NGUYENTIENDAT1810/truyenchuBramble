class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final int coins;
  final bool isPremium;
  final String? bio;
  final Map<String, dynamic>? preferences;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.role = 'USER',
    this.coins = 120,
    this.isPremium = false,
    this.bio,
    this.preferences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'USER',
      coins: json['coins'] ?? 120,
      isPremium: json['isPremium'] ?? false,
      bio: json['bio']?.toString(),
      preferences: json['preferences'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'coins': coins,
      'isPremium': isPremium,
      'bio': bio,
      'preferences': preferences,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    int? coins,
    bool? isPremium,
    String? bio,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      coins: coins ?? this.coins,
      isPremium: isPremium ?? this.isPremium,
      bio: bio ?? this.bio,
      preferences: preferences ?? this.preferences,
    );
  }
}
