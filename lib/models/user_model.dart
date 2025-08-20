class UserModel {
  String name;
  String email;
  String phone;
  DateTime? dateOfBirth;
  String? gender;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    this.dateOfBirth,
    this.gender,
  });
}