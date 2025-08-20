import 'package:get/get.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  final Rx<UserModel> user = UserModel(
    name: 'Aravind',
    email: 'aravind@example.com',
    phone: '+91 9876543210',
  ).obs;

  void updateUser(UserModel updatedUser) {
    user.value = updatedUser;
  }
}