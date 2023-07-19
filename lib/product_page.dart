import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sb/manage/static_method.dart';
import 'package:sb/values/dimens.dart';
import 'package:sb/values/strings.dart';
import 'package:sb/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bn_home.dart';
import 'localstore.dart';
import 'values/colors.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProductPage extends StatefulWidget {
String? productid;

ProductPage({
    super.key,
    this.productid,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late BuildContext ctx;
  List<dynamic> imageList = [];
  dynamic productDetails;
  List<dynamic> addToCart = [];
  bool isLoading = true;
  String? sUserid;

  Future<void> _updateItem(
      idd, name, brand, image, price, actualPrice, counter) async {
    await Store.updateItem(
        idd, name, brand, image, price, actualPrice, counter);
  }

  void _refreshData() async {
    var data = await Store.getItems();
    setState(() {
      addToCart = data;
      isLoading = false;
    });
  }

  Future<void> _addItem(
   idd, name, brand, image, price, actualPrice, counter) async {
    await Store.createItem(
    idd, name, brand, image, price, actualPrice, counter);
  }

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sUserid = sp.getString('user_id');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getProductDetails();
        _refreshData();
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
        STM().replacePage(ctx, Home());
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Clr().transparent,
          body: SlidingUpPanel(
            minHeight: MediaQuery.of(context).size.height * 0.6,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(Dim().d28),
                topLeft: Radius.circular(Dim().d28)),
            body: Column(
              children: [
                Stack(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(viewportFraction: 1, height: 400
                          // enableInfiniteScroll: true,
                          // autoPlay: true,
                          ),
                      items: imageList
                          .map((e) => ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  e['image_path'].toString(),
                                  fit: BoxFit.contain,
                                ),
                              ))
                          .toList(),
                    ),
                    Positioned(
                        top: 220,
                        right: 20,
                        child: InkWell(
                            onTap: () {
                              // STM().redirect2page(ctx, Wishlist());
                            },
                            child: SvgPicture.asset('assets/like.svg'))),
                  ],
                ),
              ],
            ),
            panelBuilder: (sc) =>
                productDetails == null ? Container() : _pannel(sc),
          ),
        ),
      ),
    );
  }

  Widget _pannel(ScrollController sc) {
    int position = addToCart
        .indexWhere((element) => element['idd'] == productDetails['id']);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Dim().d250,
                      child: Text(
                        '${productDetails['name'].toString()}',
                        overflow: TextOverflow.fade,
                        style: Sty().mediumBoldText.copyWith(
                              fontSize: Dim().d20,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${productDetails['brand'].toString()}',
                      style: TextStyle(
                        color: Color(0xff666666),
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                addToCart.map((e) => e['idd']).contains(productDetails['id'])
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                int counter = addToCart[position]['counter'];
                                var acutal = int.parse(addToCart[position]
                                        ['actualPrice']
                                    .toString());
                                var price = int.parse(
                                    addToCart[position]['price'].toString());
                                counter == 1
                                    ? Store.deleteItem(
                                        addToCart[position]['idd'])
                                    : counter--;
                                var newPrice = price - acutal;
                                if (counter > 0) {
                                  _updateItem(
                                          addToCart[position]['idd'],
                                          addToCart[position]['name']
                                              .toString(),
                                          addToCart[position]['brand']
                                              .toString(),
                                          addToCart[position]['image']
                                              .toString(),
                                          newPrice.toString(),
                                          addToCart[position]['actualPrice']
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
                            child: Container(
                                height: Dim().d28,
                                width: Dim().d28,
                                decoration: BoxDecoration(
                                    color: Color(0xffEAEAEA),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dim().d52))),
                                child: ClipOval(
                                  child:
                                      Icon(Icons.remove, color: Colors.black87),
                                )),
                          ),
                          SizedBox(
                            width: Dim().d8,
                          ),
                          Text(
                            '${addToCart[position]['counter']}',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          SizedBox(
                            width: Dim().d8,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                int counter = addToCart[position]['counter'];
                                var acutal = int.parse(addToCart[position]
                                        ['actualPrice']
                                    .toString());
                                var price = int.parse(
                                    addToCart[position]['price'].toString());
                                counter++;
                                var newPrice = price + acutal;
                                _updateItem(
                                        addToCart[position]['idd'],
                                        addToCart[position]['name'].toString(),
                                        addToCart[position]['brand'].toString(),
                                        addToCart[position]['image'].toString(),
                                        newPrice.toString(),
                                        addToCart[position]['actualPrice']
                                            .toString(),
                                        counter)
                                    .then((value) {
                                  newPrice = 0;
                                  counter = 0;
                                  _refreshData();
                                });
                              });
                            },
                            child: Container(
                                height: Dim().d28,
                                width: Dim().d28,
                                decoration: BoxDecoration(
                                    color: Color(0xffEAEAEA),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dim().d52))),
                                child: ClipOval(
                                  child: Icon(Icons.add, color: Colors.black87),
                                )),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
            SizedBox(
              height: 28,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Description',
                style: Sty().mediumBoldText.copyWith(
                      fontSize: Dim().d20,
                    ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Html(
                data: '${productDetails['description'].toString()}',
                shrinkWrap: true,
                style: {
                  "body": Style(
                    fontSize: FontSize(16.0),
                    fontWeight: FontWeight.w400,
                    color: Color(0xff666666),
                  )
                }),
            SizedBox(
              height: 28,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '\u20b9 ${productDetails['set_price'].toString()}',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
                    )
                  ],
                ),
                SizedBox(
                  width: 60,
                ),
                addToCart.map((e) => e['idd']).contains(productDetails['id'])
                    ? Container()
                    : SizedBox(
                        height: 40,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            _refreshData();
                            _addItem(
                              productDetails['id'],
                              productDetails['name'].toString(),
                              productDetails['brand'].toString(),
                              productDetails['feature_image'].toString(),
                              productDetails['set_price'].toString(),
                              productDetails['set_price'].toString(),
                              1,
                            ).then((value) {
                              _refreshData();
                            });
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/cart.svg'),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Add to cart',
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff2C2C2C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getProductDetails() async {
    FormData body = FormData.fromMap({
      'id': widget.productid,
    });
    var result = await STM().post(ctx, Str().loading, 'product_details', body);
if (!mounted) return;
    setState(() {
      productDetails = result['data'];
      imageList = result['data']['product_image'];
    });
  }
}
