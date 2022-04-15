import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_websocket/model/mensagem.dart';
import 'package:flutter_websocket/notification_service.dart';
import 'package:flutter_websocket/websocket/websocket_chat.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../../chat/chat_page.dart';
import 'message_tile.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.user}) : super(key: key);
  final String user;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController messageEditingController = TextEditingController();
  List<ChatMessage> messages = [ChatMessage(sender: "Emerson", content: "Olá a todos!")];

  @override
  void initState() {
    context.read<WebsocketChat>().callbackSubscribe = callbackSubscribe;
    context.read<WebsocketChat>().connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          chatMessages(),
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              color: const Color(0x54FFFFFF),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageEditingController,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: const InputDecoration(
                        hintText: "Messagem",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        border: InputBorder.none),
                  )),
                  const SizedBox(
                    width: 16,
                  ),
                  IconButton(
                      onPressed: () {
                        context.read<WebsocketChat>().sendMessage(
                            widget.user, messageEditingController.text);
                      },
                      icon: Icon(Icons.send)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget chatMessages() {
    return Container(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return MessageTile(
              message: messages[index].content ?? "",
              sendByMe: messages[index].sender == widget.user,
            );
          }),
    );
  }

  callbackSubscribe(StompFrame stompFrame) {
    debugPrint("callbackSubscribe");
    setState(() {
      var chatMessage = ChatMessage.fromJson(jsonDecode(stompFrame.body));
      messages.add(chatMessage);
      messageEditingController.text = "";
      if(chatMessage.sender != widget.user){
        NotificationService.showNotification(chatMessage.content?? "");
      }
    });
  }
}
