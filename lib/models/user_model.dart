class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? address;
  final DateTime? createdAt;
  final String? userId;
  final String? profileId;
  DateTime? dateOfBirth;
  String? gender;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.address,
    this.createdAt,
    this.userId,
    this.profileId,
    this.dateOfBirth,
    this.gender,
  });

  factory UserModel.fromLoginResponse(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final user = data['user'] ?? {};
    final profile = data['profile'] ?? {};
    
    return UserModel(
      id: user['id']?.toString() ?? '',
      name: user['name'] ?? '',
      email: user['email'] ?? '',
      phone: user['phone'] ?? '',
      role: user['role'] ?? '',
      address: profile['address']?.toString(),
      createdAt: user['created_at'] != null 
          ? DateTime.tryParse(user['created_at']) 
          : null,
      userId: profile['user_id']?.toString(),
      profileId: profile['id']?.toString(),
      dateOfBirth: profile['date_of_birth'] != null 
          ? DateTime.tryParse(profile['date_of_birth']) 
          : null,
      gender: profile['gender']?.toString(),
    );
  }

  factory UserModel.fromProfileResponse(Map<String, dynamic> json) {
    final userProfile = json['user_profile'] ?? {};
    
    return UserModel(
      id: userProfile['id']?.toString() ?? '',
      name: userProfile['name'] ?? '',
      email: userProfile['email'] ?? '',
      phone: userProfile['phone'] ?? '',
      role: userProfile['role'] ?? '',
      address: userProfile['address']?.toString(),
      createdAt: userProfile['created_at'] != null 
          ? DateTime.tryParse(userProfile['created_at']) 
          : null,
      userId: userProfile['user_id']?.toString(),
      profileId: userProfile['profile_id']?.toString(),
      dateOfBirth: userProfile['date_of_birth'] != null 
          ? DateTime.tryParse(userProfile['date_of_birth']) 
          : null,
      gender: userProfile['gender']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'address': address,
      'created_at': createdAt?.toIso8601String(),
      'user_id': userId,
      'profile_id': profileId,
    };
  }
}