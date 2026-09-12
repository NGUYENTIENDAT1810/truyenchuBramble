class UserModel {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String role;
  final int coins;
  final bool isPremium;
  final bool isVip;
  final String? bio;
  final Map<String, dynamic>? preferences;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.role = 'USER',
    this.coins = 120,
    this.isPremium = false,
    bool? isVip,
    this.bio,
    this.preferences,
  }) : isVip = isVip ?? isPremium;

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'email':
        return email;
      case 'name':
      case 'displayName':
        return name;
      case 'avatarUrl':
        return avatarUrl;
      case 'role':
        return role;
      case 'coins':
        return coins;
      case 'isPremium':
        return isPremium;
      case 'isVip':
        return isVip;
      case 'bio':
        return bio;
      case 'preferences':
        return preferences;
      default:
        return null;
    }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final vip = json['isVip'] as bool? ?? json['isPremium'] as bool? ?? false;
    return UserModel(
      id: (json['id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      name: (json['displayName'] ?? json['name'] ?? '').toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      role: (json['role'] ?? 'USER').toString(),
      coins: (json['coins'] as num?)?.toInt() ?? 120,
      isPremium: vip,
      isVip: vip,
      bio: json['bio']?.toString(),
      preferences: json['preferences'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'displayName': name,
      'avatarUrl': avatarUrl,
      'role': role,
      'coins': coins,
      'isPremium': isPremium,
      'isVip': isVip,
      'bio': bio,
      'preferences': preferences,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    String? role,
    int? coins,
    bool? isPremium,
    bool? isVip,
    String? bio,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      coins: coins ?? this.coins,
      isPremium: isPremium ?? this.isPremium,
      isVip: isVip ?? this.isVip,
      bio: bio ?? this.bio,
      preferences: preferences ?? this.preferences,
    );
  }
}
