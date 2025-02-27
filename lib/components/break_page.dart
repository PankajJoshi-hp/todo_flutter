import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/break_controller.dart';
import 'package:todo_app/reusable_widgets/app_colors.dart';

class BreakPage extends StatefulWidget {
  const BreakPage({super.key});

  @override
  State<BreakPage> createState() => _BreakPageState();
}

class _BreakPageState extends State<BreakPage> {
  final BreakController breakControl = Get.put(BreakController());
  bool isStarted = false;
  String breaksId = '';

  @override
  void initState() {
    super.initState();

    breakControl.getBreak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.red,
          title: Text(
            'Break'.toUpperCase(),
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
            child: Obx(() => Column(
                  children: [
                    !breakControl.isBreakLoading.value
                        ? Column(
                            children: breakControl.breaks
                                .map((breaks) => Container(
                                      child: Card(
                                          child: ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              breaks['name'].toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  // color: Colors.black87,
                                                  fontWeight: FontWeight.w500),
                                              // style: TextStyle(color: Colors.white),
                                            ),
                                            Text(
                                              'Duration: ${breaks['duration']} min',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            )
                                          ],
                                        ),
                                        trailing: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor: breaksId !=
                                                        breaks['_id']
                                                    ? WidgetStatePropertyAll(
                                                        AppColors.lightGreen)
                                                    : WidgetStatePropertyAll(
                                                        AppColors.red),
                                                shape: WidgetStatePropertyAll(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7)))),
                                            onPressed: () {
                                              if (breaksId == breaks['_id']) {
                                                breaksId = '';
                                              } else {
                                                breaksId = breaks['_id'];
                                              }
                                              setState(() {
                                                print(breaks['_id']);
                                                isStarted = !isStarted;
                                              });
                                            },
                                            child: Text(
                                              breaksId == breaks['_id']
                                                  ? 'End'
                                                  : 'Start',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            )),
                                        minLeadingWidth: double.infinity,
                                      )),
                                    ))
                                .toList())
                        : Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator()),
                  ],
                ))));
  }
}
