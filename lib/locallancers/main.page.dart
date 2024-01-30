import 'package:flutter/material.dart';
import 'package:locallancers/utils/app.colors.dart';

class MainPageWidget extends StatefulWidget {
  const MainPageWidget ({Key? key}) : super(key: key);

  @override
  State<MainPageWidget> createState() => _State();
}

class _State extends State<MainPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('LocaLancers',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: AppColors.fontPrimaryColor
          ),
        ),
        backgroundColor: AppColors.whiteColor,
      ),
    );
  }
}
