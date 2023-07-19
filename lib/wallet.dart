import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Wallet extends StatefulWidget {
  Wallet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WalletPage();
  }
}

class WalletPage extends State<Wallet> {
  bool isLoaded = false, isLogin = false;
  String? sID;

  List<dynamic> resultList = [];

  String? sWalletAmt = '0';

  @override
  void initState() {
    getSessionData();
    super.initState();
  }

  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Wallet',
          style: TextStyle(
              color: Clr().black,
              fontSize: Dim().d20,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Clr().white,
      ),
      body: Visibility(
        visible: isLoaded,
        child: bodyLayout(),
      ),
    );
  }

  //Body
  Widget bodyLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        Dim().d16,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: Dim().d32),
                child: Text(
                  'Wallet',
                  style: Sty().extraLargeText,
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: Dim().d32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/wallet.svg',
                      height: Dim().d24,
                    ),
                    SizedBox(
                      width: Dim().d8,
                    ),
                    Text(
                      '₹ ${sWalletAmt!}',
                      style: Sty().largeText,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: Dim().d12,
          ),
          if (resultList.isEmpty)
            SizedBox(
              width: double.infinity,
              child: Card(
                margin: EdgeInsets.all(8.0),
                color: Clr().white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "No History Found",
                    style: Sty().mediumText.copyWith(
                          fontSize: 18,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          if (resultList.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              itemCount: resultList.length,
              itemBuilder: (BuildContext context, int index) {
                return itemWallet(ctx, index, resultList);
              },
            ),
        ],
      ),
    );
  }

  Widget itemWallet(ctx, index, list) {
    return Container(
      color: Clr().background1,
      margin: EdgeInsets.symmetric(
        vertical: Dim().d4,
      ),
      padding: EdgeInsets.all(
        Dim().d16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            list[index]['created_at'],
            style: Sty().mediumText.copyWith(
                  color: Clr().black,
                ),
          ),
          SizedBox(
            height: Dim().d8,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  list[index]['operation_type'],
                  style: Sty().mediumText.copyWith(
                        color: Clr().black,
                      ),
                ),
              ),
              Text(
                ':',
                style: Sty().mediumText.copyWith(
                      color: Clr().black,
                    ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${list[index]['type'] == '1' ? '+' : '-'}${list[index]['amount']}',
                    style: Sty().mediumBoldText.copyWith(
                      color: list[index]['type'] == '1' ? Clr().green : Clr().errorRed,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (list[index]['remark'] != null)
            SizedBox(
              height: Dim().d8,
            ),
          if (list[index]['remark'] != null)
            Text(
              list[index]['remark'],
              style: Sty().mediumText.copyWith(
                    color: Clr().black,
                  ),
              textAlign: TextAlign.justify,
            ),
        ],
      ),
    );
  }

  //Get detail
  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sID = sp.getString("user_id");
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getData();
      }
    });
  }

  //Api method
  void getData() async {
    FormData body = FormData.fromMap({
      'user_id': sID,
    });
    var result = await STM().post(ctx, Str().loading, 'wallet_history', body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    setState(() {
      isLoaded = true;
      if (!error) {
        sWalletAmt = result['wallet_balance'].toString();
        resultList = result['wallet_history'];
      } else {
        STM().errorDialog(ctx, message);
      }
    });
  }
}
