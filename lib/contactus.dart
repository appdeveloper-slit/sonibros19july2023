import 'package:flutter/material.dart';
import 'package:sb/manage/static_method.dart';
import 'package:sb/values/colors.dart';
import 'package:sb/values/dimens.dart';
import 'package:sb/values/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class Contactus extends StatefulWidget {
Contactus({Key? key}) : super(key: key);

  @override
  State<Contactus> createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  late BuildContext ctx;
  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().white,
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
          'Contact Us',
          style: Sty().largeText.copyWith(
              color: Clr().white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: Dim().d24,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d12),
            child: Image.asset('assets/contact.png',),
          ),
          SizedBox(height: Dim().d20,),
          Center(child: Text('Contact us',style: Sty().mediumText,)),
          SizedBox(height: Dim().d28,),
          Text('==Mobile==',style: Sty().mediumBoldText,),
          InkWell(
              onTap: _launchCaller,
              child: Text('9986703211',style: Sty().mediumBoldText,)),
          SizedBox(height: Dim().d28,),
          Text('==Email Id==',style: Sty().mediumBoldText,),
          Text('support@sonibro.com',style: Sty().mediumBoldText,),
          SizedBox(height: Dim().d28,),
          Text('==Address==',style: Sty().mediumBoldText,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d12),
            child: Text('Shop No 1, 2, 3, 4, Gajanan Chaya Bldg, Near Guru Krupa Hospital, B.P. Road, Bhayander East Thane,  Maharashtra 401105',style: Sty().mediumBoldText,textAlign: TextAlign.center,),
          ),
        ],
      ),
    );
  }

  _launchCaller() async {
    const url = "tel:9986703211";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
