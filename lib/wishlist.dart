import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb/manage/static_method.dart';
import 'package:sb/values/dimens.dart';

import 'values/colors.dart';
import 'values/styles.dart';

class Wishlist extends StatefulWidget {
  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  late BuildContext ctx;
  int selectedTab = 0;
  List<String> imageList = ['assets/home.png'];
  List<dynamic> resultList = [];

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      // bottomNavigationBar: bottomBarLayout(ctx, 0,),
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
          'My Wishlist',
          style: TextStyle(color: Clr().black, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Clr().white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(
                      horizontal: Dim().d0, vertical: Dim().d8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dim().d12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Image.asset('assets/cartproduct.png'),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Roller Rabbit',
                                        style: Sty().mediumText.copyWith(
                                              fontWeight: FontWeight.w600,
                                            )),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text('Vado Odelle Dress')
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: SvgPicture.asset(
                                    'assets/delete.svg',
                                    height: 15,
                                    width: 15,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('\u20b9 198',
                                        style: Sty().mediumText.copyWith(
                                              fontWeight: FontWeight.w600,
                                            )),
                                    SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 95,
                                  height: 32,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        // STM().redirect2page(ctx, CheckOut());
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Add to cart',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff2C2C2C),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)))),
                                ),
                              ],
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
