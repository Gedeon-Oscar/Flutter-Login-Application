// ignore_for_file: use_build_context_synchronously
import 'package:clay_containers/clay_containers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:locallancers/auth/signup.widget.dart';
import 'package:locallancers/utils/app.colors.dart';
import 'package:locallancers/auth/forgotPwd.widget.dart';
import 'package:locallancers/services/app.methods.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInState();
}

class _SignInState extends State<SignInWidget> {

  /*
  ---------------------------------------------
  Declarations
  ---------------------------------------------
  */
  bool _obscureText = true;
  bool _isLoading = false;

  final _loginFormKey = GlobalKey<FormState>();
  final FocusNode _passFocusNode = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController(text: '');
  final TextEditingController _passwordController = TextEditingController(text: '');


  /*
  ---------------------------------------------
  Methods
  ---------------------------------------------
  */

  @override
  void dispose()
  {
    _emailController.dispose();
    _passwordController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  void _submitFormOnLogin() async
  {
    final isValid = _loginFormKey.currentState!.validate();
    if(isValid){
      setState(() {
        _isLoading = true;
      });

      try{
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim(),
        );

        Navigator.canPop(context) ? Navigator.pop(context) : null;

      }catch (error){
        setState(() {
          _isLoading = false;
        });
        AppMethods.showErrorDialog(error: error.toString(), ctx: context);
        print('Error occurred $error');
      }

    }

    setState(() {
      _isLoading = false;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBgColor,
      body: Stack(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
            child: ListView(
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 80,right: 80),
                  child: CircleAvatar(
                    radius: 125,
                    backgroundColor: AppColors.accentColor,
                    child: SvgPicture.asset("assets/images/login.svg",
                        width:250,
                        height: 250,
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [

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
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(_passFocusNode),
                          decoration: InputDecoration(
                            hintText: 'Email',
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
                      const SizedBox(height: 15.0),
                      ClayContainer(
                        depth: -30,
                        color: AppColors.lightBgColor,
                        child: TextFormField(
                          validator: (value){
                            if( value!.isEmpty || value!.length <= 7 )
                            {
                              return "Please enter a valid password.";
                            }else{
                              return null;
                            }
                          },
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColors.fontPrimaryColor,
                          ),
                          focusNode: _passFocusNode,
                          obscureText: !_obscureText,
                          controller: _passwordController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(_passFocusNode),
                          decoration: InputDecoration(
                            hintText: 'Password',
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
                              Icons.lock_open_outlined,
                              color: AppColors.primaryColor,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                                color: AppColors.accentColor,
                              ),
                            )
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                          onPressed: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPwdWidget()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.altAccentColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: 'Open_Sans',
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.fontPrimaryColor,
                                    ),
                                  ),
                                  Icon(
                                    Icons.lock_reset,
                                    size: 35.0,
                                    color: AppColors.primaryColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      MaterialButton(
                          elevation: 8.0,
                          onPressed: _submitFormOnLogin,
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
                                'Login',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Do not have an account?',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Open_Sans',
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const TextSpan(text: ' '),
                              TextSpan(
                                text: 'Register now!',
                                recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpWidget())),
                                style: TextStyle(
                                  fontSize: 16.5,
                                  fontFamily: 'Open_Sans',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkBgColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      )

                    ],
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}