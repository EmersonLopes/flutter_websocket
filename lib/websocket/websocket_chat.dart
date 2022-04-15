import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../model/mensagem.dart';
import '../utils/constants.dart';

class WebsocketChat {
  StompClient? _stompClient;

  late Function(StompFrame) callbackSubscribe;

  void connect() {
    debugPrint("connect");
    if (_stompClient == null) {
      _stompClient = StompClient(
          config: StompConfig.SockJS(
        url: Constants.SOCKET_URL,
        onConnect: _onConnect,
        onWebSocketError: (dynamic error) => debugPrint(error.toString()),
        onStompError: (dynamic error) => debugPrint(error.toString()),
        onDebugMessage: (dynamic msg) => debugPrint(msg.toString()),
      ));
      _stompClient?.activate();
    }
  }

  void _onConnect(StompClient client, StompFrame frame) {
    debugPrint("connecting");
    client.subscribe(
        destination: '/topic/public',
        callback: (StompFrame frame) {
          if (frame.body != null) {
            debugPrint(frame.body);
            callbackSubscribe(frame);
            /*setState(() {
              mensagem = frame.body;
            });*/
            // NotificationService.showNotifications(title: 'Deu bom!', body: mensagem, payload: 'mensage.123');

            //-----
            // _showNotification(mensagem);
            //----
            //-----
            // _showInsistentNotification(mensagem);
            //----

          }
        });
  }

  void sendMessage(String user, String message) {
    var chatMessage = ChatMessage(content: message, sender: user);
    _stompClient?.send(
        destination: '/app/chat.sendMessage',
        body: json.encode(chatMessage.toJson()));
  }

  void disconnect() {
    if (_stompClient != null) {
      _stompClient?.deactivate();
    }
  }
}
