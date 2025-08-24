import 'package:evently/core/cache_helper/cache_helper.dart';
import 'package:evently/core/firebase/firebase_manager.dart';
import 'package:evently/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


class AppProvider extends ChangeNotifier {
  ThemeMode themeMode =
      CacheHelper.getTheme() == 1
          ? ThemeMode.dark
          : ThemeMode.light;
  String languageCode =
      CacheHelper.getLang() == 0
          ? "en"
          : "ar";

  int currentIndex = 0;
  int selectedCatIndex = 0;
  int selectedAddEventCatIndex = 0;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool isLoading = false;


  void changeTheme(int index) {
    themeMode = index == 0 ? ThemeMode.light : ThemeMode.dark;
    CacheHelper.saveTheme(index);
    notifyListeners();
  }

  void changeLanguage(BuildContext context, int index) {
    languageCode = index == 0 ? "en" : "ar";
    context.setLocale(Locale(languageCode));
    CacheHelper.saveLang(index);
    notifyListeners();
  }

  void swipeLanguage(BuildContext context) {
    if (languageCode == "en") {
      changeLanguage(context, 1);
    } else {
      changeLanguage(context, 0);
    }
  }

  void swipeTheme() {
    if (themeMode == ThemeMode.light) {
      changeTheme(1);
    } else {
      changeTheme(0);
    }
  }

  bool isThemeDark() {
    return CacheHelper.getTheme() == 1 ? true : false;
  }

  bool isEngLang() {
    return CacheHelper.getLang() == 0 ? true : false;
  }

  void changeSelectedDate(DateTime? date) {
    selectedDate = date;
    notifyListeners();
  }


  void changeSelectedTime(TimeOfDay? time) {
    selectedTime = time;
    notifyListeners();
  }

  void changeTabIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void changeCatIndex(int index) {
    selectedCatIndex = index;
    notifyListeners();
  }

  void changeAddEventCatIndex(int index) {
    selectedAddEventCatIndex = index;
    notifyListeners();
  }

  void changeLoadingState(bool state){
    isLoading = !isLoading;
    notifyListeners();
  }
}
