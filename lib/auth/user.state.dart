import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locallancers/auth/response/failure.dart';
import 'package:locallancers/auth/response/processing.dart';
import 'package:locallancers/auth/response/retry.dart';
import 'package:locallancers/auth/splash.widget.dart';
import '../locallancers/main.page.dart';

class UserStateWidget extends StatelessWidget {
  //const UserStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot)
        {

          if(userSnapshot.data == null)
          {
              return Splash(); //user is not logged in yet
          }else if(userSnapshot.hasError){
              return RetryResponse();
          } else if(userSnapshot.connectionState == ConnectionState.waiting){
              return ProcessingResponse();
          }
          return FailureResponse();

        }
    );
  }
}
