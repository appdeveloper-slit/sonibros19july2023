import 'package:flutter/material.dart';
import 'package:sb/bn_my_account.dart';
import 'package:sb/bn_mycart.dart';
import '../bn_home.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';

Widget bottomBarLayout(ctx, index,length) {
  return BottomNavigationBar(
    elevation: 2,
    backgroundColor: Clr().white,
    selectedItemColor: Color(0xff000000),
    unselectedItemColor: Clr().black,
    type: BottomNavigationBarType.fixed,
    currentIndex: index,
    onTap: (i) async {
      switch (i) {
        case 0:
          STM().redirect2page(ctx, Home());
          break;
        case 1:
          STM().redirect2page(ctx,  MyCart());
          break;
        case 2:
          STM().redirect2page(ctx,  MyAccount());
          break;
      }
    },
    items: STM().getBottomList(index,length),
  );
}