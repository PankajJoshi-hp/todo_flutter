import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/features_fake_apis/models/single_user_model.dart';
import 'package:todo_app/features_fake_apis/repositories/get_single_user.dart';
import 'package:todo_app/features_fake_apis/repositories/update_user.dart';

class SingleUserViewModal extends GetxController {
  final GetSingleUser getUser = GetSingleUser();
  final UpdateUser userRepository = UpdateUser(); 

  final Rx<SingleUserModel?> _user = Rx<SingleUserModel?>(null);
  SingleUserModel? get user => _user.value;

  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> fetchSingleUser(int? userId) async {
    isLoading.value = true;
    try {
      final fetchedUser = await getUser.getSingleUser(userId);
      _user.value = fetchedUser;

      nameController.text = fetchedUser.name ?? '';
      emailController.text = fetchedUser.email ?? '';
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
    isLoading.value = false;
  }

  void toggleEditState() {
    isEditing.value = !isEditing.value;
  }

  Future<void> updateUser(int? userId) async {
    if (userId == null || _user.value == null) return;

    final String newName = nameController.text;

    try {
      final response = await userRepository.updateUser(userId, {"name": newName});
      print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
      print(response.statusCode);

      if (response.statusCode == 200) {
        _user.value = SingleUserModel(
          id: _user.value!.id,
          name: newName,
          email: _user.value!.email,
          avatar: _user.value!.avatar,
          role: _user.value!.role,
        );
        toggleEditState();
      } else {
        Get.snackbar("Error", "Failed to update user",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
