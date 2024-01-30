// ignore_for_file: use_build_context_synchronously

import 'package:clay_containers/widgets/clay_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locallancers/auth/signin.widget.dart';
import 'package:locallancers/utils/app.colors.dart';
import 'package:locallancers/utils/app.neum.top.bg.dart';
import '../utils/app.neum.bottom.bg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPwdWidget extends StatefulWidget {
  const ForgotPwdWidget({Key? key}) : super(key: key);

  @override
  State<ForgotPwdWidget> createState() => _ForgotPwdWidgetState();
}

class _ForgotPwdWidgetState extends State<ForgotPwdWidget> {
  /*
  ---------------------------------------------
  Declarations
  ---------------------------------------------
  */

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _forgetPassController = TextEditingController(text: '');

  /*
  ---------------------------------------------
  Methods
  ---------------------------------------------
  */

  void _forgotPassSubmitForm() async
  {
    try{
      await _auth.sendPasswordResetEmail(
          email: _forgetPassController.text
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignInWidget()));
    }catch(error)
    {
      Fluttertoast.showToast(msg: error.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.lightBgColor,
      body: Stack(
        children: [

          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              children: [

                const NeumorphismTopBg(),
                Text(
                    'Forgot Password?',
                  style: TextStyle(
                      color: AppColors.fontPrimaryColor,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      fontSize: 25.0,
                  ),
                ),
                const SizedBox(height: 15.0),
                ClayContainer(
                  depth: -30,
                  color: AppColors.lightBgColor,
                  child: TextFormField(
                    validator: (value){
                      if( value!.isEmpty || !value.contains('@') || (value!.length <= 10) )
                      {
                        return "Please enter a valid email address.";
                      }else{
                        return null;
                      }
                    },
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: AppColors.fontPrimaryColor,
                    ),
                    controller: _forgetPassController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.whiteColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.errorColor),
                      ),
                      prefixIcon: Icon(
                        size: 25.0,
                        Icons.email_outlined,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
                MaterialButton(
                  elevation: 8.0,
                  onPressed: ()
                  {
                    _forgotPassSubmitForm();
                  },
                  color: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Reset now',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        Icon(
                          size: 30.00,
                          Icons.restart_alt_outlined,
                          color: AppColors.whiteColor,
                        ),
                      ],
                    ),
                  ),
                ),
                const NeumorphismBottomBg()

              ],
            ),
          ),

        ],
      ),
    );
  }
}
