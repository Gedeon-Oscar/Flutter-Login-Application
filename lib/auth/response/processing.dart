import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:locallancers/utils/app.colors.dart';

class ProcessingResponse extends StatelessWidget {
  //const ProcessingResponse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.altAccentColor,
      body: Column(
        mainAxisAlignment:  MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: SvgPicture.asset(
              "assets/images/completion-bg.svg",
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 75,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircularProgressIndicator(
                strokeWidth: 6.0,
                color: AppColors.altAccentColor,
                backgroundColor: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}