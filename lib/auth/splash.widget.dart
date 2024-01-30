import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locallancers/utils/app.colors.dart';
import 'package:locallancers/auth/signin.widget.dart';

class Splash extends StatelessWidget {
  //const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Timer(const Duration(seconds: 10), () {
      Get.to(() => const SignInWidget());
    });

    return Scaffold(
      backgroundColor: AppColors.altAccentColor,
      body: Column(
        mainAxisAlignment:  MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.accentColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(16.0),
                ),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 0.5,
                    spreadRadius: 0.8,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Image.asset("assets/images/localancers-logo-100.png"),
            ),
          ),
          const SizedBox(height: 8.0),
          Center(
            child: Text(
              'LocaLancers',
              style: TextStyle(
                fontSize: 35.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: AppColors.fontPrimaryColor,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        alignment: Alignment.center,
        color: AppColors.altAccentColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hire close to home, anywhere you go.',
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'Open_Sans',
                fontWeight: FontWeight.w500,
                color: AppColors.fontPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );

  }
}
