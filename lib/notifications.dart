import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb/values/dimens.dart';
import 'package:sb/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manage/static_method.dart';
import 'bn_my_account.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late BuildContext ctx;
  List<dynamic> notification = [];
  String? sUserid;

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sUserid = sp.getString('user_id') ?? "";
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getNotification();
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
          'My Notifications',
          style: TextStyle(color: Clr().black, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Clr().white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            notification.length == 0
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Text(
                        'No Notifications',
                        style: Sty().mediumText,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: notification.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0.0,
                        margin: EdgeInsets.symmetric(
                            horizontal: Dim().d0, vertical: Dim().d8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dim().d12),
                            side: BorderSide(color: Color(0xffECECEC))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 12, left: 20, right: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${notification[index]['title']}',
                                  style: Sty()
                                      .largeText
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),

                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  '${notification[index]['message']}',
                                  style: TextStyle(
                                    color: Color(0xff747688),
                                  ),
                                ),
                                SizedBox(height: 16,),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('${notification[index]['created_at']}',
                                    style: TextStyle(
                                      color: Color(0xff979797),
                                    ),))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }

  void getNotification() async {
    FormData body = FormData.fromMap({
      'user_id': sUserid,
    });
    var result = await STM().post(ctx, Str().loading, 'notification', body);
if (!mounted) return;
    setState(() {
      notification = result;
    });
  }
}
