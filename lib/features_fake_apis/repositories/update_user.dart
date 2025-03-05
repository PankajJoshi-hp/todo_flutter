import 'package:http/http.dart' as http;
import 'package:todo_app/features_fake_apis/services/fake_users_api.dart';

class UpdateUser {
  final ApiServices apiService = ApiServices();

  Future<http.Response> updateUser(
      int userId, Map<String, dynamic> body) async {
    final String url = 'https://api.escuelajs.co/api/v1/users/$userId';

    return await apiService.fetchUsers(
      url,
      method: 'PUT',
      body: body,
      headers: {'Content-Type': 'application/json'},
    );
  }
}
