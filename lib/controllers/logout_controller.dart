import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/components/login_page.dart';

class LogoutController extends GetxController {
  final String apiUrl = 'https://hpcrm.apinext.in/api/v1/logout';
  final RxBool isLogoutLoading = false.obs;

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var get_Token = await prefs.getString('token');

    isLogoutLoading.value = true;

    try {
      // await Future.delayed(Duration(seconds: 2));
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Cookie": 'token=${get_Token}', // Attach cookies
        },
      );
      // print('-------------------------');
      // print(response.body);
      // print('-------------------------');
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        Get.to(LogInPage());
      } else {
        // print('error logging out');
        Fluttertoast.showToast(
            msg: 'You have already been logged out.',
            backgroundColor: Colors.red,
            fontSize: 20);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLogoutLoading.value = false;
    }
  }

  // void _updateIsLoading(bool currentStatus) {
  //   isLoading = currentStatus;
  //   update();
  // }
}
