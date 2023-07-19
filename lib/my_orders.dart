import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sb/bn_home.dart';
import 'package:sb/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manage/static_method.dart';
import 'order_details.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class MyOrders extends StatefulWidget {
  final bool isRedirect;

  MyOrders({super.key, required this.isRedirect});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  late BuildContext ctx;
  String? sUserid;
  List<dynamic> getOrderList = [];

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sUserid = sp.getString('user_id');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getOrder();
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
        if (widget.isRedirect) {
          STM().replacePage(ctx, Home());
        } else {
          STM().back2Previous(ctx);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          leading: InkWell(
            onTap: () {
              if (widget.isRedirect) {
                STM().replacePage(ctx, Home());
              } else {
                STM().back2Previous(ctx);
              }
            },
            child: Icon(
              Icons.arrow_back,
              color: Clr().black,
            ),
          ),
          title: Text(
            'My Orders',
            style: TextStyle(color: Clr().black, fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: Clr().white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                getOrderList.length == 0
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                            child: Text(
                          'No orders',
                          style: Sty().mediumText,
                        )),
                      )
                    : ListView.builder(
                        itemCount: getOrderList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              STM().redirect2page(
                                  ctx,
                                  OrderDetails(
                                    order_id:
                                        getOrderList[index]['id'].toString(),
                                    orderNumber: getOrderList[index]['order_no']
                                        .toString(),
                                  ));
                            },
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: Dim().d0, vertical: Dim().d8),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Clr().lightGrey),
                                  borderRadius:
                                      BorderRadius.circular(Dim().d12)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: Dim().d100,
                                      width: Dim().d100,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(Dim().d14)),
                                          border: Border.all(
                                              color: Clr().lightGrey),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              '${getOrderList[index]['feature_image'].toString()}',
                                            ),
                                            fit: BoxFit.contain,
                                          )),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${getOrderList[index]['order_no'].toString()}',
                                              style: Sty().mediumText.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                            Text(
                                              '${getOrderList[index]['status'].toString()}',
                                              style: Sty().mediumText.copyWith(
                                                    color: getOrderList[index]
                                                                ['status'] ==
                                                            'Ordered'
                                                        ? Clr().blue
                                                        : Clr().red,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          '${getOrderList[index]['product_count'].toString()} Product',
                                          style: TextStyle(
                                              color: Color(0xff666666)),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    '\u20b9 ${getOrderList[index]['final_amount'].toString()}',
                                                    style: Sty()
                                                        .mediumText
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        )),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              '${getOrderList[index]['date'].toString()}',
                                              style: TextStyle(
                                                  color: Color(0xff979797)),
                                            ))
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getOrder() async {
    FormData body = FormData.fromMap({
      'user_id': sUserid,
    });
    var result = await STM().post(ctx, Str().loading, 'my_orders', body);
    if (!mounted) return;
    setState(() {
      getOrderList = result;
    });
  }
}
