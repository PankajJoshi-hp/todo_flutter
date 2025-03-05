// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:todo_app/components/login_page.dart';
// import 'package:todo_app/controllers/controller.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:todo_app/controllers/login_controller.dart';
// import 'package:todo_app/controllers/logout_controller.dart';
// import 'package:todo_app/controllers/signup_controller.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final Controller todos = Get.find<Controller>();
//   final SignupController signupControl = Get.put(SignupController());
//   final LogoutController logoutControl = Get.put(LogoutController());
//   final LoginController loginControl = Get.put(LoginController());

//   // FToast? fToast;

//   openDialogBox(context, todo, isUpdate) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) => Dialog(
//               child: Padding(
//                   padding: EdgeInsets.all(30),
//                   child: Form(
//                     key: todos.formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: <Widget>[
//                         TextFormField(
//                           maxLines: 3,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Text field cannot be empty';
//                             }
//                             return null;
//                           },
//                           onChanged: (value) => todos.text = value,
//                           controller: todos.textController,
//                           decoration: InputDecoration(
//                             label: Text(
//                               'Enter your task here...',
//                               style: TextStyle(color: Colors.lightGreen),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Colors.lightGreen, width: 2),
//                                 borderRadius: BorderRadius.circular(5)),
//                             enabledBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Colors.lightGreen, width: 2),
//                                 borderRadius: BorderRadius.circular(5)),
//                           ),
//                         ),
//                         TextButton(
//                             onPressed: () async {
//                               if (todos.formKey.currentState!.validate()) {
//                                 if (isUpdate == true) {
//                                   todos.updateTodo(todo.id,
//                                       todos.textController.text.trim());
//                                   Fluttertoast.showToast(
//                                       msg: "Todo updated successfully",
//                                       fontSize: 20,
//                                       backgroundColor: Colors.lightGreen,
//                                       gravity: ToastGravity.BOTTOM);
//                                 } else {
//                                   todos.setText();
//                                   Fluttertoast.showToast(
//                                       msg: "Todo updated successfully",
//                                       fontSize: 20,
//                                       backgroundColor: Colors.lightGreen,
//                                       gravity: ToastGravity.BOTTOM);
//                                 }
//                                 await todos.saveTodoList(todos.todoList);
//                                 Navigator.of(context).pop();
//                               }
//                             },
//                             style: ButtonStyle(
//                                 backgroundColor:
//                                     WidgetStatePropertyAll(Colors.lightGreen),
//                                 shape: WidgetStatePropertyAll(
//                                     RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5)))),
//                             child: Text('Submit'.toUpperCase(),
//                                 style: TextStyle(color: Colors.white)))
//                       ],
//                     ),
//                   )),
//             ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Text(
//                 "Todo".toUpperCase(),
//                 style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blueAccent),
//               ),
//               Obx(() => logoutControl.isLogoutLoading.value == false
//                   ? RichText(
//                       text: TextSpan(
//                           text: 'Logout',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               decoration: TextDecoration.underline),
//                           recognizer: TapGestureRecognizer()
//                             ..onTap = () {
//                               logoutControl.logout();
//                             }))
//                   : CircularProgressIndicator())
//             ]),
//       ),
//       body: Column(
//         children: <Widget>[
//           Container(
//             color: Colors.black,
//             height: 1,
//           ),
//           Obx(() => Expanded(
//                 child: todos.todoList.isEmpty
//                     ? Center(
//                         child: Text(
//                           'Please add some todos 🤧.',
//                           style: TextStyle(fontSize: 20, color: Colors.black87),
//                         ),
//                       )
//                     : ListView(
//                         children: todos.todoList
//                             .map((todo) => Card(
//                                 child: ListTile(
//                                     leading: Checkbox(
//                                       activeColor: Colors.lightBlue,
//                                       value: todo.isCompleted,
//                                       onChanged: (_) async {
//                                         todos.toggleTodoStatus(todo.id);
//                                         await todos
//                                             .saveTodoList(todos.todoList);
//                                       },
//                                     ),
//                                     title: todo.isCompleted == false
//                                         ? Text(
//                                             todo.title,
//                                             style: TextStyle(
//                                                 fontSize: 18,
//                                                 color: Colors.black),
//                                           )
//                                         : Text(
//                                             todo.title,
//                                             style: TextStyle(
//                                               color: Colors.red,
//                                               decoration:
//                                                   TextDecoration.lineThrough,
//                                             ),
//                                           ),
//                                     trailing: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       spacing: 5,
//                                       children: <Widget>[
//                                         todo.isCompleted == false
//                                             ? InkWell(
//                                                 onTap: () {
//                                                   todos.textController.text =
//                                                       todo.title;
//                                                   openDialogBox(
//                                                       context, todo, true);
//                                                 },
//                                                 child: Icon(Icons.edit,
//                                                     size: 24,
//                                                     color: Colors.lightBlue))
//                                             : Text(''),
//                                         InkWell(
//                                           onTap: () async {
//                                             todos.deleteTodo(todo.id);
//                                             await todos
//                                                 .saveTodoList(todos.todoList);

