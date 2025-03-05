import 'dart:convert';

import 'package:todo_app/features_fake_apis/models/users.dart';
import 'package:todo_app/features_fake_apis/services/fake_users_api.dart';

class GetAllUsers {
  final ApiServices apiService = ApiServices();

  Future<List<Users>> getAllUsers() async {
    String url = 'https://api.escuelajs.co/api/v1/users';
    final response = await apiService.fetchUsers(url);
    print('***************************');
    print('response status code: ${response.statusCode}');
    print(response.body);

    if (response.statusCode == 200) {
      return List<Users>.from(
          json.decode(response.body).map((user) => Users.fromJson(user)));
    } else {
      throw Exception('Failed to load Users');
    }
  }
}
