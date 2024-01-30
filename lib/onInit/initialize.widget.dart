import 'package:flutter/material.dart';
import 'package:locallancers/utils/app.colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InitializingResponse extends StatelessWidget{
  const InitializingResponse ({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
            const SizedBox(height: 12.5),
            const Center(
              child: Text(
                'Initializing LocaLancers...',
                style: TextStyle(
                  fontSize: 15.00,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
