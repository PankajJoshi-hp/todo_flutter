import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/components/edit_profile.dart';
import 'package:todo_app/components/login_page.dart';
import 'package:todo_app/controllers/logout_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  LogoutController logoutControl = Get.put(LogoutController());

  List<Map> profileOptions = [
    {'icon': Icons.language, 'name': 'Language'},
    {'icon': Icons.logout, 'name': 'Logout'},
  ];

  void handleLogout() {
    logoutControl.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 60),
          child: Text(
            'Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: <Widget>[
            Container(
              height: MediaQuery.sizeOf(context).height * 0.14,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0XFFCCCCCC),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10.0), // Uniform radius
              ),
              // color: Colors.grey[200],
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.35,
                    height: MediaQuery.sizeOf(context).height * 0.2,
                    padding: EdgeInsets.only(left: 10, right: 30),
                    child: Image.asset('assets/images/user.png'),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Test User',
                        style: TextStyle(
                            fontSize: MediaQuery.sizeOf(context).height * 0.024),
                      ),
                      Text.rich(
                        TextSpan(
                            text: 'Edit Profile',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(EditProfile());
                              }),
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      )
                    ],
                  ))
                ],
              ),
            ),
            Column(
                children: profileOptions
                    .map((option) => Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: InkWell(
                            onTap: () {
                              if (option['name'] == 'Logout') {
                                logoutControl.logout();
                              } else {
                                return;
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 10,
                                    children: <Widget>[
                                      Icon(
                                        option['icon'],
                                        size: 28,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                      Text(option['name'],
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black)),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_right,
                                  size: 28,
                                )
                              ],
                            ),
                          ),
                        ))
                    .toList())
          ],
        ),
      )),
    );
  }
}
