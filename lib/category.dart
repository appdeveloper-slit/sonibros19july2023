import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sb/values/dimens.dart';
import 'package:sb/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'bn_home.dart';
import 'localstore.dart';
import 'manage/static_method.dart';
import 'notifications.dart';
import 'product_page.dart';
import 'values/colors.dart';
import 'values/styles.dart';

StreamController<String?> controller = StreamController<String?>.broadcast();

class Category extends StatefulWidget {
  String? categoryId;

  Category({super.key, this.categoryId});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late BuildContext ctx;
  List<dynamic> productList = [];
  dynamic name;
  List<dynamic> listname = [];
  List sortname = ['Low to High', 'High to Low', 'Latest'];
  String? sortvalue;
  double? rangevalue;
  double? maxvalue;
  int _selectedIndex = 0;
  String? sCategoryID;
  int sortnamevalue = 0;
  SfRangeValues _values = SfRangeValues(1000.0, 1000.0);
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
        getCategory();
        _refreshData();
        getHome();
      }
    });
  }

  @override
  void initState() {
    sCategoryID = widget.categoryId;
    getSessionData();
    controller.stream.listen(
      (event) {
        setState(() {
          name = event;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      appBar: AppBar(
          title: InkWell(
              onTap: () {
                STM().redirect2page(ctx, Home());
              },
              child: Padding(
                padding: const EdgeInsets.all(90),
                child: Center(child: Image.asset('assets/homelogo.png')),
              )),
          centerTitle: true,
          backgroundColor: Clr().white,
          actions: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: InkWell(
                      onTap: () {
                        STM().redirect2page(ctx, NotificationPage());
                      },
                      child: SvgPicture.asset('assets/bell.svg')),
                ),
                SizedBox(
                  width: 12,
                )
              ],
            )
          ]),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('${name == null ? '' : name}',
                          style: Sty().extraLargeText.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w700))),
                  SizedBox(
                    width: 170,
                  ),
                  InkWell(
                      onTap: () {
                        _bottomSheet();
                      },
                      child: SvgPicture.asset('assets/sort.svg'))
                ],
              ),
            ),
            SizedBox(
              height: Dim().d4,
            ),
            productList.length == 0
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Text(
                        'No products available',
                        style: Sty().mediumText,
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: productList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 5 / 9),
                    itemBuilder: (context, index) {
                      return cardLayout(context, index, productList);
                    })
          ],
        ),
      ),
    );
  }

  Widget cardLayout(context, index, list) {
    int position =
        addToCart.indexWhere((element) => element['idd'] == list[index]['id']);
    return Padding(
      padding: EdgeInsets.all(Dim().d8),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              STM().redirect2page(
                  ctx,
                  ProductPage(
                    productid: list[index]['id'].toString(),
                  ));
            },
            child: Container(
              height: Dim().d200,
              width: Dim().d160,
              decoration: BoxDecoration(
                border: Border.all(color: Clr().lightGrey),
                borderRadius: BorderRadius.all(
                  Radius.circular(Dim().d16),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      '${list[index]['feature_image'].toString()}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          SizedBox(
            width: Dim().d120,
            child: Text(
              '${list[index]['name'].toString()}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: Sty().mediumBoldText.copyWith(
                    color: Clr().black,
                  ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            '${list[index]['brand'].toString()}',
            style: TextStyle(
                color: Color(0xff666666),
                fontWeight: FontWeight.w400,
                fontSize: 12),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d20),
            child: addToCart.map((e) => e['idd']).contains(list[index]['id'])
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            int counter = addToCart[position]['counter'];
                            var acutal = int.parse(
                                addToCart[position]['actualPrice'].toString());
                            var price = int.parse(
                                addToCart[position]['price'].toString());
                            counter == 1
                                ? Store.deleteItem(addToCart[position]['idd'])
                                : counter == 1
                                    ? Store.deleteItem(
                                        addToCart[position]['idd'])
                                    : counter == 1
                                        ? Store.deleteItem(
                                            addToCart[position]['idd'])
                                        : counter--;
                            var newPrice = price - acutal;
                            if (counter > 0) {
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
                              child: Icon(Icons.remove, color: Colors.black87),
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
                            var acutal = int.parse(
                                addToCart[position]['actualPrice'].toString());
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
                : SizedBox(
                    height: 32,
                    child: ElevatedButton(
                        onPressed: () {
                          // STM().redirect2page(ctx, ProductPage());
                          setState(() {
                            _refreshData();
                            _addItem(
                              list[index]['id'],
                              list[index]['name'].toString(),
                              list[index]['brand'].toString(),
                              list[index]['feature_image'].toString(),
                              list[index]['set_price'].toString(),
                              list[index]['set_price'].toString(),
                              1,
                            ).then((value) {
                              _refreshData();
                            });
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\u20b9 ${list[index]['price'].toString()}',
                            ),
                            Icon(
                              Icons.add,
                              size: 16,
                            )
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff2C2C2C))),
                  ),
          )
        ],
      ),
    );
  }

  Future _bottomSheet() {
    _selectedIndex = listname.indexWhere((element) => element['name'] == name);
    return showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dim().d20),
          topRight: Radius.circular(Dim().d20),
        ),
      ),
      context: ctx,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter changeme) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Dim().d20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Filter',
                      style: Sty().mediumBoldText.copyWith(fontSize: Dim().d28),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Text(
                  'Categories',
                  style: Sty().mediumBoldText.copyWith(fontSize: Dim().d20),
                ),
                SizedBox(
                  height: Dim().d12,
                ),
                Container(
                  height: Dim().d40,
                  child: ListView.builder(
                      itemCount: listname.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              changeme(() {
                                _selectedIndex = index;
                                controller.sink.add(listname[index]['name']);
                                sCategoryID = listname[index]['id'].toString();
                              });
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: Dim().d12),
                            child: Container(
                              width: Dim().d68,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Clr().lightGrey),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(Dim().d12),
                                  ),
                                  color: _selectedIndex == index
                                      ? Clr().black
                                      : null),
                              child: Center(
                                child: Text(
                                  listname[index]['name'].toString(),
                                  style: Sty().mediumText.copyWith(
                                        color: _selectedIndex == index
                                            ? Clr().white
                                            : Color(0xff666666),
                                      ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: Dim().d12,
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Text(
                  'Price Range',
                  style: Sty().mediumBoldText.copyWith(fontSize: Dim().d20),
                ),
                SfRangeSlider(
                  max: 10000,
                  min: 1000,
                  values: _values,
                  interval: 2000,
                  showTicks: true,
                  showLabels: true,
                  activeColor: Clr().black,
                  numberFormat: NumberFormat("\₹"),
                  onChanged: (SfRangeValues newValues) {
                    changeme(() {
                      _values = newValues;
                      rangevalue = newValues.start;
                      maxvalue = newValues.end;
                    });
                  },
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Text(
                  'Sort by',
                  style: Sty().mediumBoldText.copyWith(fontSize: Dim().d20),
                ),
                SizedBox(
                  height: Dim().d12,
                ),
                Container(
                  height: Dim().d40,
                  child: ListView.builder(
                      itemCount: sortname.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            changeme(() {
                              sortnamevalue = index;
                              sortvalue = sortname[index].toString();
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: Dim().d12),
                            child: Container(
                              width: Dim().d120,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Clr().lightGrey),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(Dim().d12),
                                  ),
                                  color: sortnamevalue == index
                                      ? Clr().black
                                      : null),
                              child: Center(
                                child: Text(
                                  sortname[index].toString(),
                                  style: Sty().mediumText.copyWith(
                                        color: sortnamevalue == index
                                            ? Clr().white
                                            : Color(0xff666666),
                                      ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          changeme(() {
                            applyfilter();
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          height: Dim().d56,
                          decoration: BoxDecoration(
                            color: Clr().black,
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dim().d16),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Apply Now',
                              style:
                                  Sty().mediumText.copyWith(color: Clr().white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Dim().d16,
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void getHome() async {
    FormData body = FormData.fromMap({});
    var result = await STM().post(ctx, Str().loading, 'home', body);
if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (error == false) {
      setState(() {
        listname = result['category_array'];
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void applyfilter() async {
    FormData body = FormData.fromMap({
      'id': sCategoryID,
      'sort_by': sortvalue == null ? sortname[0].toString() : sortvalue,
      'min_price': rangevalue!.round(),
      'max_price': maxvalue!.round(),
    });
    print(body.fields.toString());
    var result = await STM().post(ctx, Str().loading, 'filter', body);
if (!mounted) return;
    setState(() {
      productList = result;
    });
  }

  void getCategory() async {
    var result = await STM()
        .get(ctx, Str().loading, 'category_products/${widget.categoryId}');if (!mounted) return;
    setState(() {
      name = result['name'];
      productList = result['products'];
    });
  }
}
