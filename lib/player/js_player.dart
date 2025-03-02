import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:kloncept/provider/user_profile.dart';
import 'package:kloncept/common/apidata.dart';

class JSPlayer extends StatefulWidget {
  JSPlayer({this.courseId, this.courseType});

  final courseId;
  final courseType;

  @override
  _JSPlayerState createState() => _JSPlayerState();
}

class _JSPlayerState extends State<JSPlayer> with WidgetsBindingObserver {
  late final WebViewController _controller1;
  var playerResponse;
  var status;
  GlobalKey sc = new GlobalKey<ScaffoldState>();
  late DateTime currentBackPressTime;
  bool canPop = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Set system orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _initializeWebView();
  }

  /// Initialize the WebViewController and load the URL.
  void _initializeWebView() {
    var userDetails =
        Provider.of<UserProfile>(context, listen: false).profileInstance;
    var url = APIData.watchCourse +
        '${userDetails.id}/${userDetails.code}/${widget.courseId}';

    _controller1 = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('Page loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('Error loading page: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        _controller1.reload();
        break;
      case AppLifecycleState.resumed:
        _controller1.reload();
        break;
      case AppLifecycleState.paused:
        _controller1.reload();
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  //  Handle back press
  Future<bool> onWillPopS() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Navigator.pop(context);
      return Future.value(true);
    }
    return Future.value(true);
  }

  Future<String> loadLocal() async {
    setState(() {
      status = playerResponse.statusCode;
    });
    var responseUrl = playerResponse.body;
    return responseUrl;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    double width;
    double height;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    // JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    //   return JavascriptChannel(
    //     name: 'Toaster',
    //     onMessageReceived: (JavascriptMessage message) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(message.message),
    //         ),
    //       );
    //     },
    //   );
    // }

    return PopScope(
      child: Scaffold(
        key: sc,
        body: Stack(
          children: <Widget>[
            Container(
              width: width,
              height: height,
              child: WebViewWidget(controller: _controller1),
            ),
            Positioned(
              top: 26.0,
              left: 4.0,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  _controller1.reload();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      canPop: canPop,
      onPopInvokedWithResult: (didPop, dynamic) async {
        canPop = await onWillPopS();
        if (canPop == true) {
          canPop = true;
        }
      },
      // onWillPop: onWillPopS,
    );
  }
}
