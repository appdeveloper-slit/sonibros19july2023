import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sb/localstore.dart';
import 'package:sb/manage/static_method.dart';
import 'package:sb/sign_in.dart';
import 'package:sb/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bn_home.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'checkout.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class MyCart extends StatefulWidget {
  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  late BuildContext ctx;
  List<dynamic> addToCart = [];
  bool isLoading = true;
  String sTotalPrice = "0";

  String? sUserid;

  Future<void> _updateItem(
      idd, name, brand, image, price, actualPrice, counter) async {
    await Store.updateItem(
        idd, name, brand, image, price, actualPrice, counter);
  }

  void _refreshData() async {
    var data = await Store.getItems();
    var price = await Store.getTotalPrice();
    setState(() {
      addToCart = data;
      isLoading = false;
      sTotalPrice = price;
    });
  }

  @override
  void initState() {
    getSessionData();
    _refreshData();
    super.initState();
  }

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sUserid = sp.getString('user_id');
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
        bottomNavigationBar: bottomBarLayout(ctx, 0, addToCart.length),
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
            'My Cart',
            style: TextStyle(
                color: Clr().black,
                fontSize: Dim().d20,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Clr().white,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: Dim().d14,
              ),
              addToCart.length == 0
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Text(
                          'No product added',
                          style: Sty().mediumBoldText,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: addToCart.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dim().d8, vertical: Dim().d12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: Dim().d140,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Clr().lightGrey),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(Dim().d14),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: Dim().d100,
                                        margin: EdgeInsets.all(Dim().d8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(Dim().d16),
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                '${addToCart[index]['image'].toString()}'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: Dim().d12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: Dim().d140,
                                                  child: Text(
                                                    '${addToCart[index]['name'].toString()}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.start,
                                                    style: Sty()
                                                        .mediumBoldText
                                                        .copyWith(
                                                          color: Clr().black,
                                                          fontSize: Dim().d16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  '${addToCart[index]['brand'].toString()}',
                                                  style: TextStyle(
                                                      color: Color(0xff666666),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: Dim().d14),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: Dim().d8,
                                            ),
                                            SizedBox(
                                              height: 32,
                                              width: 116,
                                              child: Text(
                                                '\u20b9 ${addToCart[index]['price'].toString()}',
                                                style: Sty().smallText.copyWith(
                                                      color: Clr().black,
                                                      fontSize: Dim().d16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: Dim().d2,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                Store.deleteItem(
                                                  addToCart[index]['idd'],
                                                );
                                                _refreshData();
                                              });
                                            },
                                            icon: Icon(Icons.delete),
                                          ),
                                          Container(
                                            height: Dim().d40,
                                            decoration: BoxDecoration(
                                                color: Color(0xffEAEAEA),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        Dim().d12))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: Dim().d4,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      int counter =
                                                          addToCart[index]
                                                              ['counter'];
                                                      var acutal = int.parse(
                                                          addToCart[index][
                                                                  'actualPrice']
                                                              .toString());
                                                      var price = int.parse(
                                                          addToCart[index]
                                                                  ['price']
                                                              .toString());
                                                      counter--;
                                                      var newPrice =
                                                          price - acutal;
                                                      if (counter > 0) {
                                                        _updateItem(
                                                                addToCart[index]
                                                                    ['idd'],
                                                                addToCart[index]
                                                                        ['name']
                                                                    .toString(),
                                                                addToCart[index]
                                                                        [
                                                                        'brand']
                                                                    .toString(),
                                                                addToCart[index]
                                                                        [
                                                                        'image']
                                                                    .toString(),
                                                                newPrice
                                                                    .toString(),
                                                                addToCart[index]
                                                                        [
                                                                        'actualPrice']
                                                                    .toString(),
                                                                counter)
                                                            .then((value) {
                                                          newPrice = 0;
                                                          counter = 0;
                                                          _refreshData();
                                                        });
                                                      }
                                                    });
                                                  },
                                                  child: ClipOval(
                                                    child: Icon(Icons.remove,
                                                        color: Colors.black87),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: Dim().d8,
                                                ),
                                                Text(
                                                  '${addToCart[index]['counter']}',
                                                  style:
                                                      TextStyle(fontSize: 18.0),
                                                ),
                                                SizedBox(
                                                  width: Dim().d8,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      int counter =
                                                          addToCart[index]
                                                              ['counter'];
                                                      var acutal = int.parse(
                                                          addToCart[index][
                                                                  'actualPrice']
                                                              .toString());
                                                      var price = int.parse(
                                                          addToCart[index]
                                                                  ['price']
                                                              .toString());
                                                      counter++;
                                                      var newPrice =
                                                          price + acutal;
                                                      _updateItem(
                                                              addToCart[index]
                                                                  ['idd'],
                                                              addToCart[index]
                                                                      ['name']
                                                                  .toString(),
                                                              addToCart[index]
                                                                      ['brand']
                                                                  .toString(),
                                                              addToCart[index]
                                                                      ['image']
                                                                  .toString(),
                                                              newPrice
                                                                  .toString(),
                                                              addToCart[index][
                                                                      'actualPrice']
                                                                  .toString(),
                                                              counter)
                                                          .then((value) {
                                                        newPrice = 0;
                                                        counter = 0;
                                                        _refreshData();
                                                      });
                                                    });
                                                  },
                                                  child: ClipOval(
                                                    child: Icon(Icons.add,
                                                        color: Colors.black87),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: Dim().d4,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 1,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
              addToCart.length == 0
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dim().d36, vertical: Dim().d8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total (${addToCart.length} items) :',
                                style: Sty()
                                    .smallText
                                    .copyWith(color: Color(0xff666666)),
                              ),
                              Text(
                                '₹${sTotalPrice}',
                                style: Sty().largeText,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 60,
                          ),
                          SizedBox(
                            height: Dim().d52,
                            width: Dim().d320,
                            child: ElevatedButton(
                                onPressed: () {
                                  sUserid != null ? updateCart() : STM().finishAffinity(ctx, SignUp());
                                  sUserid == null ? Fluttertoast.showToast(msg: 'Login is required',textColor: Clr().white,gravity: ToastGravity.CENTER) : null;
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Proceed to checkout',
                                    ),
                                    Icon(Icons.arrow_forward_ios),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff2C2C2C),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  //Api Method
  updateCart() async {
    //Input
    FormData body = FormData.fromMap({
      'user_id': sUserid,
      'products': jsonEncode(addToCart),
    });
    //Output
    var result = await STM().post(ctx, Str().processing, "updateCartQty", body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (error == false) {
      setState(() {
        Map<String, dynamic> map = {
          "total": result['Total'],
          "grand_total": result['Total'] + result['shipping_cost'],
          "shipping_cost": result['shipping_cost'],
          "product_array": result['product_list'],
          "deposit": result['deposit'],
          "wallet_amount": result['wallet_amount'],
          "discount": 0,
          "donation_title": result['donation_title'],
          "is_donation": result['is_donation'],
        };
        STM().redirect2page(ctx, CheckOut(map));
        // isLoaded = true;
        // upcomingList = result['upcoming_appointments'];
        // todayList = result['completed_appointments'];
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
