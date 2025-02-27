import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/components/break_page.dart';
import 'package:todo_app/components/maps_demo.dart';
import 'package:todo_app/components/profile_page.dart';
import 'package:todo_app/components/splash_screen.dart';
import 'package:todo_app/controllers/controller.dart';
import 'package:todo_app/controllers/deviceStatusController.dart';
import 'package:todo_app/controllers/logout_controller.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/language_control/translate.dart';
import 'package:todo_app/reusable_widgets/app_colors.dart';
import 'package:todo_app/reusable_widgets/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotificationService().initNotifications();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var get_Token = prefs.getString('token');
  runApp(MyApp(
    getToken: get_Token,
  ));
}

class MyApp extends StatefulWidget {
  final getToken;
  MyApp({required this.getToken});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = Locale('en', 'US');
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var savedLocale = prefs.getString('savedLang');
    setState(() {
      _locale = _getLocale(savedLocale);
      isLoading = false;
    });
  }

  Locale _getLocale(String? savedLocale) {
    if (savedLocale == 'hi_IN') {
      return Locale('hi', 'IN');
    } else if (savedLocale == 'ar_AE') {
      return Locale('ar', 'AE');
    } else {
      return Locale('en', 'US');
    }
  }

  void updateLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : GetMaterialApp(
            translations: Translate(),
            locale: _locale,
            fallbackLocale: Locale('en', 'US'),
            theme: ThemeData(primarySwatch: Colors.green),
            darkTheme: ThemeData.dark(),
            themeMode: _themeMode,
            home: MapsDemo(),
            // home: ProfilePage(),
          );
  }
}

class HomePage extends StatefulWidget {
  // final toggleTheme;
  const HomePage({
    super.key,
    //  this.toggleTheme
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LogoutController logoutControl = Get.put(LogoutController());
  Controller reportControl = Get.put(Controller());
  DeviceStatusController deviceInfoControl = Get.put(DeviceStatusController());
  List<Map> list = [
    {'name': 'Eng', 'language': Locale('en', 'US')},
    {'name': 'Hin', 'language': Locale('hi', 'IN')},
    {'name': 'Arb', 'language': Locale('ar', 'AE')},
  ];
  String? selectedButton;
  String _lastMessage = '';

  @override
  void initState() {
    super.initState();
    PushNotificationService.messageStreamController.listen((message) {
      setState(() {
        if (message.notification != null) {
          _lastMessage = 'Received a notification message:'
              '\nTitle=${message.notification?.title},'
              '\nBody=${message.notification?.body},'
              '\nData=${message.data}';
        } else {
          _lastMessage = 'Received a data message: ${message.data}';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 24,
                    child: Image.asset('assets/images/human.png'),
                  ),
                  SizedBox(width: 12),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Hello'.tr,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Test User...'.tr,
                          style: TextStyle(
                              // color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      ]),
                ],
              ),
              DropdownButton(
                value: Get.locale ?? Locale('en', 'US'),
                onChanged: (Locale? newValue) async {
                  if (newValue != null) {
                    Get.updateLocale(newValue);

                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('savedLang', newValue.toString());

                    final myAppState =
                        context.findAncestorStateOfType<_MyAppState>();
                    if (myAppState != null) {
                      myAppState.updateLocale(newValue);
                    }
                  }
                },
                items: list.map<DropdownMenuItem<Locale>>((lang) {
                  return DropdownMenuItem(
                    value: lang['language'],
                    child: Text(lang['name']),
                  );
                }).toList(),
              ),

              InkWell(
                child: Image.asset(
                  'assets/images/user.png',
                  width: 35,
                  height: 35,
                ),
                onTap: () {
                  Get.to(ProfilePage());
                },
              )
            ]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: reportControl.reportButtons
                  .map((button) => GestureDetector(
                        onTap: () {
                          if (button['id'] != 2) {
                            reportControl.focusTextField(context);
                            selectedButton = button['type'];
                          } else {
                            selectedButton = null;
                            Get.to(BreakPage());
                          }
                          // controller
                          //     .updateReport(controller.reportController.text);
                          print("${button['type']} Clicked");
                          // controller.selectedId = button['id'];
                          setState(() {});
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.32,
                          height: 100,
                          decoration: BoxDecoration(
                            color: button['background_color'],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(button['icon'],
                                  size: 40, color: Colors.white),
                              SizedBox(height: 8),
                              Text(button['type'.tr],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
            // Text('Last message from Firebase Messaging:',
            //     style: Theme.of(context).textTheme.titleLarge),
            Text(_lastMessage, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
      bottomNavigationBar: selectedButton == null
          ? SizedBox.shrink()
          : Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Form(
                        child: TextFormField(
                          // maxLines: 2,
                          focusNode: reportControl.focusNode,
                          controller: reportControl.reportController,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter Your Text Here..',
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.grey),
                            contentPadding: EdgeInsets.all(20),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(10),
                      child: IconButton(
                          onPressed: () {
                            // print(jsonEncode(deviceInfoControl.infoObject));
                            // print('------------------------------');
                            reportControl.sendReport(selectedButton);
                          },
                          icon: Icon(Icons.send_rounded,
                              size: 32, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}


//Google login
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:todo_app/components/login_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//       options: FirebaseOptions(
//           apiKey: 'AIzaSyA00GblfOFwWRyqAJpCP2ZVV6RnLQLrPC8',
//           appId: '1:453273668889:android:b5821f2cbad940dabfc988',
//           messagingSenderId: '453273668889',
//           projectId: 'attendance-app-1833b'));
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Todo App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.green),
//       home: SignInScreen(),
//     );
//   }
// }

// class SignInScreen extends StatefulWidget {
//   @override
//   _SignInScreenState createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   Future<void> signInWithGoogle() async {
//     try {
//       final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
//       final GoogleSignInAccount? googleSignInAccount =
//           await googleSignIn.signIn();

//       if (googleSignInAccount == null) {
//         print("User canceled the sign-in");
//         return;
//       }
//       print(googleSignInAccount);
//       // final GoogleSignInAuthentication googleSignInAuthentication =
//       //     await googleSignInAccount.authentication;

//       // final AuthCredential authCredential = GoogleAuthProvider.credential(
//       //   idToken: googleSignInAuthentication.idToken,
//       //   accessToken: googleSignInAuthentication.accessToken,
//       // );

//       // UserCredential result = await auth.signInWithCredential(authCredential);
//       // User? user = result.user;

//       // if (user != null) {
//       // Navigator.pushReplacement(
//       //   context,
//       //   MaterialPageRoute(builder: (context) => LogInPage()),
//       // );
//       // } else {
//       //   print("Sign-in failed: User is null.");
//       // }
//     } catch (e) {
//       print("Error signing in with Google: $e");
//       if (e is FirebaseAuthException) {
//         print("Firebase Auth Error: ${e.message}");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
//         ),
//         child: Card(
//           margin: EdgeInsets.symmetric(horizontal: 30, vertical: 200),
//           elevation: 20,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: MaterialButton(
//                   color: Colors.teal[100],
//                   elevation: 10,
//                   onPressed: signInWithGoogle,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Container(
//                         height: 30.0,
//                         width: 30.0,
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: AssetImage('assets/images/google.png'),
//                             fit: BoxFit.cover,
//                           ),
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       SizedBox(width: 20),
//                       Text("Sign In with Google"),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }