import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VNPayWebView extends StatefulWidget {
  final String paymentUrl;
  final Function(Map<String, String>) onPaymentResult;

  const VNPayWebView({
    Key? key,
    required this.paymentUrl,
    required this.onPaymentResult,
  }) : super(key: key);

  @override
  _VNPayWebViewState createState() => _VNPayWebViewState();
}

class _VNPayWebViewState extends State<VNPayWebView> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    print('Opening VNPayWebView with URL: ${widget.paymentUrl}');
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('WebView started loading: $url');
          },
          onPageFinished: (String url) {
            print('WebView finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print(
                'WebView error: ${error.description}, Code: ${error.errorCode}, Type: ${error.errorType}');
          },
          onNavigationRequest: (NavigationRequest request) {
            print('WebView navigation request: ${request.url}');
            if (request.url.contains('/api/vnpay/vnpay-return')) {
              final uri = Uri.parse(request.url);
              final params = uri.queryParameters;
              widget.onPaymentResult(params);
              Navigator.pop(context);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    print('Building VNPayWebView');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán VNPay'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
