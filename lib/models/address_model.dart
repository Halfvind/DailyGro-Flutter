class AddressModel {
  final String id;
  String title;
  String fullName;
  String phone;
  String addressLine1;
  String addressLine2;
  String city;
  String state;
  String pincode;
  bool isDefault;

  AddressModel({
    required this.id,
    required this.title,
    required this.fullName,
    required this.phone,
    required this.addressLine1,
    this.addressLine2 = '',
    required this.city,
    required this.state,
    required this.pincode,
    this.isDefault = false,
  });
}