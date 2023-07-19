import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Chat extends StatefulWidget {
String sToID, sToName, sToImage, sChatID;

Chat(this.sToID, this.sToName, this.sToImage, this.sChatID, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChatPage();
  }
}

class ChatPage extends State<Chat> {
  late BuildContext ctx;
  bool isLoaded = false, isLogin = false;
  String? sID;
  bool isUnBlocked = false, isBlocked = false;

  ScrollController listScrollController = ScrollController();
  List<dynamic> chatList = [];

  // int _limit = 20;
  // int _limitIncrement = 20;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController messageCtrl = TextEditingController();

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  @override
  void initState() {
    getSessionData();
    initPusher();
    super.initState();
  }

  @override
  void dispose() {
    change();
    super.dispose();
  }

  //Get detail
  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sID = sp.getString("user_id");
      isLogin = sp.getBool("is_login") ?? false;
      STM().checkInternet(context, widget).then((value) {
        if (value) {
          getData(true, widget.sChatID);
        }
      });
    });
  }

  //Api Method
  change() async {
    FormData body = FormData.fromMap({
      'user_id': sID ?? "",
    });
    //Output
    await STM().postWithoutDialog(ctx, "change_status", body);
  }

  initPusher() async {
    await pusher.init(
        apiKey: "178943fb15ff750e09f2",
        cluster: "ap2",
        onEvent: (PusherEvent event) {
          var data = json.decode(event.data.toString());
          if (data != null) {
            if (data['response']['from_id'] != sID) {
              getData(false, data['response']['chat_id']);
              // setState(() {
              //   chatList.add({
              //     "from_id": sID,
              //     "to_id": widget.sToID,
              //     "message": data['response']['message'],
              //     "created_at":
              //     STM().dateFormat("dd MMM yy | hh:mm a", DateTime.now())
              //   });
              // });
            }
          }
        });
    await pusher.subscribe(channelName: "chatting-channel");
    await pusher.connect();
  }

  //Api Method
  getData(b, id) async {
    //Input
    FormData body = FormData.fromMap({
      'user_id': sID ?? "",
      'chat_id': id ?? "",
      'flag': b ? "1" : "0",
    });
    //Output
    dynamic result;
    if (b) {
      result = await STM().post(ctx, Str().loading, "get_chat", body);
    } else {
      result = await STM().postWithoutDialog(ctx, "get_chat", body);
    }
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      if (result != null) {
        chatList = result["data"];
        // if (chatList.isNotEmpty) {
        //   isBlocked = result["is_block"];
        //   isUnBlocked = result["is_unblocked"];
        // }
      }
    });
    //For testing
    if (listScrollController.hasClients) {
      listScrollController.animateTo(0,
          duration: const Duration(milliseconds: 1), curve: Curves.easeOut);
    }
  }

  //Api Method
  void send(text) async {
    // setState(() {
    //   chatList.add({
    //     "from_id": sID,
    //     "to_id": widget.sToID,
    //     "message": text,
    //     "created_at":
    //     STM().dateFormat("dd MMM yy | hh:mm a", DateTime.now())
    //   });
    // });
    // if (listScrollController.hasClients) {
    //   listScrollController.animateTo(0, duration: const Duration(milliseconds: 1), curve: Curves.easeOut);
    // }
    //Input
    FormData body = FormData.fromMap({
      'from_id': sID,
      'to_id': widget.sToID,
      'chat_id': widget.sChatID,
      'message': text,
    });
    //Output
    messageCtrl.clear();
    var response = await STM().postWithoutDialog(ctx, "send_message", body);
    getData(false, response['chat_id']);
  }

  //Api Method
  void block() async {
    //Input
    FormData body = FormData.fromMap({
      'from_id': sID,
      'to_id': widget.sToID,
    });
    //Output
    var result = await STM().post(ctx, Str().processing, "block_unblock", body);
    if (!mounted) return;
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithReplace(ctx, message, widget);
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          widget.sToName,
          style: Sty().largeText.copyWith(
                color: Clr().white,
              ),
        ),
        centerTitle: true,
        backgroundColor: Clr().primaryColor,
        foregroundColor: Clr().white,
        elevation: 0,
        actions: [
          if (!isUnBlocked)
            InkWell(
              onTap: () {
                showDialog(
                  context: ctx,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Confirmation",
                        style: Sty().largeText.copyWith(
                              color: Clr().primaryColor,
                            ),
                      ),
                      content: Text(
                        "Are you sure you want to block this user?",
                        style: Sty().smallText,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            STM().back2Previous(ctx);
                            block();
                          },
                          child: Text(
                            "Yes",
                            style: Sty()
                                .smallText
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            STM().back2Previous(ctx);
                          },
                          child: Text(
                            "No",
                            style: Sty()
                                .smallText
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dim().d16,
                ),
                child: SvgPicture.asset(
                  "assets/report.svg",
                ),
              ),
            ),
        ],
      ),
      body: Visibility(
        visible: isLoaded,
        child: bodyLayout(),
      ),
    );
  }

  //Item layout
  Widget bodyLayout() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: chatList.length,
            itemBuilder: (context, index) {
              return itemLayout(context, index, chatList);
            },
            controller: listScrollController,
          ),
        ),
        if (!isUnBlocked && !isBlocked) inputLayout(),
        if (isUnBlocked)
          Container(
            padding: EdgeInsets.symmetric(
              vertical: Dim().d16,
            ),
            child: RichText(
              text: TextSpan(
                text: "You have blocked this user, ",
                style: Sty().smallText.copyWith(
                      color: Clr().lightGrey,
                    ),
                children: [
                  WidgetSpan(
                    child: InkWell(
                      onTap: () {
                        block();
                      },
                      child: Text(
                        "Tap Here",
                        style: Sty().microText.copyWith(
                              color: Clr().primaryColor,
                            ),
                      ),
                    ),
                  ),
                  TextSpan(
                    text: " to unblock",
                    style: Sty().smallText.copyWith(
                          color: Clr().lightGrey,
                        ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  //Item layout
  Widget itemLayout(ctx, index, list) {
    if (list[index]['from_id'].toString() != sID) {
      return Row(
        children: [
          Flexible(
            child: Container(
              margin: EdgeInsets.fromLTRB(
                Dim().d12,
                Dim().d12,
                Dim().d100,
                Dim().d4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      Dim().d12,
                    ),
                    decoration: BoxDecoration(
                      color: Clr().background1,
                      border: Border.all(
                        color: Clr().background1,
                      ),
                      borderRadius: BorderRadius.circular(
                        Dim().d8,
                      ),
                    ),
                    child: Text(
                      list[index]['message'],
                      style: Sty().smallText,
                    ),
                  ),
                  SizedBox(
                    height: Dim().d4,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      list[index]['created_at'].toString(),
                      // "02 Nov 2022 | 10:00 PM",
                      style: Sty().microText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              margin: EdgeInsets.fromLTRB(
                Dim().d100,
                Dim().d12,
                Dim().d12,
                Dim().d4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      Dim().d12,
                    ),
                    decoration: BoxDecoration(
                      color: Clr().primaryColor,
                      borderRadius: BorderRadius.circular(
                        Dim().d8,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          list[index]['message'],
                          style: Sty().smallText.copyWith(
                                color: Clr().white,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dim().d4,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      list[index]['created_at'].toString(),
                      // "02 Nov 2022 | 10:00 PM",
                      style: Sty().microText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  //Input layout
  Widget inputLayout() {
    return Form(
      key: formKey,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: Dim().d12,
          horizontal: Dim().d4,
        ),
        width: double.infinity,
        child: Row(
          children: [
            SizedBox(
              width: Dim().d12,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(
                  Dim().d16,
                ),
                decoration: BoxDecoration(
                  color: Clr().white,
                  border: Border.all(
                    color: const Color(0xFFE8E6EA),
                  ),
                  borderRadius: BorderRadius.circular(
                    Dim().d16,
                  ),
                ),
                child: TextField(
                  controller: messageCtrl,
                  onSubmitted: (value) {
                    send(messageCtrl.text);
                  },
                  style: Sty().mediumText,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type your message...',
                    hintStyle: Sty().mediumText.copyWith(
                          color: Clr().grey,
                        ),
                  ),
                ),
              ),
            ),
            Material(
              color: Clr().white,
              child: Container(
                decoration: BoxDecoration(
                  color: Clr().white,
                  border: Border.all(
                    color: const Color(0xFFE8E6EA),
                  ),
                  borderRadius: BorderRadius.circular(
                    Dim().d16,
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      send(messageCtrl.text);
                    }
                  },
                  color: Clr().primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
