import 'package:get/get.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  final Rx<UserModel> user = UserModel(id: '', name: '', email: '', phone: '', role: ''

  ).obs;

  void updateUser(UserModel updatedUser) {
    user.value = updatedUser;
  }
}