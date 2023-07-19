import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sb/bottom_navigation/bottom_navigation.dart';
import 'package:sb/product_page.dart';
import 'package:sb/values/colors.dart';
import 'package:sb/values/dimens.dart';
import 'package:sb/values/strings.dart';
import 'package:sb/values/styles.dart';

import 'manage/static_method.dart';

class SearchResult extends StatefulWidget {
String? keyword;
SearchResult({Key? key, this.keyword}) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  late BuildContext ctx;
  List<dynamic> productList = [];

  @override
  void initState() {
    Future.delayed(Duration.zero,(){
      getCategory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      bottomNavigationBar: bottomBarLayout(ctx, 1, 0),
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
          'Search Result',
          style: TextStyle(color: Clr().black, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Clr().white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Dim().d20,),
            productList.length == 0?  Center(child: Text('No Result Found',style: Sty().mediumText,),) :GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: productList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 6 / 9,
                ),
                itemBuilder: (context, index) {
                  return cardLayout(context, index, productList);
                }),
          ],
        ),
      ),
    );
  }

  Widget cardLayout(context, index, list) {
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
              height: Dim().d180,
              width: Dim().d150,
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
              style: Sty().smallText.copyWith(
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
            padding: EdgeInsets.symmetric(horizontal: Dim().d24),
            child: SizedBox(
              height: 32,
              child: ElevatedButton(
                  onPressed: () {
                    // STM().redirect2page(ctx, ProductPage());
                  },
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  void getCategory() async {
    FormData body = FormData.fromMap({'key': widget.keyword});
    var result = await STM().post(ctx, Str().loading, 'search', body);
if (!mounted) return;
    setState(() {
      productList = result;
    });
  }
}
