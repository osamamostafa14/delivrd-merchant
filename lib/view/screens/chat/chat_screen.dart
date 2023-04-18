import 'dart:async';
import 'dart:io';
import 'package:delivrd_driver/view/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatScreen extends StatefulWidget {

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String selectedUrl;
  double value = 0.0;
  bool _isLoading = true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController? controllerGlobal;

  @override
  void initState() {
    super.initState();
    selectedUrl = 'https://direct.lc.chat/14245842/';

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  Future<bool> redirectTo() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> DashboardScreen(pageIndex: 0)));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => redirectTo(),
      child: Scaffold(


        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFFe93e2c)),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> DashboardScreen(pageIndex: 0))),
          ),
          title: Text('Chat', style: TextStyle(
            color: Colors.black54,
          )),
          backgroundColor: Colors.white,
        ),

        //appBar: CustomAppBar(title: getTranslated('PAYMENT', context), onBackPressed: () => _exitApp(context)),
        body: Center(
          child: Container(
            width: 1170,
            child: Stack(
              children: [
                WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: selectedUrl,
                  gestureNavigationEnabled: true,
                  userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E233 Safari/601.1',
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.future.then((value) => controllerGlobal = value);
                    _controller.complete(webViewController);
                  },
                  onPageStarted: (String url) {
                    print('Page started loading: $url');
                    setState(() {
                      _isLoading = true;
                    });

                  },
                  onPageFinished: (String url) {
                    print('Page finished loading: $url');
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
                _isLoading ? Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                ) : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