//                                             Fluttertoast.showToast(
//                                                 msg:
//                                                     'Todo deleted successfully',
//                                                 fontSize: 20,
//                                                 backgroundColor:
//                                                     Colors.lightGreen,
//                                                 gravity: ToastGravity.BOTTOM);
//                                           },
//                                           child: Icon(Icons.delete,
//                                               size: 24, color: Colors.red),
//                                         ),
//                                       ],
//                                     ))))
//                             .toList()),
//               )),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.lightBlue,
//         onPressed: () {
//           todos.textController.clear();
//           openDialogBox(context, null, false);
//         },
//         child: const Text(
//           '+',
//           style: TextStyle(
//               fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
//         ),
//       ),
//     );
//   }
// }

// //for main function
// // final Controller textController = Get.put(Controller());
//   // await textController.loadTodoList();


// // Controller for todo_test.dart


// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:todo_app/reusable_widgets/todo_modal.dart';

// // class Controller extends GetxController {
// //   final formKey = GlobalKey<FormState>();
// //   String text = 'No todos added';
// //   var todoList = <Todo>[].obs;
// //   final TextEditingController textController = TextEditingController();
  
  
  

   

// //   Future<void> saveTodoList(List<Todo> todoList) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     List<String> jsonStringList =
// //         todoList.map((todo) => jsonEncode(todo.toJson())).toList();
// //     await prefs.setStringList('todo_list', jsonStringList);
// //   }

// //   Future<void> loadTodoList() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     List<String>? jsonStringList = prefs.getStringList('todo_list');
// //     if (jsonStringList != null) {
// //       todoList.assignAll(jsonStringList
// //           .map((jsonString) => Todo.fromJson(jsonDecode(jsonString))));
// //     }
// //   }

 

//   // void setText() async {
//   //   String newText = textController.text.trim();
//   //   if (newText.isNotEmpty) {
//   //     todoList.add(Todo(id: DateTime.now().toString(), title: newText));
//   //     textController.clear();
//   //     await saveTodoList(todoList);
//   //   }
//   // }

//   // void updateTodo(String id, String newTitle) async {
//   //   final index = todoList.indexWhere((todo) => todo.id == id);
//   //   if (index != -1) {
//   //     todoList[index] = Todo(id: id, title: newTitle);
//   //   }
//   //   textController.clear();
//   //   await saveTodoList(todoList);
//   // }

//   // void toggleTodoStatus(
//   //   String id,
//   // ) async {
//   //   final index = todoList.indexWhere((todo) => todo.id == id);
//   //   if (index != -1) {
//   //     todoList[index] = Todo(
//   //         id: id,
//   //         title: todoList[index].title,
//   //         isCompleted: !todoList[index].isCompleted);
//   //     await saveTodoList(todoList);
//   //   }
//   // }

//   // void deleteTodo(String id) async {
//   //   todoList.removeWhere((todo) => todo.id == id);
//   //   await saveTodoList(todoList);
//   // }
// }
