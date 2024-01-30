import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:locallancers/utils/app.colors.dart';

class RetryResponse extends StatelessWidget {
  //const RetryResponse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.altAccentColor,
      body: Column(
        mainAxisAlignment:  MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: SvgPicture.asset(
              "assets/images/warning-bg.svg",
              width: 150,
              height: 150,
            ),
          ),
          const SizedBox(height: 12.5),
          const Center(
            child: Text(
              'An error has occurred. Try again later.',
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
