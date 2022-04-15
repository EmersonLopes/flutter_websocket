import 'package:flutter/material.dart';

import 'package:flutter_websocket/websocket/websocket_chat.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    debugPrint("initState()");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Body(),
    );
  }

  @override
  void dispose() {
    context.read<WebsocketChat>().disconnect();
    super.dispose();
  }
}
