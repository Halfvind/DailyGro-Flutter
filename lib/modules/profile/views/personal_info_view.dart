import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../controllers/user_controller.dart';
import '../../../models/user_model.dart';

class PersonalInfoView extends GetView<UserController> {
  const PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final genderController = RxString('');
    final selectedDate = Rxn<DateTime>();

    // Initialize with current user data
    nameController.text = controller.user.value.name;
    emailController.text = controller.user.value.email;
    phoneController.text = controller.user.value.phone;
    genderController.value = controller.user.value.gender ?? '';
    selectedDate.value = controller.user.value.dateOfBirth;

    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.width(16)),
        child: Column(
          children: [
            _buildTextField(
              controller: nameController,
              label: 'Full Name',
              icon: Icons.person_outline,
            ),
            SizedBox(height: AppSizes.height(16)),
            _buildTextField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: AppSizes.height(16)),
            _buildTextField(
              controller: phoneController,
              label: 'Phone Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: AppSizes.height(16)),
            
            // Date of Birth
            Obx(() => GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate.value ?? DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (date != null) selectedDate.value = date;
              },
              child: Container(
                padding: EdgeInsets.all(AppSizes.width(16)),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, color: Colors.grey[600]),
                    SizedBox(width: AppSizes.width(12)),
                    Text(
                      selectedDate.value != null
                          ? '${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}'
                          : 'Date of Birth',
                      style: TextStyle(
                        fontSize: AppSizes.fontL,
                        color: selectedDate.value != null ? Colors.black : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            )),
            
            SizedBox(height: AppSizes.height(16)),
            
            // Gender Selection
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: AppSizes.fontL,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: AppSizes.height(8)),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('Male'),
                        value: 'Male',
                        groupValue: genderController.value,
                        onChanged: (value) => genderController.value = value!,
                        activeColor: Colors.green,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('Female'),
                        value: 'Female',
                        groupValue: genderController.value,
                        onChanged: (value) => genderController.value = value!,
                        activeColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            )),
            
            SizedBox(height: AppSizes.height(32)),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final updatedUser = UserModel(
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    dateOfBirth: selectedDate.value,
                    gender: genderController.value.isEmpty ? null : genderController.value,
                  );
                  
                  controller.updateUser(updatedUser);
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Personal information updated successfully',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: AppSizes.height(16)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                  ),
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: AppSizes.fontL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius(8)),
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
    );
  }
}