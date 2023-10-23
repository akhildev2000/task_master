import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? userId;
  String? get getUserId => userId;

  Future<void> logInAccount(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user!;
      userId = user.uid;
      storeTokenAndData(userCredential);
     // print(storeTokenAndData(userCredential));
      notifyListeners();
    } catch (e) {
      // Handle login error here
     // print("Login Error: $e");
    }
  }

  Future<void> createAccount(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user!;
      userId = user.uid;
      storeTokenAndData(userCredential);
      notifyListeners();
    } catch (e) {
      // Handle registration error here
     // print("Registration Error: $e");
    }
  }

  Future<void> logoutViaEmail() async {
    await _storage.delete(key: "token");
    await _firebaseAuth.signOut();
  }

  Future<void> storeTokenAndData(UserCredential? userCredential) async {
    if (userCredential == null) {
      // Handle the case when userCredential is null (e.g., show an error message).
     // print("UserCredential is null");
    } else {
      try {
       // print("Storing token and data");
        await _storage.write(
            key: "token", value: userCredential.credential?.token.toString());
        await _storage.write(
            key: "usercredential", value: userCredential.toString());
      } catch (e) {
        // Handle any potential storage error here
       // print("Storage Error: $e");
      }
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: "token");
  }

  Future<void> googleSignin() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(authCredential);
      final User? user = userCredential.user;
      storeTokenAndData(userCredential);
      await _storage.delete(key: "token");
      userId = user?.uid;
      notifyListeners();
    } catch (e) {
      // Handle Google Sign-In error here
     // print("Google Sign-In Error: $e");
    }
  }

  Future<void> signOutWithGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      // Handle Google Sign-Out error here
      //print("Google Sign-Out Error: $e");
    }
  }
}
