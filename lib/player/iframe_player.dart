import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as inAppWebView;
import 'package:webview_flutter/webview_flutter.dart';

class IFramePlayerScreen extends StatefulWidget {
  final String url;
  IFramePlayerScreen(this.url);

  @override
  _IFramePlayerScreenState createState() => _IFramePlayerScreenState();
}

class _IFramePlayerScreenState extends State<IFramePlayerScreen> {
  // final Completer<WebViewController> _controller =
  //     Completer<WebViewController>();
  var playerResponse;
  GlobalKey sc = new GlobalKey<ScaffoldState>();
  late final WebViewController _controller;

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Ensure platform views are initialized before using WebView
    WidgetsFlutterBinding.ensureInitialized();
    var htmlContent = '''
                      <html>
                      <body style="width:100%;height:100%;display:block;background:black;">
                      <iframe width="100%" height="100%"
                      style="width:100%;height:100%;display:block;background:black;"
                      src="${widget.url}"
                      frameborder="0"
                      allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
                       allowfullscreen="allowfullscreen"
                        mozallowfullscreen="mozallowfullscreen"
                        msallowfullscreen="msallowfullscreen"
                        oallowfullscreen="oallowfullscreen"
                        webkitallowfullscreen="webkitallowfullscreen"
                       >
                      </iframe>
                      </body>
                      </html>
                    ''';

    // Initialize WebViewController with HTML rendering support
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Allow JavaScript
      ..setBackgroundColor(const Color(0x00000000)) // Transparent background
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('Page loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('Error: ${error.description}');
          },
        ),
      )
      ..loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    double width;
    double height;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: sc,
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: (widget.url.substring(0, 24) == 'https://drive.google.com')
              ? inAppWebView.InAppWebView(
                  initialUrlRequest: inAppWebView.URLRequest(
                    url: inAppWebView.WebUri.uri(Uri.tryParse(widget.url)!),
                  ),
                )
              : WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
