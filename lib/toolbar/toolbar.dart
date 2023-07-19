import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sb/notifications.dart';
import 'package:sb/sign_in.dart';
import 'package:sb/sign_up.dart';
import 'package:sb/wallet.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';

PreferredSizeWidget homebar(context,userid) {
  return AppBar(
    leading: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset('assets/homelogo.png'),
    ),
    backgroundColor: Clr().white,
    actions: [
      Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  userid != null ? STM().redirect2page(context, Wallet()) : STM().finishAffinity(context, SignUp());
                  userid == null ? Fluttertoast.showToast(msg: 'Login is required',gravity: ToastGravity.CENTER) : null;
                },
                child: Padding(
                  padding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: SvgPicture.asset('assets/wallet.svg'),
                ),
              ),
              InkWell(
                  onTap: () {
                    userid != null ? STM().redirect2page(context, NotificationPage()) : STM().finishAffinity(context, SignUp());
                    userid == null ? Fluttertoast.showToast(msg: 'Login is required',gravity: ToastGravity.CENTER) : null;
                  },
                  child: SvgPicture.asset('assets/bell.svg')),
              SizedBox(
                width: 12,
              )
            ],
          )
        ],
      )
    ],
  );
}
