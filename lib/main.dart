import 'package:animation_list/animation_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/components/maps_demo.dart';
import 'package:todo_app/components/profile_page.dart';
import 'package:todo_app/components/splash_screen.dart';
import 'package:todo_app/controllers/controller.dart';
import 'package:todo_app/controllers/deviceStatusController.dart';
import 'package:todo_app/controllers/logout_controller.dart';
import 'package:todo_app/controllers/profile_page_controller.dart';
import 'package:todo_app/features_fake_apis/view/all_users_page.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/language_control/translate.dart';
import 'package:todo_app/reusable_widgets/app_colors.dart';
import 'package:todo_app/reusable_widgets/push_notification_service.dart';
import 'package:animations/animations.dart';

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
  final ProfilePageController profileController =
      Get.put(ProfilePageController());

  @override
  void initState() {
    super.initState();
    profileController.loadLocale();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return profileController.isLoading.value
          ? MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          : GetMaterialApp(
              translations: Translate(),
              locale: profileController.locale.value,
              fallbackLocale: Locale('en', 'US'),
              theme: ThemeData(primarySwatch: Colors.green),
              darkTheme: ThemeData.dark(),
              themeMode: _themeMode,
              home: SplashScreen(),
            );
    });
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

  void openProfilePage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
      ),
    );
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
              InkWell(
                child: Image.asset(
                  'assets/images/user.png',
                  width: 35,
                  height: 35,
                ),
                onTap: () => openProfilePage(context),
              )
            ]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
            AnimationList(
              duration: 1500,
              reBounceDepth: 30,
              shrinkWrap: true,
              children: [
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
                                Navigator.of(context)
                                    .push(reportControl.createRoute());
                                // Get.to(BreakPage());
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
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(MapsDemo());
              },
              child: Text('Map page'),
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.blueGrey)),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(AllUsersPage());
              },
              child: Text('All Users'),
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.grey[100])),
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