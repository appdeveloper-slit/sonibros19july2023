import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sb/values/colors.dart';
import 'package:sb/values/dimens.dart';
import 'package:sb/values/strings.dart';
import 'package:sb/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addadress.dart';
import 'bn_my_account.dart';
import 'manage/static_method.dart';

class MyAddress extends StatefulWidget {
MyAddress({Key? key}) : super(key: key);

  @override
  State<MyAddress> createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  late BuildContext ctx;
  String? sUserid, sAddressID;
  List<dynamic> getAddressList = [];

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sUserid = sp.getString('user_id') ?? "";
      sAddressID = sp.getString('address_id') ?? "";
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getAddress();
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
      backgroundColor: Clr().white,
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
          'My Address',
          style: TextStyle(color: Clr().black, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Clr().white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dim().d14),
          child: getAddressList == null
              ? Container()
              : getAddressList.length == 0
                  ? Column(
                      children: [
                        SizedBox(
                          height: Dim().d20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                STM().replacePage(ctx, AddAdress());
                              },
                              child: Container(
                                height: Dim().d52,
                                decoration: BoxDecoration(
                                  color: Clr().f6,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(Dim().d12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: Dim().d20,
                                    ),
                                    SvgPicture.asset('assets/add.svg'),
                                    SizedBox(
                                      width: Dim().d16,
                                    ),
                                    Text(
                                      'Add a new address',
                                      style: Sty().mediumText.copyWith(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: Dim().d20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                STM().replacePage(ctx, AddAdress());
                              },
                              child: Container(
                                height: Dim().d52,
                                decoration: BoxDecoration(
                                  color: Clr().f6,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(Dim().d12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: Dim().d20,
                                    ),
                                    SvgPicture.asset('assets/add.svg'),
                                    SizedBox(
                                      width: Dim().d16,
                                    ),
                                    Text(
                                      'Add a new address',
                                      style: Sty().mediumText.copyWith(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        ListView.builder(
                          itemCount: getAddressList.length,
                          shrinkWrap: true,
                          reverse: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return addresslayout(
                                context, index, getAddressList);
                          },
                        ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget addresslayout(context, index, list) {
    return Column(
      children: [
        SizedBox(
          height: Dim().d20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Clr().white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dim().d12),
                  ),
                  border: Border.all(color: Clr().ec),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: Dim().d16, top: Dim().d8, right: Dim().d16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            activeColor: Clr().primaryColor,
                            value: list[index]['id'].toString(),
                            groupValue: sAddressID,
                            onChanged: (v) async {
                              SharedPreferences sp =
                                  await SharedPreferences.getInstance();
                              sp.setString('address_id', v!);
                              setState(() {
                                sAddressID = list[index]['id'].toString();
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              '${list[index]['name'].toString()}',
                              style: Sty().mediumText,
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  STM().replacePage(
                                      ctx,
                                      AddAdress(
                                        stype: 'update',
                                        addressid: list[index]['id'].toString(),
                                      ));
                                },
                                child: SvgPicture.asset(
                                  'assets/Vector.svg',
                                  height: Dim().d16,
                                ),
                              ),
                              SizedBox(
                                width: Dim().d12,
                              ),
                              InkWell(
                                onTap: () {
                                  deleteAddress(list[index]['id'].toString());
                                },
                                child: SvgPicture.asset(
                                  'assets/delete.svg',
                                  height: Dim().d16,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: Dim().d8,
                      ),
                      Text(
                        '+91 ${list[index]['mobile'].toString()}',
                        style: Sty().mediumText,
                      ),
                      SizedBox(
                        height: Dim().d8,
                      ),
                      Text(
                        '${list[index]['landmark'].toString() + ",  " + list[index]['address'].toString() + ",  " + " " + list[index]['country'].toString() + ' ' + list[index]['pincode'].toString()}',
                        overflow: TextOverflow.fade,
                        style: Sty().mediumText,
                      ),
                      SizedBox(
                        height: Dim().d8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void getAddress() async {
    FormData body = FormData.fromMap({
      'user_id': sUserid,
    });
    var result =
        await STM().post(ctx, Str().loading, 'get_user_addresses', body);
    if (!mounted) return;
    setState(() {
      getAddressList = result;
    });
  }

  void deleteAddress(id) async {
    FormData body = FormData.fromMap({
      'id': id,
    });
    var result = await STM().post(ctx, Str().loading, 'delete_address', body);
if (!mounted) return;
    SharedPreferences sp = await SharedPreferences.getInstance();
    var error = result['error'];
    var message = result['message'];
    if (error == false) {
      setState(() {
        if (id == sp.getString("address_id")) {
          sp.remove("address_id");
        }
        STM().successDialog(ctx, message, widget);
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
