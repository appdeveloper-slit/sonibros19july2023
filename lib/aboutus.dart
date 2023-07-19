import 'package:flutter/material.dart';
import 'package:sb/values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'manage/static_method.dart';

class Aboutus extends StatefulWidget {
  Aboutus({Key? key}) : super(key: key);

  @override
  State<Aboutus> createState() {
    return AboutusState();
  }
}

class AboutusState extends State<Aboutus> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Clr().primaryColor,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: Clr().white,
          ),
        ),
        centerTitle: true,
        title: Text(
          'About Us',
          style: Sty().largeText.copyWith(
              color: Clr().white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Dim().d28,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'About Us',
                style: Sty().mediumText,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'We connect millions of buyers and sellers around the world, empowering people &amp; creating economic opportunity for all. Within our markets, millions of people around the world connect, both online and offline, to make, sell and buy unique goods. We also offer a wide range of Seller Services and tools that help creative entrepreneurs start, manage and scale their businesses. Our mission is to reimagine commerce in ways that build a more fulfilling and lasting world, and we’re committed to using the power of business to strengthen communities and empower people.',
                  style: Sty().mediumText,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
