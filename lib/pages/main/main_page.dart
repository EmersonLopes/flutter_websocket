import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_websocket/notification_service.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../../main.dart';
import '../../model/mensagem.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String mensagem = "---";
  StompClient? stompClient;
  final socketUrl = 'http://172.25.10.49:8080/gs-guide-websocket';

  void onConnect(StompClient client, StompFrame frame) {
    print("connecting");
    client.subscribe(
        destination: '/topic/greetings',
        callback: (StompFrame frame) {
          if (frame.body != null) {
            setState(() {
              mensagem = frame.body;
            });
            // NotificationService.showNotifications(title: 'Deu bom!', body: mensagem, payload: 'mensage.123');


            //-----
            // _showNotification(mensagem);
            //----
            //-----
            _showInsistentNotification(mensagem);
            //----

          }
        });
  }

  Future<void> _showNotification(String msg) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', msg, platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showInsistentNotification(String msg) async {
    // This value is from: https://developer.android.com/reference/android/app/Notification.html#FLAG_INSISTENT
    const int insistentFlag = 4;
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        additionalFlags: Int32List.fromList(<int>[insistentFlag]));
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'insistent title', msg, platformChannelSpecifics,
        payload: 'item x');
  }

  @override
  void initState() {
    if (stompClient == null) {
      stompClient = StompClient(
          config: StompConfig.SockJS(
            url: socketUrl,
            onConnect: onConnect,
            onWebSocketError: (dynamic error) => print(error.toString()),
            onStompError: (dynamic error) => print(error.toString()),
            onDebugMessage: (dynamic msg) => print(msg.toString()),
          ));
      stompClient?.activate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Mensagem:',
            ),
            Text(
              '$mensagem',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var greeting = Mensagem(name: "Naruhodo");
          stompClient?.send(
              destination: '/app/hello', body: json.encode(greeting.toJson()));
        },
        tooltip: 'Send',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    if (stompClient != null) {
      stompClient?.deactivate();
    }
    super.dispose();
  }
}
