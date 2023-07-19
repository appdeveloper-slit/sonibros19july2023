import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sb/manage/static_method.dart';
import 'package:sb/my_orders.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String? sUrl;

  const WebViewPage(this.sUrl, {Key? key}) : super(key: key);

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.sUrl,
          onPageFinished: (String url) {
            setState(() {
              if (url.contains("success_page")) {
                STM().successDialogWithReplace(
                  ctx,
                  "Payment successfully",
                  MyOrders(
                    isRedirect: true,
                  ),
                );
              } else if (url.contains("failed_page")) {
                STM().displayToast("Payment Failed");
                STM().back2Previous(ctx);
              }
            });
          },
        ),
      ),
    );
  }
}
