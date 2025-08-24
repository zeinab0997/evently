import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/model/event_model.dart';
import 'package:evently/model/location_model.dart';
import 'package:evently/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseManager {
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static CollectionReference<EventModel> getEventCollection() {
    return firebaseFirestore
        .collection("event")
        .withConverter<EventModel>(
          fromFirestore: (snapshot, _) {
            return EventModel.fromJson(snapshot.data()!);
          },
          toFirestore: (model, _) {
            return model.toJson();
          },
        );
  }

  static CollectionReference<UserModel> getUserCollection() {
    return firebaseFirestore
        .collection("user")
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) {
            return UserModel.fromJson(snapshot.data()!);
          },
          toFirestore: (model, _) {
            return model.toJson();
          },
        );
  }

  static Future<void> addEvent(EventModel eventModel) {
    var collection = getEventCollection();
    var docRef = collection.doc();
    eventModel.id = docRef.id;
    return docRef.set(eventModel);
  }

  static Future<void> addUser(UserModel userModel) {
    var collection = getUserCollection();
    var docRef = collection.doc(userModel.id);
    return docRef.set(userModel);
  }

  static Stream<QuerySnapshot<EventModel>> getEvents(int catId) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Stream.empty();
    }

    var collection = getEventCollection();
    if (catId == 0) {
      return collection
          .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy("date")
          .snapshots();
    } else {
      return collection
          .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where("catIndex", isEqualTo: catId - 1)
          .orderBy("date")
          .snapshots();
    }
  }

  static Future<UserModel?> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    var collection = getUserCollection();
    DocumentSnapshot<UserModel> docRef =
        await collection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    return docRef.data();
  }

  static Future<void> deleteEvent(String id) {
    var collection = getEventCollection();
    return collection.doc(id).delete();
  }

  static Future<void> updateEvent(EventModel eventModel) {
    var collection = getEventCollection();
    return collection.doc(eventModel.id).update(eventModel.toJson());
  }

  static Future<void> createAccount({
    required String email,
    required String password,
    required String name,
    required LocationModel userLocation,
    required Function onLoading,
    required Function onSuccess,
    required Function onError,
  }) async {
    onLoading();
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      credential.user!.sendEmailVerification();

      UserModel userModel = UserModel(
        id: credential.user!.uid,
        email: email,
        name: name,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        userLocation: userLocation,
        favEvents: [],
      );
      addUser(userModel);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('pass_weak'.tr());
      } else if (e.code == 'email-already-in-use') {
        print('email_exists'.tr());
      }
      onError(e.message);
    } catch (e) {
      print(e);
      onError(e.toString());
    }
  }

  static Future<void> updateUser(String uid, String key, dynamic value) {
    var collection = getUserCollection();
    var docRef = collection.doc(uid);
    return docRef.update({key: value});
  }

  static Future<void> signInWithGoogle({
    required Function onLoading,
    required Function onSuccess,
    required Function completeUserData,
    required Function onError,
  }) async {
    onLoading();
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(
            clientId:
                Platform.isIOS
                    ? '715881392757-ibkca79bqocgoaq10k2fbuh0ihn64i0m.apps.googleusercontent.com'
                    : null,
          ).signIn();
      if (googleUser == null) {
        onError('Sign-in aborted by user');
        return;
      }
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final user = userCredential.user!;

      final userDoc = await getUserCollection().doc(user.uid).get();
      if (!userDoc.exists) {
        completeUserData(user);
      } else {
        onSuccess();
      }
      // Once signed in, return the UserCredential
      //return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      onError(e.toString());
    }
  }

  static Future<void> forgetPass({
    required String email,
    required Function onLoading,
    required Function onSuccess,
    required Function onError,
  }) async {
    onLoading();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
  }

  static Future<void> login({
    required String email,
    required String password,
    required Function onLoading,
    required Function onSuccess,
    required Function onError,
  }) async {
    onLoading();
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user!.emailVerified) {
        onSuccess();
      } else {
        logout();
        onError("Verify your e_mail, check your inbox!");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        onError("wrong_email_or_pass".tr());
      } else {
        onError(e.message);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
