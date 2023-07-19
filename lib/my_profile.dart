import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sb/values/strings.dart';
import 'package:sb/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bn_my_account.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';

class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late BuildContext ctx;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  String? sUserid;
  var _formKey = GlobalKey<FormState>();

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sUserid = sp.getString('user_id') ?? "";
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getProfile();
      }
    });
  }

  @override
  void initState() {
    getSessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().replacePage(ctx, MyAccount());
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                STM().replacePage(ctx, MyAccount());
              },
              child: Icon(
                Icons.arrow_back,
                color: Clr().black,
              ),
            ),
            title: Text(
              'My Profile',
              style: TextStyle(color: Clr().black, fontSize: 20),
            ),
            centerTitle: true,
            backgroundColor: Clr().white,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(Dim().d16),
            child: Column(
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SvgPicture.asset('assets/name.svg'),
                    ),
                    // label: Text('Enter Your Number'),
                    hintText: "Enter Name",
                    hintStyle: TextStyle(
                      color: Color(0xff747688),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xffECECEC),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 20),

                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SvgPicture.asset('assets/mail.svg'),
                    ),
                    // label: Text('Enter Your Number'),
                    hintText: "Enter Email address",
                    hintStyle: TextStyle(
                      color: Color(0xff747688),
                    ),

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xffECECEC),
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: mobileCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SvgPicture.asset('assets/call.svg'),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        updateMobileNumber();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(18),
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: Clr().black,
                        ),
                      ),
                    ),
                    hintText: "Enter the mobile number",
                    hintStyle: TextStyle(
                      color: Color(0xff747688),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xffECECEC),
                        )),
                  ),
                ),
                SizedBox(
                  height: Dim().d28,
                ),
                SizedBox(
                  width: 280,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      updateProfile();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Update',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff2C2C2C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateMobileNumber() {
    bool otpsend = false;
    // var updateUserMobileNumberController;
    // updateUserMobileNumberController.text = "";
    // updateUserOtpController.text = "";
    showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (context) {
          TextEditingController updateUserMobileNumberController =
              TextEditingController();
          TextEditingController updateUserOtpController =
              TextEditingController();
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Text("Change Mobile Number",
                  style:
                      Sty().mediumBoldText.copyWith(color: Color(0xff2C2C2C))),
              content: SizedBox(
                height: 120,
                width: MediaQuery.of(ctx).size.width,
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: !otpsend,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "New Mobile Number",
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller:
                                        updateUserMobileNumberController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Mobile filed is required';
                                      }
                                      if (value.length != 10) {
                                        return 'Mobile digits must be 10';
                                      }
                                    },
                                    maxLength: 10,
                                    decoration: Sty()
                                        .TextFormFieldOutlineStyle
                                        .copyWith(
                                          counterText: "",
                                          hintText: "Enter Mobile Number",
                                          prefixIconConstraints: BoxConstraints(
                                              minWidth: 50, minHeight: 0),
                                          suffixIconConstraints: BoxConstraints(
                                              minWidth: 10, minHeight: 2),
                                          border: InputBorder.none,
                                          // prefixIcon: Icon(
                                          //   Icons.phone,
                                          //   size: iconSizeNormal(),
                                          //   color: primary(),
                                          // ),
                                        ),
                                  ),
                                ),
                              ],
                            )),
                        Visibility(
                            visible: otpsend,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "One Time Password",
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: TextFormField(
                                    controller: updateUserOtpController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText: "Enter OTP",
                                      prefixIconConstraints: BoxConstraints(
                                          minWidth: 50, minHeight: 0),
                                      suffixIconConstraints: BoxConstraints(
                                          minWidth: 10, minHeight: 2),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Color(0xff2C2C2C),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ]),
                ),
              ),
              elevation: 0,
              actions: [
                Row(
                  children: [
                    Visibility(
                      visible: !otpsend,
                      child: Expanded(
                        child: InkWell(
                          onTap: () async {
                            // API UPDATE START
                            SharedPreferences sp =
                                await SharedPreferences.getInstance();
                            FormData body = FormData.fromMap({
                              'page_type': 'change_mobile',
                              'mobile': updateUserMobileNumberController.text,
                            });
                            var result = await STM()
                                .post(ctx, Str().updating, 'sendOTP', body);
                            if (!mounted) return;
                            var error = result['error'];
                            var message = result['message'];
                            if (error == false) {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  otpsend = true;
                                });
                              }
                            } else {
                              STM().errorDialog(context, message);
                            }
                            // API UPDATE END
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Color(0xff2C2C2C),
                            ),
                            child: const Center(
                              child: Text(
                                "Send OTP",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: otpsend,
                      child: Expanded(
                        child: InkWell(
                            onTap: () {
                              // API UPDATE START
                              setState(() {
                                otpsend = true;
                                updatemobile(
                                    updateUserMobileNumberController.text,
                                    updateUserOtpController.text);
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Color(0xff2C2C2C),
                                ),
                                child: const Center(
                                    child: Text(
                                  "Update",
                                  style: TextStyle(color: Colors.white),
                                )))),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Color(0xff2C2C2C),
                              ),
                              child: const Center(
                                  child: Text("Cancel",
                                      style: TextStyle(color: Colors.white))))),
                    ),
                  ],
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
            ),
          );
        });
  }

  void updatemobile(sMobile, sOtp) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'otp': sOtp,
      'mobile': sMobile,
      'user_id': sUserid,
    });
    var result = await STM().post(
      ctx,
      Str().updating,
      'change_mobile',
      body,
    );
    if (!mounted) return;
    var error = result['error'];
    var message = result['messgae'];
    if (error == false) {
      setState(() {
        STM().back2Previous(ctx);
        STM().successDialogWithReplace(ctx, message, widget);
      });
    } else {
      STM().errorDialog(context, message);
    }
  }

  void updateProfile() async {
    FormData body = FormData.fromMap({
      'user_id': sUserid,
      'email': emailCtrl.text,
      'name': nameCtrl.text,
    });
    var result =
        await STM().post(ctx, Str().processing, 'update_profile', body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (error == false) {
      setState(() {
        STM().successDialog(ctx, message, widget);
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void getProfile() async {
    FormData body = FormData.fromMap({
      'user_id': sUserid,
    });
    var result = await STM().post(ctx, Str().loading, 'get_profile', body);
    if (!mounted) return;
    setState(() {
      nameCtrl = TextEditingController(text: result['name'].toString());
      emailCtrl = TextEditingController(text: result['email'].toString());
      mobileCtrl = TextEditingController(text: result['mobile'].toString());
    });
  }
}
