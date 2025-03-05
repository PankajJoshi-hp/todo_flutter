import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/features_fake_apis/models/users.dart';
import 'package:todo_app/features_fake_apis/view/single_user_page.dart';
import 'package:todo_app/features_fake_apis/view_modal/users_view_model.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({super.key});

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  final UsersViewModel controller = Get.put(UsersViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('All Users Page'),
        ),
        body: Obx(() {
          if (controller.fetchingData.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (controller.users.isEmpty) {
            return Center(
              child: Text('No Users Found'),
            );
          }

          return ListView.builder(
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              return ListCard(user: controller.users[index]);
            },
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.fetchAllUsers();
            print('User is: ${controller.users[10].id}');
          },
          child: const Icon(Icons.refresh),
        ));
  }
}

class ListCard extends StatelessWidget {
  const ListCard({super.key, required this.user});
  final Users user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
        print(user.id);
        Get.to(SingleUserPage(userId: user.id));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.lightBlue.shade50,
              borderRadius: BorderRadius.circular(16)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    user.avatar ?? '',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, staceTree) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 100,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.name ?? '',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            user.email ?? "",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
