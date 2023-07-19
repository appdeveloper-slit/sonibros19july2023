import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sb/values/strings.dart';

import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class OrderedProducts extends StatefulWidget {
  String? order_id;

  OrderedProducts({super.key, this.order_id});

  @override
  State<OrderedProducts> createState() => _OrderedProductsState();
}

class _OrderedProductsState extends State<OrderedProducts> {
  late BuildContext ctx;
  List<dynamic> orderList = [];

  getSessionData() async {
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getOrderDetails();
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
        elevation: 3,
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
          'Ordered Products',
          style: TextStyle(color: Clr().black, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Clr().white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListView.builder(
                itemCount: orderList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // STM().redirect2page(ctx, OrderDetails());
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(
                          horizontal: Dim().d0, vertical: Dim().d8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dim().d12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: Dim().d100,
                              width: Dim().d100,
                              margin: EdgeInsets.only(right: Dim().d12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(Dim().d14),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        '${orderList[index]['product']['feature_image'].toString()}'),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                                child: Column(
                              children: [
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '${orderList[index]['product']['name']}',
                                  style: Sty().mediumText.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Text('Qty',
                                        style: Sty().smallText.copyWith(
                                              fontWeight: FontWeight.w500,
                                            )),
                                    SizedBox(
                                      width: 38,
                                    ),
                                    Text(
                                      ':',
                                      style: Sty().mediumText,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                        '${orderList[index]['product']['qty']}',
                                        style: Sty().smallText.copyWith(
                                              fontWeight: FontWeight.w500,
                                            )),
                                  ],
                                ),

                                SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  children: [
                                    Text('Amount',
                                        style: Sty().smallText.copyWith(
                                              fontWeight: FontWeight.w500,
                                            )),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      ':',
                                      style: Sty().mediumText,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                        '₹${orderList[index]['product']['set_price']}',
                                        style: Sty().smallText.copyWith(
                                              fontWeight: FontWeight.w500,
                                            )),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        returnProduct();
                                      },
                                      child: Text(
                                        'Return',
                                        style: TextStyle(
                                            fontSize: Dim().d14,
                                            fontWeight: FontWeight.w500,
                                            color: Clr().linkColor),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 6,
                                )
                                // Row(
                                //   children: [
                                //     Expanded(
                                //       child: Padding(
                                //         padding: EdgeInsets.all(Dim().d8),
                                //         child:Text('Qty',
                                //             style:
                                //             Sty().smallText.copyWith(
                                //               fontWeight:
                                //               FontWeight.w500,
                                //             )),
                                //       ),
                                //     ),
                                //     SizedBox(
                                //       width: 4,
                                //     ),
                                //     Text(':'),
                                //     SizedBox(
                                //       width: 4,
                                //     ),
                                //     Expanded(
                                //       child: Padding(
                                //         padding: EdgeInsets.all(Dim().d8),
                                //         child: Text('1'),
                                //       ),
                                //     ),
                                //   ],
                                // ),
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
    );
  }

  void getOrderDetails() async {
    FormData body = FormData.fromMap({
      'order_id': widget.order_id,
    });
    var result = await STM().post(ctx, Str().loading, 'order_products', body);
    if (!mounted) return;
    setState(() {
      orderList = result;
    });
  }

  void returnProduct() async {
    FormData body = FormData.fromMap({
      'order_id': widget.order_id,
    });
    var result = await STM().post(ctx, Str().loading, 'return_product', body);
    if (!mounted) return;
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithReplace(ctx, message, widget);
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
