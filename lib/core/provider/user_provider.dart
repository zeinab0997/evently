import 'package:evently/core/firebase/firebase_manager.dart';
import 'package:evently/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{
  UserModel? userModel;
  User? firebaseUser;

  UserProvider(){
    firebaseUser = FirebaseAuth.instance.currentUser;
    if(firebaseUser != null){
      initUser();
    }
  }

  initUser()async{
    userModel = await FirebaseManager.getCurrentUser();
    notifyListeners();
  }
}
