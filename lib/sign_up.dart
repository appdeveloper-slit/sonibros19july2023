import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sb/sign_in.dart';
import 'package:sb/values/strings.dart';
import 'package:sb/values/styles.dart';

import 'bn_home.dart';
import 'manage/static_method.dart';
import 'otp_verification.dart';
import 'values/colors.dart';
import 'values/dimens.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late BuildContext ctx;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();

  List<dynamic> typeList = [
    {'id': 'indian', 'name': 'Indian'},
    {'id': 'non_indian', 'name': 'NRI'}
  ];
  String sType = 'indian';

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Color(0xff2A2A2A),
      appBar: AppBar(
        backgroundColor: Color(0xff2A2A2A),
        elevation: 0,
        actions: [
          InkWell(onTap: (){
            STM().finishAffinity(ctx, Home());
          },
            child: Padding(
              padding: EdgeInsets.only(right: Dim().d12),
              child: Center(
                child: Text('Skip',
                    style: Sty()
                        .mediumText
                        .copyWith(fontWeight: FontWeight.w500, color: Clr().white)),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create Account',
                  style: Sty().extraLargeText.copyWith(color: Clr().white),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Fill the detail to create account',
                    style: TextStyle(fontSize: 14, color: Color(0xff787882)),
                  )),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d14),
                child: ButtonTheme(
                  child: DropdownButton<String>(
                    dropdownColor: Color(0xff2A2A2A),
                    onTap: () {
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                    value: sType,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: Sty().mediumText,
                    onChanged: (String? value) {
                      setState(() {
                        sType = value!;
                      });
                    },
                    items: typeList.map((value) {
                      return DropdownMenuItem<String>(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: Sty().mediumText.copyWith(
                                color: Clr().white,
                              ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(
                height: Dim().d8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d14),
                child: TextFormField(
                  cursorColor: Clr().white,
                  controller: nameCtrl,
                  cursorWidth: 1,
                  cursorHeight: 24,
                  style: Sty().mediumText.copyWith(color: Clr().white),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field required';
                    }
                  },
                  decoration: Sty().TextFormFieldUnderlineStyle.copyWith(
                        counterText: '',
                        hintText: 'Name',
                        hintStyle: TextStyle(color: Color(0xff787882)),
                      ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d14),
                child: TextFormField(
                  cursorColor: Clr().white,
                  cursorWidth: 1,
                  controller: emailCtrl,
                  cursorHeight: 24,
                  style: Sty().mediumText.copyWith(color: Clr().white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email field is required';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                  decoration: Sty().TextFormFieldUnderlineStyle.copyWith(
                        counterText: '',
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Color(0xff787882)),
                      ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d14),
                child: TextFormField(
                  cursorColor: Clr().white,
                  maxLength: 10,
                  cursorWidth: 1,
                  cursorHeight: 24,
                  controller: mobileCtrl,
                  keyboardType: TextInputType.number,
                  style: Sty().mediumText.copyWith(color: Clr().white),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Mobile field is required';
                    }
                    if (value.length != 10) {
                      return 'Mobile number should be 10 digits';
                    }
                  },
                  decoration: Sty().TextFormFieldUnderlineStyle.copyWith(
                        counterText: '',
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(color: Color(0xff787882)),
                      ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 54,
                width: 320,
                child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        sendOtp();
                      }
                      // STM().redirect2page(ctx, OTPVerification2());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Clr().black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    )),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  STM().redirect2page(ctx, SignIn());
                },
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: Sty().smallText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff787882)),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign In',
                        style: Sty().smallText.copyWith(
                            color: Color(0xFFfffffff),
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendOtp() async {
    FormData body = FormData.fromMap({
      'country': sType,
      'page_type': 'register',
      'mobile': mobileCtrl.text,
      'email': emailCtrl.text,
    });
    var result = await STM().post(ctx, Str().sendingOtp, 'sendOTP', body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (error == false) {
      STM().redirect2page(
        ctx,
        OTPVerification(
          sType: sType,
          sMobile: mobileCtrl.text,
          sEmail: emailCtrl.text,
          sName: nameCtrl.text,
        ),
      );
      STM().displayToast(message);
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
