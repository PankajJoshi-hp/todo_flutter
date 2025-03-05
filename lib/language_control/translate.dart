import 'package:get/get.dart';
import 'package:todo_app/language_control/arabic_lang.dart';
import 'package:todo_app/language_control/english_lang.dart';
import 'package:todo_app/language_control/hindi_lang.dart';

class Translate extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': EnglishLang.values,
        'hi_IN': HindiLang.values,
        'ar_AE': ArabicLang.values
      };
}
