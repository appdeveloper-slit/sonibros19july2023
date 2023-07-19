import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb/values/dimens.dart';

import 'manage/static_method.dart';
import 'values/colors.dart';



class SBSupport extends StatefulWidget {
  @override
  State<SBSupport> createState() => _SBSupportState();
}

class _SBSupportState extends State<SBSupport> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        backgroundColor: Clr().white,
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
            'SB Support',
            style: TextStyle(color: Clr().black, fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: Clr().white,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 8 ,top: 0),
                      height: 60,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[

                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: "Your message",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        color: Clr().grey,

                                    )
                                  )
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          FloatingActionButton(
                            onPressed: (){},
                            child: SvgPicture.asset('assets/send.svg'),
                          backgroundColor: Colors.white,
                            elevation: 0,
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

      ),
    );
  }
}