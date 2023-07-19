import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sb/bn_home.dart';
import 'package:sb/sign_up.dart';
import 'package:sb/values/strings.dart';
import 'package:sb/values/styles.dart';
import 'manage/static_method.dart';
import 'otp_verification.dart';
import 'values/colors.dart';
import 'values/dimens.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late BuildContext ctx;
  TextEditingController mobileCtrl = TextEditingController();

  List<dynamic> typeList = [
    {'id': 'indian', 'name': 'Indian'},
    {'id': 'non_indian', 'name': 'NRI'}
  ];
  String sType = 'indian';

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                height: Dim().d100,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sign In',
                  style: Sty().extraLargeText.copyWith(
                        color: Clr().white,
                        fontFamily: 'outfit',
                      ),
                ),
              ),
              SizedBox(
                height: Dim().d12,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Fill the detail to sign in account',
                    style: Sty().smallText.copyWith(
                        fontWeight: FontWeight.w400, color: Clr().lightgrey),
                  )),
              SizedBox(
                height: Dim().d32,
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
                        mobileCtrl = TextEditingController();
                        formKey.currentState!.reset();
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
                  maxLength: sType == 'indian' ? 10 : null,
                  controller: mobileCtrl,
                  style: Sty().mediumText.copyWith(color: Clr().white),
                  cursorColor: Clr().white,
                  cursorWidth: 1,
                  keyboardType: sType == 'indian'
                      ? TextInputType.number
                      : TextInputType.emailAddress,
                  cursorHeight: 24,
                  decoration: Sty().TextFormFieldUnderlineStyle.copyWith(
                        counterText: '',
                        hintText: sType == 'indian'
                            ? 'Mobile Number'
                            : 'Email Address',
                        hintStyle: TextStyle(color: Clr().lightgrey),
                      ),
                  validator: (value) {
                    if (sType == 'indian') {
                      if (value!.isEmpty) {
                        return 'Mobile field is required';
                      }
                      if (value.length != 10) {
                        return 'Mobile number should be 10 digits';
                      }
                    } else {
                      if (value!.isEmpty) {
                        return 'Email field is required';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d14),
                child: SizedBox(
                  height: Dim().d56,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          sendOtp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Clr().white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text(
                        'Send OTP',
                        style: TextStyle(
                          color: Clr().black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  STM().redirect2page(ctx, SignUp());
                },
                child: RichText(
                  text: TextSpan(
                    text: "Don’t have an account? ",
                    style: Sty().smallText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff787882)),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign up',
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
      'page_type': 'login',
      'mobile': sType == 'indian' ? mobileCtrl.text : "",
      'email': sType == 'non_indian' ? mobileCtrl.text : "",
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
          sPageType: 'login',
          sMobile: mobileCtrl.text,
        ),
      );
      STM().displayToast(message);
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
