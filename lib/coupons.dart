import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';

class Coupons extends StatefulWidget {
  @override
  State<Coupons> createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  late BuildContext ctx;
  bool isLoaded = false, isLogin = false;
  String? sID;

  List<dynamic> resultList = [];

  @override
  void initState() {
    getSessionData();
    super.initState();
  }

  //Get detail
  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      isLogin = sp.getBool("is_login") ?? false;
      if (isLogin) {
        sID = sp.getString("user_id");
      }
      STM().checkInternet(context, widget).then((value) {
        if (value) {
          getData();
        }
      });
    });
  }

  //Api Method
  getData() async {
    //Output
    var result = await STM().get(ctx, Str().loading, "get_coupons");
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      resultList = result['result_array'];
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
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
          'Coupons',
          style: TextStyle(color: Clr().black, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Clr().white,
      ),
      body: Visibility(
        visible: isLoaded,
        child: resultList.isNotEmpty
            ? bodyLayout()
            : STM().emptyData("No Coupon Found"),
      ),
    );
  }

  //Body
  Widget bodyLayout() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: Dim().pp,
        vertical: Dim().d8,
      ),
      itemCount: resultList.length,
      itemBuilder: (BuildContext context, int index) {
        return itemCoupon(ctx, index, resultList);
      },
    );
  }

  //Body
  Widget itemCoupon(ctx, index, list) {
    var v = list[index];
    return Card(
      color: Clr().white,
      elevation: 0.5,
      margin: EdgeInsets.symmetric(horizontal: Dim().d0, vertical: Dim().d8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dim().d12),
          side: BorderSide(color: Color(0xffECECEC))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                FlutterClipboard.copy(v['code']).then(
                    (value) => STM().displayToast('Code Copied Successfully'));
              },
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    side: BorderSide(color: Color(0xff161616))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text('${v['code']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              '${v['detail']}',
              style: TextStyle(
                  color: Clr().black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
