import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sb/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bn_home.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class OTPVerification extends StatefulWidget {
  String? sType;
  String? sPageType;
  String? sMobile;
  String? sEmail;
  String? sName;

  OTPVerification(
      {super.key,
      this.sType,
      this.sPageType,
      this.sMobile,
      this.sEmail,
      this.sName});

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  late BuildContext ctx;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController otpCtrl = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  bool again = false;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Color(0xff2A2A2A),
      appBar: AppBar(
        backgroundColor: Color(0xff2A2A2A),
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SvgPicture.asset('assets/back.svg'),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'OTP Verification',
                style: Sty().extraLargeText.copyWith(color: Clr().white),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Code has sent to ${widget.sType == 'indian' ? '+91 ${widget.sMobile}' : widget.sPageType == 'login' ? '${widget.sMobile}' : '${widget.sEmail}'}',
                style: TextStyle(fontSize: 14, color: Color(0xff787882)),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            PinCodeTextField(
              controller: otpCtrl,
              errorAnimationController: errorController,
              appContext: context,
              enableActiveFill: true,
              textStyle: Sty().largeText.copyWith(color: Clr().white),
              length: 4,
              obscureText: false,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              animationType: AnimationType.scale,
              cursorColor: Clr().white,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                // borderRadius: BorderRadius.circular(Dim().d4),
                fieldWidth: Dim().d60,
                fieldHeight: Dim().d56,
                selectedFillColor: Clr().transparent,
                activeFillColor: Clr().transparent,
                inactiveFillColor: Clr().transparent,
                inactiveColor: Clr().white,
                activeColor: Clr().white,
                selectedColor: Clr().white,
              ),
              animationDuration: const Duration(milliseconds: 200),
              onChanged: (value) {},
              validator: (value) {
                if (value!.isEmpty || !RegExp(r'(.{4,})').hasMatch(value)) {
                  return "";
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Haven’t received the verification code?',
              style: Sty().smallText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff787882)),
            ),
            SizedBox(
              height: 12,
            ),
            Column(
              children: [
                Visibility(
                  visible: !again,
                  child: TweenAnimationBuilder<Duration>(
                      duration: const Duration(seconds: 60),
                      tween: Tween(
                          begin: const Duration(seconds: 60),
                          end: Duration.zero),
                      onEnd: () {
                        // ignore: avoid_print
                        // print('Timer ended');
                        setState(() {
                          again = true;
                        });
                      },
                      builder: (BuildContext context, Duration value,
                          Widget? child) {
                        var minutes = value.inMinutes;
                        var seconds = value.inSeconds % 60;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "Re-send code in $minutes:$seconds",
                            textAlign: TextAlign.center,
                            style:
                                Sty().mediumText.copyWith(color: Clr().white),
                          ),
                        );
                      }),
                ),
                // Visibility(
                //   visible: !isResend,
                //   child: Text("I didn't receive a code! ${(  sTime  )}",
                //       style: Sty().mediumText),
                // ),
                Visibility(
                  visible: again,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        again = false;
                      });
                      // STM.checkInternet().then((value) {
                      //   if (value) {
                      //     sendOTP();
                      //   } else {
                      //     STM.internetAlert(ctx, widget);
                      //   }
                      // });
                    },
                    child: Text(
                      'Resend OTP',
                      style: Sty().mediumText.copyWith(color: Clr().white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 54,
              width: 320,
              child: ElevatedButton(
                  onPressed: () {
                    if (otpCtrl.text.length > 3) {
                      STM().checkInternet(context, widget).then((value) {
                        if (value) {
                          widget.sPageType == 'login'
                              ? VerifyOtp()
                              : VerifyregisterOtp();
                        }
                      });
                    } else {
                      STM().displayToast(Str().invalidOtp);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Clr().white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Verify',
                    style: TextStyle(
                      color: Clr().black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void VerifyOtp() async {
    FormData body = FormData.fromMap({
      'country': widget.sType,
      'otp': otpCtrl.text,
      'page_type': 'login',
      'mobile': widget.sMobile,
      'email': widget.sMobile,
    });
    var result = await STM().post(ctx, Str().verifying, 'verifyOTP', body);
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (error == false) {
      sp.setString('user_id', result['user_id'].toString());
      sp.setBool('login', true);
      sp.setString('country', result['user_country']);
      STM().replacePage(
        ctx,
        Home(),
      );
      STM().displayToast(message);
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void VerifyregisterOtp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'country': widget.sType,
      'otp': otpCtrl.text,
      'page_type': 'register',
      'mobile': widget.sMobile,
      'email': widget.sEmail,
      'name': widget.sName,
    });
    var result = await STM().post(ctx, Str().verifying, 'verifyOTP', body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (error == false) {
      sp.setString('user_id', result['user_id'].toString());
      sp.setBool('login', true);
      sp.setString('country', widget.sType!);
      STM().replacePage(
        ctx,
        Home(),
      );
      STM().displayToast(message);
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
