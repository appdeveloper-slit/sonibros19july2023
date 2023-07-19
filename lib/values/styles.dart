import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimens.dart';

class Sty {
  TextStyle microText = TextStyle(
    fontFamily: 'outfit',
    letterSpacing: 0.5,
    color: Clr().black,
    fontSize: 12.0,
  );
  TextStyle smallText = TextStyle(
    fontFamily: 'outfit',
    letterSpacing: 0.5,
    color: Clr().black,
    fontSize: 14.0,
  );
  TextStyle mediumText = TextStyle(
    fontFamily: 'outfit',
    letterSpacing: 0.5,
    color: Clr().black,
    fontSize: 16.0,
  );
  TextStyle mediumBoldText = TextStyle(
    fontFamily: 'outfit-bold',
    letterSpacing: 0.5,
    color: Clr().black,
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
  );
  TextStyle largeText = TextStyle(
    fontFamily: 'outfit-bold',
    letterSpacing: 0.5,
    color: Clr().black,
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
  );
  TextStyle extraLargeText = TextStyle(
    fontFamily: 'outfit-bold',
    letterSpacing: 0.5,
    color: Clr().black,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
  );

  InputDecoration TextFormFieldUnderlineStyle = InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      vertical: Dim().d12,
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Clr().lightgrey,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Clr().lightgrey,
      ),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    errorStyle: TextStyle(
      fontFamily: 'outfit',
      letterSpacing: 0.5,
      color: Clr().errorRed,
      fontSize: 14.0,
    ),
  );

  InputDecoration TextFormFieldWithoutStyle = InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d14,
      vertical: Dim().d12,
    ),
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    errorStyle: TextStyle(
      fontFamily: 'outfit',
      letterSpacing: 0.5,
      color: Clr().errorRed,
      fontSize: 14.0,
    ),
  );

  InputDecoration textFieldWhiteStyle = InputDecoration(
    filled: true,
    fillColor: Clr().white,
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d14,
      vertical: Dim().d12,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().lightGrey,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().primaryColor,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    errorStyle: TextStyle(
      fontFamily: 'Regular',
      letterSpacing: 0.5,
      color: Clr().errorRed,
      fontSize: 14.0,
    ),
  );

  InputDecoration passwordFieldUnderlineStyle = InputDecoration(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Clr().black,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Clr().white,
      ),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    errorStyle: TextStyle(
      fontFamily: 'outfit',
      letterSpacing: 0.5,
      color: Clr().errorRed,
      fontSize: 14.0,
    ),
  );

  InputDecoration TextFormFieldOutlineDarkStyle = InputDecoration(
    filled: true,
    fillColor: Clr().white,
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d14,
      vertical: Dim().d12,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().lightGrey,
      ),
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().black,
      ),
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
    errorStyle: TextStyle(
      fontFamily: 'outfit',
      letterSpacing: 0.5,
      color: Clr().errorRed,
      fontSize: 14.0,
    ),
  );

  InputDecoration TextFormFieldGreyDarkStyle = InputDecoration(
    filled: true,
    fillColor: Clr().lightGrey,
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d14,
      vertical: Dim().d12,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().lightGrey,
      ),
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().lightGrey,
      ),
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
    errorStyle: TextStyle(
      fontFamily: 'outfit',
      letterSpacing: 0.5,
      color: Clr().errorRed,
      fontSize: 14.0,
    ),
  );

  InputDecoration TextFormFieldOutlineStyle = InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d14,
      vertical: Dim().d12,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().lightGrey,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().primaryColor,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Clr().errorRed,
      ),
    ),
    errorStyle: TextStyle(
      fontFamily: 'outfit',
      letterSpacing: 0.5,
      color: Clr().errorRed,
      fontSize: 14.0,
    ),
  );

  BoxDecoration dropDownUnderlineStyle = BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Clr().black,
        width: 1,
      ),
    ),
  );

  BoxDecoration outlineBoxStyle = BoxDecoration(
    border: Border.all(
      color: Clr().lightGrey,
    ),
    borderRadius: BorderRadius.circular(Dim().d4),
  );

  BoxDecoration fillBoxStyle = BoxDecoration(
    color: Clr().white,
    borderRadius: BorderRadius.circular(Dim().d4),
  );

  BoxDecoration registerDropDownStyle = BoxDecoration(
    color: Clr().white,
    border: Border.all(
      color: Clr().lightGrey,
    ),
  );

  BoxDecoration profileDropDownStyle = BoxDecoration(
    color: Clr().lightGrey,
    border: Border.all(
      color: Clr().lightGrey,
    ),
    borderRadius: BorderRadius.circular(
      Dim().d12,
    ),
  );

  ButtonStyle primaryButton = ElevatedButton.styleFrom(
    primary: Clr().primaryColor,
    padding: EdgeInsets.symmetric(
      vertical: Dim().d12,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
  );

  ButtonStyle primaryButton2 = ElevatedButton.styleFrom(
    primary: Clr().accentColor,
    padding: EdgeInsets.symmetric(
      vertical: Dim().d12,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
  );

  ButtonStyle whiteButton = ElevatedButton.styleFrom(
    primary: Clr().white,
    padding: EdgeInsets.symmetric(
      vertical: Dim().d4,
      horizontal: Dim().d20,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
  );
}
