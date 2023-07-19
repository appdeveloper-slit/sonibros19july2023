import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sb/category.dart';
import 'package:sb/localstore.dart';
import 'package:sb/manage/static_method.dart';
import 'package:sb/product_page.dart';
import 'package:sb/searchresult.dart';
import 'package:sb/toolbar/toolbar.dart';
import 'package:sb/values/colors.dart';
import 'package:sb/values/dimens.dart';
import 'package:sb/values/strings.dart';
import 'package:sb/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_navigation/bottom_navigation.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late BuildContext ctx;
  List<dynamic> categorryList = [];
  List<dynamic> SliderList = [];
  List<dynamic> resultList = [];
  List<dynamic> newArrivalList = [];
  List<dynamic> topSellerList = [];
  List<dynamic> shirtsList = [];
  List<dynamic> jeansList = [];
  List<dynamic> addToCart = [];
  bool isLoading = true;
  String? sUserid;
  TextEditingController _searchCtrl = TextEditingController();

  String? sUUID;

  Future<void> _updateItem(
      idd, name, brand, image, price, actualPrice, counter) async {
    await Store.updateItem(
        idd, name, brand, image, price, actualPrice, counter);
  }

  void _refreshData() async {
    dynamic data = await Store.getItems();
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
    var status = await OneSignal.shared.getDeviceState();
    setState(() {
      sUserid = sp.getString('user_id');
      sUUID = status?.userId;
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getHome();
        _refreshData();
      }
    });
  }

  @override
  void initState() {
    getSessionData();
    Store.getCounterId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return DoubleBack(
      message: 'Press back once again to exit',
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 0, addToCart.length),
        backgroundColor: Clr().white,
        appBar: homebar(ctx,sUserid),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Dim().d12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Dim().d20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _searchCtrl,
                      textInputAction: TextInputAction.go,
                      onFieldSubmitted: (value) {
                        value == null
                            ? null
                            : STM().redirect2page(
                                ctx,
                                SearchResult(
                                  keyword: value,
                                ));
                        _searchCtrl.clear();
                      },
                      decoration: InputDecoration(
                        fillColor: const Color(0xffF3F4F5),
                        filled: true,
                        hoverColor: Clr().primaryColor,
                        contentPadding: const EdgeInsets.all(0),
                        prefixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: SvgPicture.asset('assets/search.svg'),
                        ),
                        hintText: "Search...",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Clr().transparent,
                        )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Clr().transparent,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Dim().d12,
              ),
              SizedBox(
                height: Dim().d100,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: categorryList.length,
                  itemBuilder: (context, index) {
                    return itemLayout(ctx, index, categorryList);
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, childAspectRatio: 1 / 9),
                ),
              ),
              SizedBox(
                height: Dim().d8,
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: Dim().d180,
                  viewportFraction: 0.9,
                  padEnds: true,
                ),
                items: SliderList.map(
                  (e) => Padding(
                      padding: EdgeInsets.only(right: Dim().d12),
                      child: InkWell(
                        onTap: () {
                          e['category_id'] == null
                              ? STM().redirect2page(
                                  ctx,
                                  ProductPage(
                                    productid: e['product_id'].toString(),
                                  ))
                              : STM().redirect2page(
                                  ctx,
                                  Category(
                                    categoryId: e['category_id'].toString(),
                                  ),
                                );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dim().d12),
                            ),
                            border: Border.all(color: Clr().lightGrey),
                            image: DecorationImage(
                              image:
                                  NetworkImage('${e['image_path'].toString()}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )),
                ).toList(),
              ),
              SizedBox(
                height: Dim().d8,
              ),
              Text('New Arrivals',
                  style: Sty().extraLargeText.copyWith(
                        fontSize: Dim().d20,
                    fontWeight: FontWeight.w800,
                      )),
              SizedBox(
                height: Dim().d300,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: newArrivalList.length,
                  itemBuilder: (context, index) {
                    return productLayout(ctx, index, newArrivalList);
                  },
                ),
              ),
              SizedBox(
                height: Dim().d8,
              ),
              Text('Top Sellers',
                  style: Sty().extraLargeText.copyWith(
                      fontSize: Dim().d20, fontWeight: FontWeight.w800)),
              SizedBox(
                height: Dim().d8,
              ),
              SizedBox(
                height: Dim().d300,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: topSellerList.length,
                  itemBuilder: (context, index) {
                    return topSellerLayout(ctx, index, topSellerList);
                  },
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Shirts',
                      style: Sty().extraLargeText.copyWith(
                          fontSize: Dim().d20, fontWeight: FontWeight.w800))),
              SizedBox(
                height: Dim().d8,
              ),
              SizedBox(
                height: Dim().d300,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: shirtsList.length,
                  itemBuilder: (context, index) {
                    return shirtsLayout(ctx, index, shirtsList);
                  },
                ),
              ),
              Text(
                'Others',
                style: Sty()
                    .extraLargeText
                    .copyWith(fontSize: Dim().d20, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: Dim().d8,
              ),
              SizedBox(
                height: Dim().d300,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: jeansList.length,
                  itemBuilder: (context, index) {
                    return jeansLayout(ctx, index, jeansList);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Item
  Widget itemLayout(ctx, index, List) {
    return InkWell(
      onTap: () {
        STM().redirect2page(
          ctx,
          Category(
            categoryId: List[index]['id'].toString(),
          ),
        );
      },
      child: Container(
        width: Dim().d120,
        child: Column(
          children: [
            CircleAvatar(
                radius: 30,
                backgroundColor: Clr().black,
                child: SvgPicture.network(
                  '${categorryList[index]['image_path'].toString()}',
                )),
            SizedBox(height: 8),
            Text(
              '${categorryList[index]['name'].toString()}',
              overflow: TextOverflow.fade,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: Dim().d4)
          ],
        ),
      ),
    );
  }

  Widget bannerLayout(ctx, index, List) {
    return Container(
      width: Dim().d220,
      height: Dim().d220,
      margin: EdgeInsets.only(right: Dim().d16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(Dim().d16)),
          image: DecorationImage(
            image: NetworkImage('${List[index]['image_path'].toString()}'),
            fit: BoxFit.cover,
          )),
    );
  }

  Widget productLayout(ctx, index, List) {
    int position =
        addToCart.indexWhere((element) => element['idd'] == List[index]['id']);
    return Padding(
      padding: EdgeInsets.only(right: Dim().d8, top: Dim().d12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              STM().redirect2page(
                ctx,
                ProductPage(
                  productid: List[index]['id'].toString(),
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  height: Dim().d180,
                  width: Dim().d150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dim().d16),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                          '${List[index]['feature_image'].toString()}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                SizedBox(
                  width: Dim().d120,
                  child: Text(
                    '${List[index]['name'].toString()}',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: Sty().mediumBoldText.copyWith(
                          color: Clr().black,
                        ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '${List[index]['brand'].toString()}',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),
                SizedBox(
                  height: 10,
                ),
                addToCart.map((e) => e['idd']).contains(List[index]['id'])
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
                    : SizedBox(
                        height: Dim().d32,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _refreshData();
                                _addItem(
                                  List[index]['id'],
                                  List[index]['name'].toString(),
                                  List[index]['brand'].toString(),
                                  List[index]['feature_image'].toString(),
                                  List[index]['set_price'].toString(),
                                  List[index]['set_price'].toString(),
                                  1,
                                ).then((value) {
                                  _refreshData();
                                });
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  '\u20b9 ${List[index]['price'].toString()}',
                                ),
                                SizedBox(
                                  width: 33,
                                ),
                                Icon(
                                  Icons.add,
                                  color: Clr().white,
                                  size: 16,
                                )
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff2C2C2C))),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget topSellerLayout(ctx, index, List) {
    int position =
        addToCart.indexWhere((element) => element['idd'] == List[index]['id']);
    return Padding(
      padding: EdgeInsets.all(Dim().d8),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              STM().redirect2page(
                  ctx,
                  ProductPage(
                    productid: List[index]['id'].toString(),
                  ));
            },
            child: Container(
              height: Dim().d180,
              width: Dim().d150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(Dim().d16),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      '${List[index]['feature_image'].toString()}'),
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
              List[index]['name'].toString(),
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
            '${List[index]['brand'].toString()}',
            style: TextStyle(
                color: Color(0xff666666),
                fontWeight: FontWeight.w400,
                fontSize: 12),
          ),
          SizedBox(
            height: 10,
          ),
          addToCart.map((e) => e['idd']).contains(List[index]['id'])
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  ? Store.deleteItem(addToCart[position]['idd'])
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(Dim().d52))),
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
                                  addToCart[position]['actualPrice'].toString(),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(Dim().d52))),
                          child: ClipOval(
                            child: Icon(Icons.add, color: Colors.black87),
                          )),
                    ),
                  ],
                )
              : SizedBox(
                  height: Dim().d32,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _refreshData();
                          _addItem(
                            List[index]['id'],
                            List[index]['name'].toString(),
                            List[index]['brand'].toString(),
                            List[index]['feature_image'].toString(),
                            List[index]['set_price'].toString(),
                            List[index]['set_price'].toString(),
                            1,
                          ).then((value) {
                            _refreshData();
                          });
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            '\u20b9 ${List[index]['price'].toString()}',
                          ),
                          SizedBox(
                            width: 33,
                          ),
                          Icon(
                            Icons.add,
                            size: 16,
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff2C2C2C))),
                )
        ],
      ),
    );
  }

  Widget shirtsLayout(ctx, index, List) {
    int position =
        addToCart.indexWhere((element) => element['idd'] == List[index]['id']);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              STM().redirect2page(
                  ctx,
                  ProductPage(
                    productid: List[index]['id'].toString(),
                  ));
            },
            child: Container(
              height: Dim().d180,
              width: Dim().d150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(Dim().d16),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      '${List[index]['feature_image'].toString()}'),
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
              '${List[index]['name'].toString()}',
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
            '${List[index]['brand'].toString()}',
            style: TextStyle(
                color: Color(0xff666666),
                fontWeight: FontWeight.w400,
                fontSize: 12),
          ),
          SizedBox(
            height: 10,
          ),
          addToCart.map((e) => e['idd']).contains(List[index]['id'])
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  ? Store.deleteItem(addToCart[position]['idd'])
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(Dim().d52))),
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
                                  addToCart[position]['actualPrice'].toString(),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(Dim().d52))),
                          child: ClipOval(
                            child: Icon(Icons.add, color: Colors.black87),
                          )),
                    ),
                  ],
                )
              : SizedBox(
                  height: Dim().d32,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _refreshData();
                          _addItem(
                            List[index]['id'],
                            List[index]['name'].toString(),
                            List[index]['brand'].toString(),
                            List[index]['feature_image'].toString(),
                            List[index]['set_price'].toString(),
                            List[index]['set_price'].toString(),
                            1,
                          ).then((value) {
                            _refreshData();
                          });
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            '\u20b9 ${List[index]['price'].toString()}',
                          ),
                          SizedBox(
                            width: 33,
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
        ],
      ),
    );
  }

  Widget jeansLayout(ctx, index, List) {
    int position =
        addToCart.indexWhere((element) => element['idd'] == List[index]['id']);
    return Padding(
      padding: EdgeInsets.all(Dim().d8),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              STM().redirect2page(
                ctx,
                ProductPage(
                  productid: List[index]['id'].toString(),
                ),
              );
            },
            child: Container(
              height: Dim().d180,
              width: Dim().d150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(Dim().d16),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      '${jeansList[index]['feature_image'].toString()}'),
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
              '${jeansList[index]['name'].toString()}',
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
            '${jeansList[index]['brand'].toString()}',
            style: TextStyle(
                color: Color(0xff666666),
                fontWeight: FontWeight.w400,
                fontSize: 12),
          ),
          SizedBox(
            height: 10,
          ),
          addToCart.map((e) => e['idd']).contains(List[index]['id'])
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(Dim().d52))),
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
                                  addToCart[position]['actualPrice'].toString(),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(Dim().d52))),
                          child: ClipOval(
                            child: Icon(Icons.add, color: Colors.black87),
                          )),
                    ),
                  ],
                )
              : SizedBox(
                  height: Dim().d32,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _refreshData();
                          _addItem(
                            List[index]['id'],
                            List[index]['name'].toString(),
                            List[index]['brand'].toString(),
                            List[index]['feature_image'].toString(),
                            List[index]['set_price'].toString(),
                            List[index]['set_price'].toString(),
                            1,
                          ).then((value) {
                            _refreshData();
                          });
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            '\u20b9 ${jeansList[index]['price'].toString()}',
                          ),
                          SizedBox(
                            width: 33,
                          ),
                          Icon(
                            Icons.add,
                            size: 16,
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff2C2C2C))),
                )
        ],
      ),
    );
  }

  void getHome() async {
    FormData body = FormData.fromMap({
      'user_id': sUserid,
      'uuid': sUUID,
    });
    var result = await STM().post(ctx, Str().loading, 'home', body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (error == false) {
      setState(() {
        categorryList = result['category_array'];
        SliderList = result['slider_array'];
        newArrivalList = result['new_arrival_products'];
        topSellerList = result['top_seller_products'];
        shirtsList = result['product_category_array'][1]['products'];
        jeansList = result['product_category_array'][0]['products'];
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
