import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<FirebaseUser> signInWithEmailAndPassword(String email, String password);
  Future<FirebaseUser> createUserWithEmailAndPassword(String email, String password);
  Future<FirebaseUser> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<FirebaseUser> createUserWithEmailAndPassword(String email, String password) async {
    FirebaseUser firebaseUser = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return firebaseUser;
  }

  @override
  Future<FirebaseUser> currentUser() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    return firebaseUser;
  }

  @override
  Future<FirebaseUser> signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser firebaseUser = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return firebaseUser;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

}