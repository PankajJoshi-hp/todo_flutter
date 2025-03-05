import 'package:get/get.dart';
import 'package:todo_app/features_fake_apis/models/users.dart';
import 'package:todo_app/features_fake_apis/repositories/get_all_users.dart';

class UsersViewModel extends GetxController {
  final GetAllUsers getAllUsers = GetAllUsers();
  final RxList<Users> _users = <Users>[].obs;
  RxBool fetchingData = false.obs;

  List<Users> get users => _users;

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    
    fetchingData.value = true;
    try {
      final allFetchedUsers = await getAllUsers.getAllUsers();
      _users.assignAll(allFetchedUsers);
    } catch (e) {
      throw Exception('Failed to load Users: $e');
    }
    fetchingData.value = false;
  }
}
