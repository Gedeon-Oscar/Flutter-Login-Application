import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:locallancers/utils/app.colors.dart';

class FailureResponse extends StatelessWidget {
  //const FailureResponse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.altAccentColor,
      body: Column(
        mainAxisAlignment:  MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: SvgPicture.asset(
              "assets/images/failure-bg.svg",
              width: 150,
              height: 150,
            ),
          ),
          const SizedBox(height: 12.5),
          const Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 15.00,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}