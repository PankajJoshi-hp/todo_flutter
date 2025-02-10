import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/components/login_page.dart';
import 'package:todo_app/main.dart';

class LoginController extends GetxController {
  final String apiUrl = 'https://hpcrm.apinext.in/api/v1/login';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoggedIn = false;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login(context) async {
    print(emailController.text);
    print(passwordController.text);
    try {
      final response = await http.post(Uri.parse(apiUrl),
          body: jsonEncode({
            'email': emailController.text,
            'password': passwordController.text
          }),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        emailController.clear();
        passwordController.clear();
        Get.to(HomePage());
        isLoggedIn = true;
        print(data['token']);
        Fluttertoast.showToast(
            msg: 'Logged In successfully',
            backgroundColor: Colors.lightGreen,
            fontSize: 22);
      } else {
        Fluttertoast.showToast(
            msg: 'Error logging in', backgroundColor: Colors.red, fontSize: 22);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      isLoggedIn = false;
      isLoading = true;
      await Future.delayed(Duration(seconds: 2));
      isLoading = false;
      Get.offAll(LogInPage());
      Fluttertoast.showToast(
          msg: 'Logged out successfully',
          backgroundColor: Colors.lightGreen,
          fontSize: 22);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Error in logging out user',
          backgroundColor: Colors.red,
          fontSize: 22);
    }
  }
}
