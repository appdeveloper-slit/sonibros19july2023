import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sb/localstore.dart';
import 'package:sb/my_orders.dart';
import 'package:sb/myaddress.dart';
import 'package:sb/values/styles.dart';
import 'package:sb/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'coupons.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';

class CheckOut extends StatefulWidget {
  Map<String, dynamic> data;

  CheckOut(this.data, {Key? key}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  late BuildContext ctx;
  Map<String, dynamic> v = {};
  bool isChecked = false;
  String? sType, sUserid, sAddressID = "";

  List<dynamic> paymentList = ["Cash on Delivery", "Online Payment"];
  String? sPayment;

  List<dynamic> donationList = [100, 200, 500, "Custom"];
  int selectedDonation = -1;
  TextEditingController donationCtrl = TextEditingController(text: "0");

  GlobalKey<FormFieldState> couponKey = GlobalKey<FormFieldState>();
  TextEditingController couponCodeCtrl = TextEditingController();
  bool isApplied = false;
  String? sCouponMessage;

  @override
  void initState() {
    v = widget.data;
    getSessionData();
    super.initState();
  }

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sType = sp.getString('country');
      sUserid = sp.getString('user_id');
      sAddressID = sp.getString('address_id') ?? "";
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
          'Check Out',
          style: TextStyle(color: Clr().black, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Clr().white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          children: [
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(13)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product',
                      style: Sty().largeText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            // fontFamily: Outfit
                          ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: v['product_array'].length,
                      itemBuilder: (context, index) {
                        var v2 = v['product_array'][index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Text(
                                  '${v2['name']}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                'x${v2['qty']}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '₹${v2['total']}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )),
                                  flex: 3),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: 280,
              height: 55,
              child: ElevatedButton(
                  onPressed: () {
                    STM().redirect2page(ctx, MyAddress());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2C2C2C),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        sAddressID!.isEmpty
                            ? 'Select delivery address'
                            : 'Change delivery address',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              height: 12,
            ),
            Card(
              color: const Color(0xffF6F6F6),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: couponKey,
                        readOnly: isApplied,
                        controller: couponCodeCtrl,
                        cursorColor: Clr().primaryColor,
                        style: Sty().mediumText,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration: Sty().textFieldWhiteStyle.copyWith(
                              hintStyle: Sty().mediumText.copyWith(
                                    color: Clr().lightGrey,
                                  ),
                              hintText: "Enter Coupon Code",
                            ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Str().invalidCode;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: Dim().d12,
                    ),
                    SizedBox(
                      child: ElevatedButton(
                          onPressed: () {
                            if (isApplied) {
                              setState(() {
                                sCouponMessage = null;
                                couponCodeCtrl.clear();
                                isApplied = false;
                                var ta = v['total'];
                                var sc = v['shipping_cost'];
                                var da = selectedDonation == 3
                                    ? int.parse(donationCtrl.text.trim())
                                    : donationList[selectedDonation];
                                var fa = ta + sc + da;
                                v.update("discount", (value) => 0);
                                v.update("grand_total", (value) => fa);
                              });
                            } else {
                              if (couponKey.currentState!.validate()) {
                                apply();
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isApplied ? 'UNAPPLY' : 'APPLY',
                                style: const TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff2C2C2C),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)))),
                    ),
                  ],
                ),
              ),
            ),
            if (sCouponMessage != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  sCouponMessage ?? "",
                  style: Sty().smallText.copyWith(
                        color: isApplied ? Clr().green : Clr().red,
                      ),
                ),
              ),
            SizedBox(
              height: Dim().d12,
            ),
            Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                    onTap: () {
                      STM().redirect2page(ctx, Coupons());
                    },
                    child: const Text('view all coupon',
                        style: TextStyle(fontSize: 14)))),
            const SizedBox(
              height: 12,
            ),
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(13)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dim().d12, vertical: Dim().d28),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Price Summary',
                        style: Sty().largeText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              // fontFamily: Outfit
                            ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sub Total',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '₹${v['total']}',
                          ),
                        ],
                      ),
                    ),
                    if (isApplied)
                      const SizedBox(
                        height: 8,
                      ),
                    if (isApplied)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Discount',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Text('- ₹${v['discount']}'),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Shipping',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text('₹${v['shipping_cost']}'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Advance (20%)',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                              '₹${(v['grand_total'] / 100 * 20).toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                    if (isChecked)
                      const SizedBox(
                        height: 8,
                      ),
                    if (isChecked)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Wallet',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Text('- ₹${v['wallet_amount']}'),
                          ],
                        ),
                      ),
                    if (selectedDonation > -1)
                      const SizedBox(
                        height: 8,
                      ),
                    if (selectedDonation > -1)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Donation',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Text(
                                '₹${selectedDonation != 3 ? donationList[selectedDonation] : donationCtrl.text.trim()}'),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(
                      height: 2,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Payable Amount',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            isChecked
                                ? '₹${((v['grand_total'] - v['grand_total'] / 100 * 20) - int.parse(v['wallet_amount'])).toStringAsFixed(2)}'
                                : '₹${(v['grand_total'] - v['grand_total'] / 100 * 20).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Final Total',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            isChecked
                                ? '₹${(v['grand_total'] - int.parse(v['wallet_amount'])).toStringAsFixed(2)}'
                                : '₹${v['grand_total'].toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (v['is_donation'])
              const SizedBox(
                height: 12,
              ),
            if (v['is_donation'])
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dim().d12, vertical: Dim().d28),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Donation',
                          style: Sty().largeText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                // fontFamily: Outfit
                              ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                        child: Column(
                          children: [
                            Text(
                              "${v['donation_title']}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: donationList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisExtent: Dim().d40,
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedDonation = index;
                                      var ta = v['total'];
                                      var sc = v['shipping_cost'];
                                      var dis = v['discount'];
                                      var da = index == 3
                                          ? int.parse(donationCtrl.text.trim())
                                          : donationList[index];
                                      var fa = ta + sc + da - dis;
                                      v.update("grand_total", (value) => fa);
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: Dim().d4,
                                      horizontal: Dim().d4,
                                    ),
                                    decoration: BoxDecoration(
                                        color: index == selectedDonation
                                            ? Clr().black
                                            : Clr().white,
                                        border: Border.all(
                                            color: const Color(0xff666666)),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                      child: Text(
                                        '${index != 3 ? "₹" : ""}${donationList[index]}',
                                        style: Sty().smallText.copyWith(
                                              color: index == selectedDonation
                                                  ? Clr().white
                                                  : Clr().black,
                                            ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            if (selectedDonation == 3)
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: donationCtrl,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                        hintText: 'Enter Amount',
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Color(0xff666666)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Color(0xff666666)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  SizedBox(
                                    width: 90,
                                    height: 44,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          var ta = v['total'];
                                          var sc = v['shipping_cost'];
                                          var da = int.parse(
                                              donationCtrl.text.trim());
                                          var fa = ta + sc + da;
                                          v.update(
                                              "grand_total", (value) => fa);
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xff2C2C2C),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Confirm',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (v['wallet_amount'] != '0')
              const SizedBox(
                height: 8,
              ),
            if (v['wallet_amount'] != '0')
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.all(Clr().primaryColor),
                    value: isChecked,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                      child: Text(
                    'Use wallet balance  (₹${v['wallet_amount']})',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                    overflow: TextOverflow.fade,
                  ))
                ],
              ),
            Card(
              shape: const RoundedRectangleBorder(
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
                        'Payment Options',
                        style: Sty().largeText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'outfit'
                            // fontFamily: Outfit
                            ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Container(
                      color: Clr().white,
                      child: Column(
                        children: [
                          RadioListTile<dynamic>(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: Dim().d2,
                            ),
                            activeColor: Clr().primaryColor,
                            value: "COD",
                            groupValue: sPayment,
                            onChanged: (value) {
                              setState(() {
                                sPayment = value!;
                              });
                            },
                            title: Transform.translate(
                              offset: const Offset(-6, 0),
                              child: Text(
                                paymentList[0],
                                style: Sty().mediumText,
                              ),
                            ),
                          ),
                          RadioListTile<dynamic>(
                            dense: true,
                            contentPadding: EdgeInsets.all(Dim().d0),
                            activeColor: Clr().primaryColor,
                            value: "Online",
                            groupValue: sPayment,
                            onChanged: (value) {
                              setState(() {
                                sPayment = value!;
                              });
                            },
                            title: Transform.translate(
                              offset: const Offset(-6, 0),
                              child: Text(
                                paymentList[1],
                                style: Sty().mediumText.copyWith(
                                      fontFamily: 'outfit',
                                    ),
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
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 280,
              height: 55,
              child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    if (!mounted) return;
                    // if (sAddressID!.isNotEmpty) {
                    if (sPayment != null) {
                      int wallet =
                          isChecked ? int.parse(v['wallet_amount']) : 0;
                      int donation = selectedDonation > -1
                          ? selectedDonation == 3
                              ? donationCtrl.text.trim()
                              : donationList[selectedDonation]
                          : 0;
                      int total = sPayment == "COD"
                          ? (v['grand_total'] * 0.20).round()
                          : v['grand_total'];
                      int discount = v['discount'];
                      String sCouponID = couponCodeCtrl.text.trim() ?? "";
                      String sAddressID = sp.getString('address_id') ?? "";
                      int paidAmount = sPayment == "COD"
                          ? (v['grand_total'] * 0.20).round()
                          : 0;
                      int deliveryCharges = v['shipping_cost'];
                      String sMethod = sType == 'indian' ? '1' : '2';
                      String sUrl =
                          'https://sonibro.com/pay_parameter?method=$sMethod&user_id=$sUserid&total=$total&discount=$discount&coupon_id=$sCouponID&paid_amount=$paidAmount&wallet_payment=$wallet&delivery_charges=$deliveryCharges&donation=$donation&address_id=$sAddressID&pay_mode=$sPayment&weight=1';
                      STM().redirect2page(ctx, WebViewPage(sUrl));
                    } else {
                      STM().displayToast("Please Select Payment Mode");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2C2C2C),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Place Order',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  //Api method
  void apply() async {
    //Input
    FormData body = FormData.fromMap({
      'user_id': sUserid,
      'coupon_name': couponCodeCtrl.text.trim(),
      'order_amt': v['grand_total'],
    });
    //Output
    var result = await STM().post(ctx, Str().loading, "apply_coupon", body);
    if (!mounted) return;
    setState(() {
      var error = result['error'];
      sCouponMessage = result['message'];
      if (!error) {
        FocusManager.instance.primaryFocus!.unfocus();
        isApplied = true;
        int da = result['discount_amount'];
        int fa = result['final_amount'];
        v.update("discount", (value) => da);
        v.update("grand_total", (value) => fa);
      }
    });
  }

  //Api method
  void placeOrder() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (!mounted) return;
    //Input
    FormData body = FormData.fromMap({
      'txn_id': "ABCDEFG",
      'user_id': sUserid,
      'total': isChecked
          ? v['grand_total'] - int.parse(v['wallet_amount'])
          : v['grand_total'],
      'discount': v['discount'],
      'coupon_id': couponCodeCtrl.text.trim(),
      'paid_amount':
          sPayment == "COD" ? v['grand_total'] * 0.20 : v['grand_total'],
      'wallet_payment': isChecked ? v['wallet_amount'] : 0,
      'delivery_charges': v['shipping_cost'],
      'donation': selectedDonation > -1
          ? selectedDonation == 3
              ? donationCtrl.text.trim()
              : donationList[selectedDonation]
          : "",
      'address_id': sp.getString('address_id'),
      'pay_mode': sPayment,
      'weight': "1",
    });
    //Output
    var result = await STM().post(ctx, Str().processing, "place_order", body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (!error) {
      setState(() async {
        await Store.deleteAll();
        if (!mounted) return;
        STM().successDialogWithAffinity(
          ctx,
          message,
          MyOrders(
            isRedirect: true,
          ),
        );
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
