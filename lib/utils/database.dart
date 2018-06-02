import 'dart:async';
import 'dart:io' show Platform;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class BaseDatabase {

}

class Database implements BaseDatabase {
  
  final FirebaseDatabase firebaseDatabase = new FirebaseDatabase(app: FirebaseApp(name: null));
  final FirebaseOptions firebaseOptions = new FirebaseOptions(
    googleAppID: "1:993189889765:android:5a41a00d56adcd35",
    apiKey: "AIzaSyCCMxVVhTV-EdEaBn21PkHNobJTBjMqA-Q",
    databaseURL: "https://bolao-da-copa-2018-c63ad.firebaseio.com",
  );

  
}