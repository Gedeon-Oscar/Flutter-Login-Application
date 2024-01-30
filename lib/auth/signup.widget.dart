// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locallancers/auth/signin.widget.dart';
import 'package:locallancers/utils/app.regExp.dart';
import '../services/app.methods.dart';
import '../utils/app.colors.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key, this.onSubmit}) : super(key: key);
  final ValueChanged<String>? onSubmit;

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {

  /*
  ---------------------------------------------
  Declarations
  ---------------------------------------------
  */

  File? imageFile;
  bool _obscureText = true;
  bool _isLoading = false;
  String? imageUrl;
  bool _submitted = false;

  final _signUpFormKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _phoneNumFocusNode = FocusNode();
  final FocusNode _positionCPFocusNode = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _nameController = TextEditingController(text: '');
  final TextEditingController _emailController = TextEditingController(text: '');
  final TextEditingController _passwordController = TextEditingController(text: '');
  final TextEditingController _phoneNumController = TextEditingController(text: '');
  final TextEditingController _locationController = TextEditingController(text: '');

  /*
  ---------------------------------------------
  Methods
  ---------------------------------------------
  */

  @override
  void dispose()
  {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumController.dispose();
    _locationController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _phoneNumFocusNode.dispose();
    _positionCPFocusNode.dispose();
    super.dispose();
  }

  void _showImageDialog()
  {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Please choose an option',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.darkBgColor,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //* Camera
                InkWell(
                  onTap: ()
                  {
                    _getFromCamera();
                  },
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(4.00),
                        child: Icon(
                          size: 30.0,
                          Icons.camera,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text('Camera',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: AppColors.darkBgColor,
                        ),
                      )
                    ],
                  ),
                ),
                //* Gallery
                InkWell(
                  onTap: ()
                  {
                    _getFromGallery();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.00),
                        child: Icon(
                          size: 30.0,
                          Icons.image_outlined,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text('Gallery',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: AppColors.darkBgColor,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  void _getFromCamera() async
  {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async
  {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath)  async
  {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath, maxHeight: 1080, maxWidth: 1080
    );
    if( croppedImage != null )
    {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void _submitFormOnSignUp() async
  {
    final isValid = _signUpFormKey.currentState!.validate();
    if( isValid )
    {
      if( imageFile == null )
      {
        AppMethods.showErrorDialog(error: 'Please pick an image', ctx: context);
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try{
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim(),
        );

        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        final ref = FirebaseStorage.instance.ref().child('userImages').child(_uid + '.jpg');
        await ref.putFile(imageFile!);
        imageUrl = await ref.getDownloadURL();

        FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': _nameController.text,
          'email': _emailController.text,
          'userImage': imageUrl,
          'phoneNumber': _phoneNumController.text,
          'location': _locationController.text,
          'createdAt': Timestamp.now(),
        });

        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _phoneNumController.clear();
        _locationController.clear();

        Fluttertoast.showToast(
            msg: "You have been successfully been registered.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: AppColors.successColor,
            textColor: AppColors.whiteColor,
            fontSize: 16.0
        );

        Navigator.canPop(context) ? Navigator.pop(context) : null;

      }catch (error){
        setState(() {
          _isLoading = false;
        });
        AppMethods.showErrorDialog(error: error.toString(), ctx: context);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _submit()
  {
    setState(() => _submitted = true);
    if ( _passwordErrorText == null ) {
      widget.onSubmit!(_passwordController.value.text);
    }
  }


  String? get _passwordErrorText
  {
    final text = _passwordController.value.text;
    if ( text.isEmpty ) {
      return null;
    }
    if ( !regexPassword.hasMatch(text) ) {
      return 'Password must be at least 8 characters long, with one uppercase letter, one digit and one special character.';
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {

    var text = '';
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: AppColors.lightBgColor,
        body: Stack(
          children: <Widget>[

            SvgPicture.asset(
              'assets/images/sign-up.svg',
              fit: BoxFit.fitHeight,
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
              child: ListView(
                children: [
                  Form(
                    key: _signUpFormKey,
                    child: Column(
                      children: [

                        GestureDetector(
                          onTap: ()
                          {
                            _showImageDialog();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.00),
                            child: Container(
                              width: size.width * 0.24,
                              height: size.width * 0.24,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                    end: Alignment.bottomCenter,
                                    colors: [ Colors.white60,Colors.white10 ]
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(width: 2.00,color: AppColors.accentColor
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: imageFile == null
                                      ?
                                      Icon(Icons.camera_alt_outlined,color: AppColors.primaryColor,size: 50.00)
                                      :
                                      Image.file(imageFile!,fit: BoxFit.fill)
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0,),
                        ClayContainer(
                          depth: -30,
                          color: AppColors.lightBgColor,
                          child: TextFormField(
                            validator: (value){
                              if( value!.isEmpty || (value!.length <= 3) )
                              {
                                return "Please enter a valid user|company name with a length greater than 3";
                              }else{
                                return null;
                              }
                            },
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: AppColors.fontPrimaryColor,
                            ),
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocusNode),
                            decoration: InputDecoration(
                              hintText: 'User|Company name',
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
                                Icons.account_circle_outlined,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.5),
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
                        const SizedBox(height: 12.5),
                        ClayContainer(
                          depth: -30,
                          color: AppColors.lightBgColor,
                          child: TextFormField(
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
                            onChanged: (text) => setState(() => text),
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneNumFocusNode),
                            decoration: InputDecoration(
                                errorMaxLines: 2,
                                hintText: 'Password',
                                errorText: _submitted ? null  :  _passwordErrorText,
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
                        const SizedBox(height: 12.5),
                        ClayContainer(
                          depth: -30,
                          color: AppColors.lightBgColor,
                          child: TextFormField(
                            validator: (value){
                              if( value!.isEmpty )
                              {
                                return "This Field is empty";
                              }else{
                                return null;
                              }
                            },
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: AppColors.fontPrimaryColor,
                            ),
                            controller: _phoneNumController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_positionCPFocusNode),
                            decoration: InputDecoration(
                                hintText: 'Phone',
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
                                  Icons.phone,
                                  color: AppColors.primaryColor,
                                ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.5),
                        ClayContainer(
                          depth: -30,
                          color: AppColors.lightBgColor,
                          child: TextFormField(
                            validator: (value){
                              if( value!.isEmpty )
                              {
                                return "This Field is empty";
                              }else{
                                return null;
                              }
                            },
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: AppColors.fontPrimaryColor,
                            ),
                            controller: _locationController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_positionCPFocusNode),
                            decoration: InputDecoration(
                                hintText:'Location',
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
                                  Icons.home_outlined,
                                  color: AppColors.primaryColor,
                                ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.5),
                        _isLoading
                        ?
                            Center(
                              child: SizedBox(
                                width: 70.0,
                                height: 70.0,
                                child: CircularProgressIndicator(
                                  backgroundColor: AppColors.accentColor,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            )
                        :
                            MaterialButton(
                              elevation: 8.0,
                              onPressed: !regexPassword.hasMatch(_passwordController.value.text) ? null : ()
                              {
                                setState(() => _submit );
                                _submitFormOnSignUp();
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
                                      'SignUp',
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
                            const SizedBox(height: 15.0),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.altAccentColor.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Already have an account?',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: 'Open_Sans',
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        const TextSpan(text: ' '),
                                        TextSpan(
                                          text: 'Login',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInWidget())),
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
                                ),
                              ),
                        )

                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
    );
  }
}
