import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bn_home.dart';
import 'chat.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Contact extends StatefulWidget {
Contact({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ContactPage();
  }
}

class ContactPage extends State<Contact> {
  late BuildContext ctx;
  bool isLoaded = false, isLogin = false;
  String? sID;

  List<dynamic> contactList = [];
  RefreshController refreshCtrl = RefreshController(initialRefresh: false);

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
          getData(true);
        }
      });
    });
  }

  //Api Method
  getData(b) async {
    //Input
    FormData body = FormData.fromMap({
      // 'user_id': sID ?? "",
      'user_id': "1",
    });
    //Output
    dynamic result;
    if (b) {
      result = await STM().post(ctx, Str().loading, "get_contact", body);
    } else {
      result = await STM().postWithoutDialog(ctx, "get_contact", body);
    }
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      contactList = result;
      refreshCtrl.refreshCompleted();
    });
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
        backgroundColor: Clr().white,
        appBar: AppBar(
          title: Text(
            "Chats",
            style: Sty().largeText.copyWith(
                  color: Clr().white,
                ),
          ),
          backgroundColor: Clr().primaryColor,
          foregroundColor: Clr().white,
          elevation: 0,
        ),
        body: SmartRefresher(
          controller: refreshCtrl,
          onRefresh: () {
            getData(false);
          },
          child: Visibility(
            visible: isLoaded,
            child: bodyLayout(),
          ),
        ),
      ),
    );
  }

  //Body
  Widget bodyLayout() {
    return contactList.isNotEmpty
        ? ListView.builder(
            itemCount: contactList.length,
            itemBuilder: (context, index) {
              return itemLayout(ctx, index, contactList);
            },
          )
        : Center(
            child: STM().emptyData("No Chat Found"),
          );
  }

  //Item layout
  Widget itemLayout(ctx, index, list) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            STM().redirect2page(
              ctx,
              Chat(
                list[index]['to_user']['id'].toString(),
                list[index]['to_user']['name'],
                list[index]['to_user']['id'].toString(),
                list[index]['chat_unique_id'].toString(),
              ),
            );
          },
          child: Column(
            children: [
              SizedBox(
                height: Dim().d8,
              ),
              Row(
                children: [
                  // SizedBox(
                  //   width: Dim().d16,
                  // ),
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(
                  //     Dim().d100,
                  //   ),
                  //   child: CachedNetworkImage(
                  //     imageUrl: list[index]['to_user']['image_path'],
                  //     width: Dim().d60,
                  //     height: Dim().d60,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: Dim().d16,
                  // ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                list[index]['to_user']['name'],
                                style: Sty().largeText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Text(
                            //   list[index]['last_chat']['created_at'],
                            //   style: Sty().microText.copyWith(
                            //         color: Clr().grey,
                            //       ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: Dim().d8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                list[index]['last_chat']['message'],
                                style: Sty().smallText,
                              ),
                            ),
                            if (list[index]['count'] > 0)
                              Container(
                                width: Dim().d24,
                                height: Dim().d24,
                                decoration: BoxDecoration(
                                  color: Clr().primaryColor,
                                  borderRadius: BorderRadius.circular(
                                    Dim().d100,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    list[index]['count'].toString(),
                                    style: Sty().microText.copyWith(
                                          color: Clr().white,
                                        ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: Dim().d16,
                  ),
                ],
              ),
              SizedBox(
                height: Dim().d4,
              ),
            ],
          ),
        ),
      Divider(),
      ],
    );
  }
}
