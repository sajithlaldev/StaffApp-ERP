import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'components/appbar.dart';

class CustomWebviewScreen extends StatefulWidget {
  final String url;
  const CustomWebviewScreen({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<CustomWebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<CustomWebviewScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(48),
        child: AppBarWidget(),
      ),
      body: WebView(
        initialUrl: widget.url,
      ),
    );
  }
}
