import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/components/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyA00GblfOFwWRyqAJpCP2ZVV6RnLQLrPC8',
          appId: '1:453273668889:android:b5821f2cbad940dabfc988',
          messagingSenderId: '453273668889',
          projectId: 'attendance-app-1833b'));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        print("User canceled the sign-in");
        return; // User canceled login
      }
      print('**********');

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LogInPage()),
        );
      }
    } catch (e) {
      print("Error signing in: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
        ),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 200),
          elevation: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: MaterialButton(
                  color: Colors.teal[100],
                  elevation: 10,
                  onPressed: signInWithGoogle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/google.png'),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text("Sign In with Google"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:todo_app/components/break_page.dart';
// import 'package:todo_app/components/login_page.dart';
// import 'package:todo_app/controllers/controller.dart';
// import 'package:todo_app/controllers/deviceStatusController.dart';
// import 'package:todo_app/controllers/logout_controller.dart';
// import 'package:todo_app/language_control/translate.dart';
// import 'package:todo_app/reusable_widgets/app_colors.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp(
//   //   options: DefaultFirebaseOptions.currentPlatform,
//   // );
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var get_Token = await prefs.getString('token');
//   print(get_Token);
//   runApp(MyApp(getToken: get_Token));
// }

// class MyApp extends StatefulWidget {
//   final getToken;
//   MyApp({required this.getToken});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   ThemeMode _themeMode = ThemeMode.system;

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       translations: Translate(), // your translations
//       locale: Get.deviceLocale,
//       theme: ThemeData(primarySwatch: Colors.green),
//       darkTheme: ThemeData.dark(),
//       themeMode: _themeMode,
//       home: widget.getToken == null ? LogInPage() : HomePage(),
//       // (toggleTheme: toggleTheme),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   // final toggleTheme;
//   const HomePage({
//     super.key,
//     //  this.toggleTheme
//   });

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// List<Map> list = [
//   {'name': 'Eng', 'language': Locale('en', 'US')},
//   {'name': 'Hin', 'language': Locale('hi', 'IN')},
//   {'name': 'Arb', 'language': Locale('ar', 'AE')},
// ];

// class _HomePageState extends State<HomePage> {
//   LogoutController logoutControl = Get.put(LogoutController());
//   Controller reportControl = Get.put(Controller());
//   DeviceStatusController deviceInfoControl = Get.put(DeviceStatusController());
//   String? selectedButton;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 24,
//                     child: Image.asset('assets/images/human.png'),
//                   ),
//                   SizedBox(width: 12),
//                   Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           'Hello'.tr,
//                           style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600),
//                         ),
//                         Text(
//                           'Test User...'.tr,
//                           style: TextStyle(
//                               // color: Colors.black87,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500),
//                         )
//                       ]),
//                 ],
//               ),

//               // Row(
//               //     spacing: 5,
//               //     children: list
//               //         .map((lang) => GestureDetector(
//               //             onTap: () {
//               //               Get.updateLocale(lang['language']);
//               //             },
//               //             child: Text(lang['name'])))
//               //         .toList()),

//               // ElevatedButton(
//               //     onPressed: () {
//               //       Get.updateLocale(Locale('hi', 'IN'));
//               //     },
//               //     child: Text('Hindi')),

//               DropdownButton(
//                 value: list.any((lang) => lang['language'] == Get.locale)
//                     ? Get.locale
//                     : Locale('en', 'US'),
//                 onChanged: (Locale? newValue) {
//                   if (newValue != null) {
//                     Get.updateLocale(newValue);
//                   }
//                 },
//                 items: list.map<DropdownMenuItem<Locale>>((lang) {
//                   return DropdownMenuItem(
//                     value: lang['language'],
//                     child: Text(lang['name']),
//                   );
//                 }).toList(),
//               ),

//               Obx(() => logoutControl.isLogoutLoading.value == false
//                   ? Text.rich(TextSpan(
//                       text: 'Logout'.tr,
//                       style: TextStyle(
//                           // color: Colors.black,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           decoration: TextDecoration.underline),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           logoutControl.logout();
//                         }))
//                   : CircularProgressIndicator())
//             ]),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: reportControl.reportButtons
//                   .map((button) => GestureDetector(
//                         onTap: () {
//                           if (button['id'] != 2) {
//                             reportControl.focusTextField(context);
//                             selectedButton = button['type'];
//                           } else {
//                             selectedButton = null;
//                             Get.to(BreakPage());
//                           }
//                           // controller
//                           //     .updateReport(controller.reportController.text);
//                           print("${button['type']} Clicked");
//                           // controller.selectedId = button['id'];

//                           setState(() {});
//                         },
//                         child: Container(
//                           width: MediaQuery.of(context).size.width * 0.32,
//                           height: 100,
//                           decoration: BoxDecoration(
//                             color: button['background_color'],
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(button['icon'],
//                                   size: 40, color: Colors.white),
//                               SizedBox(height: 8),
//                               Text(button['type'.tr],
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white)),
//                             ],
//                           ),
//                         ),
//                       ))
//                   .toList(),
//             ),
//             TextButton(
//               onPressed: () async {
//                 print('###########################');
//                 deviceInfoControl.getDeviceInfo();
//                 await deviceInfoControl.getCurrentLocation();
//                 deviceInfoControl.getNetworkInfo();
//               },
//               child: Text(
//                   "Latitude = ${deviceInfoControl.currentLocation?.latitude} ; Longitude = ${deviceInfoControl.currentLocation?.longitude}; ${deviceInfoControl.infoObject['wifi_name']}"),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: selectedButton == null
//           ? SizedBox.shrink()
//           : Padding(
//               padding: MediaQuery.of(context).viewInsets,
//               child: Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Form(
//                         child: TextFormField(
//                           // maxLines: 2,
//                           focusNode: reportControl.focusNode,
//                           controller: reportControl.reportController,
//                           onTapOutside: (event) {
//                             FocusManager.instance.primaryFocus?.unfocus();
//                           },
//                           decoration: InputDecoration(
//                             hintText: 'Enter Your Text Here..',
//                             hintStyle:
//                                 TextStyle(fontSize: 16, color: Colors.grey),
//                             contentPadding: EdgeInsets.all(20),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Theme.of(context).colorScheme.primary,
//                                   width: 1),
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Theme.of(context).colorScheme.primary,
//                                   width: 1),
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: AppColors.lightBlue,
//                         shape: BoxShape.circle,
//                       ),
//                       padding: EdgeInsets.all(10),
//                       child: IconButton(
//                           onPressed: () {
//                             // print(jsonEncode(deviceInfoControl.infoObject));
//                             // print('------------------------------');
//                             reportControl.sendReport(selectedButton);
//                           },
//                           icon: Icon(Icons.send_rounded,
//                               size: 32, color: Colors.white)),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
