import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sb/aboutus.dart';
import 'package:sb/myaddress.dart';
import 'package:sb/sign_in.dart';
import 'package:sb/sign_up.dart';
import 'package:sb/values/strings.dart';
import 'package:sb/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bn_home.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'contactus.dart';
import 'localstore.dart';
import 'manage/static_method.dart';
import 'my_orders.dart';
import 'my_profile.dart';
import 'notifications.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'wallet.dart';

class MyAccount extends StatefulWidget {
  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  late BuildContext ctx;
  String? sUserid;
  dynamic profile;
  List<dynamic> addToCart = [];
  bool isLoading = true;

  void _refreshData() async {
    var data = await Store.getItems();
    setState(() {
      addToCart = data;
      isLoading = false;
    });
  }

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sUserid = sp.getString('user_id') ?? null;
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getProfile();
        _refreshData();
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
        STM().replacePage(ctx, Home());
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 0, addToCart.length),
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              STM().back2Previous(ctx);
            },
            child: Icon(
              Icons.arrow_back,
              color: Clr().black,
            ),
          ),
          title: Text(
            'My Account',
            style: TextStyle(color: Clr().black, fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: Clr().white,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              profile == null
                  ? Container()
                  : Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Color(0xffECECEC))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dim().d16, vertical: Dim().d16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${profile['name'].toString()}',
                                  style: Sty()
                                      .largeText
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                InkWell(
                                    onTap: () {
                                      STM().replacePage(ctx, MyProfile());
                                    },
                                    child: SvgPicture.asset('assets/edit.svg'))
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              width: Dim().d20,
                              height: Dim().d4,
                              color: Color(0xffE8558E),
                            ),
                            SizedBox(
                              height: 28,
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset('assets/mail.svg'),
                                    SizedBox(
                                      height: Dim().d12,
                                    ),
                                    SvgPicture.asset('assets/call.svg'),
                                  ],
                                ),
                                SizedBox(
                                  width: Dim().d8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${profile['email'].toString()}',
                                      style: TextStyle(
                                        color: Color(0xff747688),
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dim().d8,
                                    ),
                                    Text(
                                      '${profile['mobile'].toString()}',
                                      style: TextStyle(
                                        color: Color(0xff747688),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
              Card(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Color(0xffECECEC))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          sUserid != null ? STM().redirect2page(context, Wallet()) : STM().finishAffinity(ctx, SignUp());
                          sUserid == null ? Fluttertoast.showToast(msg: 'Login is required',gravity: ToastGravity.CENTER,textColor: Clr().white) : null;
                        },
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xffEEEEEE),
                              ),
                              alignment: Alignment.center,
                              width: Dim().d36,
                              height: Dim().d36,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SvgPicture.asset('assets/wallet.svg'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                'My Wallet (₹${profile != null ? profile['wallet'].toString() : ''})',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xff7F7A7A),
                                    )))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: const Divider(
                        height: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          sUserid != null ? STM().redirect2page(ctx, NotificationPage()) : STM().finishAffinity(ctx, SignUp());
                          sUserid == null ? Fluttertoast.showToast(msg: 'Login is required',gravity: ToastGravity.CENTER,textColor: Clr().white) : null;
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xffEEEEEE),
                                  ),
                                  alignment: Alignment.center,
                                  width: Dim().d36,
                                  height: Dim().d36,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: SvgPicture.asset('assets/bell.svg'),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                'Notifications',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xff7F7A7A),
                                    )))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: const Divider(
                        height: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                       sUserid != null ? STM().replacePage(ctx, MyAddress()) : STM().finishAffinity(ctx, SignUp());
                       sUserid == null ? Fluttertoast.showToast(msg: 'Login is required',gravity: ToastGravity.CENTER,textColor: Clr().white) : null;
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xffEEEEEE),
                                  ),
                                  alignment: Alignment.center,
                                  width: Dim().d40,
                                  height: Dim().d40,
                                  child: SvgPicture.asset(
                                    'assets/location.svg',
                                    height: Dim().d20,
                                    width: Dim().d20,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                'My Address',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xff7F7A7A),
                                    )))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: const Divider(
                        height: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          STM().redirect2page(
                              ctx,
                              MyOrders(
                                isRedirect: false,
                              ));
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xffEEEEEE),
                                  ),
                                  alignment: Alignment.center,
                                  width: Dim().d36,
                                  height: Dim().d36,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: SvgPicture.asset(
                                      'assets/myorders.svg',
                                      height: Dim().d20,
                                      width: Dim().d20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                'My Orders',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xff7F7A7A),
                                    )))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: const Divider(
                        height: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          // STM().redirect2page(ctx, Notifications());
                          STM().openWeb('https://sonibro.com/privacy');
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xffEEEEEE),
                                  ),
                                  alignment: Alignment.center,
                                  width: Dim().d36,
                                  height: Dim().d36,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: SvgPicture.asset(
                                      'assets/privacy.svg',
                                      height: Dim().d20,
                                      width: Dim().d20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xff7F7A7A),
                                    )))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: const Divider(
                        height: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          STM().redirect2page(ctx, Aboutus());
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xffEEEEEE),
                                  ),
                                  alignment: Alignment.center,
                                  width: Dim().d36,
                                  height: Dim().d36,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: SvgPicture.asset(
                                      'assets/about.svg',
                                      height: Dim().d20,
                                      width: Dim().d20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                'About Us',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xff7F7A7A),
                                    )))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: const Divider(
                        height: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          // STM().redirect2page(ctx, Contactus());
                          STM().openWeb('https://sonibro.com/refund');
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xffEEEEEE),
                                  ),
                                  alignment: Alignment.center,
                                  width: Dim().d36,
                                  height: Dim().d36,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: SvgPicture.asset(
                                      'assets/refund.svg',
                                      height: Dim().d20,
                                      width: Dim().d20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                'Refund Policy',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xff7F7A7A),
                                    )))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: const Divider(
                        height: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          // STM().redirect2page(ctx, Contactus());
                          STM().openWeb('https://sonibro.com/terms');
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xffEEEEEE),
                                  ),
                                  alignment: Alignment.center,
                                  width: Dim().d36,
                                  height: Dim().d36,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: SvgPicture.asset(
                                      'assets/terms.svg',
                                      height: Dim().d20,
                                      width: Dim().d20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xff7F7A7A),
                                    )))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: const Divider(
                        height: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          STM().redirect2page(ctx, Contactus());
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xffEEEEEE),
                                  ),
                                  alignment: Alignment.center,
                                  width: Dim().d36,
                                  height: Dim().d36,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: SvgPicture.asset(
                                      'assets/contact.svg',
                                      height: Dim().d20,
                                      width: Dim().d20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                'Contact Us',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xff7F7A7A),
                                    )))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: const Divider(
                        height: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          // STM().redirect2page(ctx, Notifications());
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          sp.clear();
                          STM().finishAffinity(ctx, SignIn());
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xffEEEEEE),
                                  ),
                                  alignment: Alignment.center,
                                  width: Dim().d36,
                                  height: Dim().d36,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: SvgPicture.asset(
                                      'assets/door.svg',
                                      height: Dim().d20,
                                      width: Dim().d20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                'Log Out',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xff7F7A7A),
                                    )))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dim().d12,
                    ),
                  ],
                ),
              ),
          sUserid != null ? InkWell(onTap: (){
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Delete Account',
                            style: Sty().mediumBoldText),
                        content: Text(
                            'Are you sure want to delete account?',
                            style: Sty().mediumText),
                        actions: [
                          TextButton(
                              onPressed: () {
                                deleteProfile();
                              },
                              child: Text('Yes',
                                  style: Sty().smallText.copyWith(fontWeight: FontWeight.w600))),
                          TextButton(
                              onPressed: () {
                                STM().back2Previous(ctx);
                              },
                              child: Text('No',
                                  style: Sty().smallText.copyWith(fontWeight: FontWeight.w600))),
                        ],
                      );
                    });
              },
                child: Center(
                  child: Text('Delete Account',style: Sty().mediumText.copyWith(color: Clr().errorRed,fontWeight: FontWeight.w500)),
                ),
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void getProfile() async {
    FormData body = FormData.fromMap({
      'user_id': sUserid,
    });
    var result = await STM().post(ctx, Str().loading, 'get_profile', body);
    if (!mounted) return;
    setState(() {
      profile = result;
    });
  }

  void deleteProfile() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'user_id': sUserid,
    });
    var result = await STM().post(ctx, Str().loading, 'delete_account', body);
    var success = result['success'];
    var message = result['message'];
    if(success){
      STM().displayToast(message);
      sp.clear();
      STM().finishAffinity(ctx, SignIn());
    }else{
      STM().errorDialog(ctx, message);
    }
  }

}