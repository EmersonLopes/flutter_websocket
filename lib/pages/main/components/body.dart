import 'package:flutter/material.dart';
import 'package:flutter_websocket/websocket/websocket_chat.dart';
import 'package:provider/provider.dart';

import '../../chat/chat_page.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final textController = TextEditingController(text: "Ninguém");

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(28.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text("Informe seu nome"),
            TextField(
              controller: textController,
            ),
            SizedBox(
              height: 18.0,
            ),
            MaterialButton(
                color: Colors.blueGrey,
                child: Text("ENTRAR NO CHAT"),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ChatPage(
                                user: textController.text,
                              )));
                })
          ],
        ),
      ),
    );
  }
}
