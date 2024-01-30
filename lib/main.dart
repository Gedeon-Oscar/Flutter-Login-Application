import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

import 'package:locallancers/onInit/main.widget.dart';
import 'package:locallancers/onInit/error.widget.dart';
import 'package:locallancers/onInit/initialize.widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const InitializingResponse();
          }
          else if( snapshot.hasError ){
            return const ErrorResponse();
          }
          return const MainWidget();

        }
    );
  }
}