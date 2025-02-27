import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditPageController extends GetxController {
  var selectedDate = Rxn<DateTime>();

  Future<void> selectDate(context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2100));
    if (pickedDate != null && pickedDate != selectedDate) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      selectedDate.value = pickedDate;
    } else {}
  }

  String get formattedDate => selectedDate.value != null
      ? DateFormat('yyyy-MM-dd').format(selectedDate.value!)
      : 'yyyy-mm-dd';
}
