import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:locallancers/auth/user.state.dart';

class MainWidget extends StatelessWidget{
  const MainWidget ({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LocaLancers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.blue,
      ),
      home: UserStateWidget(),
    );
  }
}
