class UserProfile {
  const UserProfile({required this.id, required this.role, required this.email});

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    role: json['role'] as String,
    email: json['email'] as String,
  );

  final String id;
  final String role;
  final String email;

  Map<String, dynamic> toJson() => {'id': id, 'role': role, 'email': email};

  @override
  String toString() => 'UserProfile($email, role: $role)';
}
