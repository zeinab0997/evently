import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{
  static late final sharedPref;

  static init()async{
    sharedPref = await SharedPreferences.getInstance();
    if(getLang() == null){
      saveLang(0);
    }
    if(getTheme() == null){
      saveTheme(0);
    }
  }

  static Future<bool> saveEligibility()async{
    bool result = await sharedPref.setBool("onBoarding", true);
    return result;
  }

  static bool? getEligibility(){
    return sharedPref.getBool("onBoarding");
  }

  static Future<bool> saveTheme(int themeIndex)async{
    bool result = await sharedPref.setInt("themeIndex", themeIndex);
    return result;
  }

  static int? getTheme(){
    return sharedPref.getInt("themeIndex");
  }

  static Future<bool> saveLang(int langIndex)async{
    bool result = await sharedPref.setInt("langIndex", langIndex);
    return result;
  }

  static int? getLang(){
    return sharedPref.getInt("langIndex");
  }


}