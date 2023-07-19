import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb/chat.dart';
import 'package:sb/values/strings.dart';

import 'manage/static_method.dart';
import 'ordered_products.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class OrderDetails extends StatefulWidget {
  String? order_id, orderNumber;

  OrderDetails({super.key, this.order_id, this.orderNumber});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late BuildContext ctx;
  dynamic? getOrderDetailsResult;
  dynamic? resultData;
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
          'Order Details',
          style: TextStyle(color: Clr().black, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Clr().white,
      ),
      body: resultData == null
          ? Container()
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Products (${orderList.length} items)',
                        style: Sty().largeText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              // fontFamily: Outfit
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: Dim().d80,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            orderList.length > 2 ? 2 + 1 : orderList.length + 1,
                        itemBuilder: (context, index) {
                          return index == orderList.length
                              ? Padding(
                                  padding: EdgeInsets.only(left: Dim().d28),
                                  child: InkWell(
                                    onTap: () {
                                      STM().redirect2page(
                                          ctx,
                                          OrderedProducts(
                                            order_id: widget.order_id,
                                          ));
                                    },
                                    child: SvgPicture.asset(
                                      'assets/arrow.svg',
                                      height: Dim().d20,
                                      width: Dim().d20,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: Dim().d80,
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
                                );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dim().d12, vertical: Dim().d12),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Delivery Details',
                              style: Sty().largeText.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    // fontFamily: Outfit
                                  ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Address',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                getOrderDetailsResult == null
                                    ? Container()
                                    : Text(
                                        '${getOrderDetailsResult['landmark']}, ${getOrderDetailsResult['address']} ${getOrderDetailsResult['pincode']}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                // horizontal list for donation
                                SizedBox(
                                  height: 12,
                                ),
                                getOrderDetailsResult['delivery_date'] == null
                                    ? Container()
                                    : Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Delivery Date',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                      ),
                                getOrderDetailsResult['delivery_date'] == null
                                    ? Container()
                                    : SizedBox(
                                        height: 4,
                                      ),
                                getOrderDetailsResult['delivery_date'] == null
                                    ? Container()
                                    : Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '22/02/22',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dim().d12, vertical: Dim().d12),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Order Summary',
                              style: Sty().largeText.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    // fontFamily: Outfit
                                  ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sub Total (Inc.GST)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text('₹ ${resultData['sub_total']}'),
                              ],
                            ),
                          ),
                          if (resultData['discount'] != "0")
                            SizedBox(
                              height: 8,
                            ),
                          if (resultData['discount'] != "0")
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: Dim().d4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Discount',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text('₹ ${resultData['discount']}'),
                                ],
                              ),
                            ),
                          SizedBox(
                            height: 8,
                          ),
                          Divider(),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total (Exc.GST)',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text('₹ ${resultData['total']}'),
                              ],
                            ),
                          ),
                          if (getOrderDetailsResult['donation'] != "0")
                            SizedBox(
                              height: 8,
                            ),
                          if (getOrderDetailsResult['donation'] != "0")
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: Dim().d4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Donation',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                      '₹ ${getOrderDetailsResult['donation']}'),
                                ],
                              ),
                            ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Charges',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text('₹ ${resultData['delivery_charges']}'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'GST',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text('₹ ${resultData['gst']}'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Final Total',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text('₹ ${resultData['final_total']}'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Payment Mode',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text('${getOrderDetailsResult['pay_mode']}'),
                              ],
                            ),
                          ),
                          if (getOrderDetailsResult['wallet_payment'] != "0")
                            SizedBox(
                              height: 8,
                            ),
                          if (getOrderDetailsResult['wallet_payment'] != "0")
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: Dim().d4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Wallet',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                      '₹ ${getOrderDetailsResult['wallet_payment']}'),
                                ],
                              ),
                            ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Advance (20%)',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                    '₹ ${double.parse(getOrderDetailsResult['paid_amount']).toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Remaining Payment',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text('₹ ${resultData['remaining_payment']}'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 280,
                        height: 55,
                        child: ElevatedButton(
                            onPressed: () {
                              // print('Invoice : ${getOrderDetailsResult['invoice_path']}');
                              STM().openWeb(
                                  getOrderDetailsResult['invoice_path']);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Download Invoice',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff2C2C2C),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 280,
                        height: 55,
                        child: ElevatedButton(
                            onPressed: () {
                              STM()
                                  .checkInternet(context, widget)
                                  .then((value) {
                                if (value) {
                                  trackOrder();
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Track Order',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Clr().black),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Clr().black,
                                  size: 20,
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffffffff),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color(0xff2C2C2C),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ))),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 280,
                        height: 55,
                        child: ElevatedButton(
                            onPressed: () {
                              STM().redirect2page(
                                  ctx,
                                  Chat("0", "SB Support", "",
                                      widget.orderNumber!));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Need Help',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Clr().black),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Clr().black,
                                  size: 20,
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffffffff),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color(0xff2C2C2C),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  void getOrderDetails() async {
    FormData body = FormData.fromMap({
      'order_id': widget.order_id,
    });
    var result = await STM().post(ctx, Str().loading, 'order_details', body);
    if (!mounted) return;
    setState(() {
      resultData = result;
      getOrderDetailsResult = result['order_details'];
      orderList = getOrderDetailsResult['order_products'];
    });
  }

  void trackOrder() async {
    FormData body = FormData.fromMap({
      'order_id': widget.order_id,
    });
    var result = await STM().post(ctx, Str().loading, 'track_order', body);
    if (!mounted) return;
    var success = result['success'];
    var message = result['message'];
    if (success) {
      AwesomeDialog dialog = STM().modalDialog(
          ctx,
          track(result['order']['status'], result['order']['location'],
              result['order']['timestamp']),
          Clr().white);
      dialog.show();
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  Widget track(status, location, date) {
    return Padding(
      padding: EdgeInsets.all(
        Dim().d20,
      ),
      child: Column(
        children: [
          Text(
            'Tracking Detail',
            style: Sty().largeText,
          ),
          SizedBox(
            height: Dim().d20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status :',
                style: Sty().mediumBoldText,
              ),
              Text(
                status,
                style: Sty().smallText,
              ),
            ],
          ),
          SizedBox(
            height: Dim().d8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Location :',
                style: Sty().mediumBoldText,
              ),
              Text(
                location,
                style: Sty().smallText,
              ),
            ],
          ),
          SizedBox(
            height: Dim().d8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date :',
                style: Sty().mediumBoldText,
              ),
              Text(
                date,
                style: Sty().smallText,
              ),
            ],
          ),
          SizedBox(
            height: Dim().d32,
          ),
        ],
      ),
    );
  }
}
