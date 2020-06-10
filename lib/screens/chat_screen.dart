import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

//final uri = 'ws://localhost:8000/ws';
final uri = 'ws://echo.websocket.org';
WebSocketChannel channel;
TextEditingController controller;
final List<MessageBubble> messageBubbles = [];
final List<String> list = [];
final List<Message> messages = [];

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  final userNameHolder;

  ChatScreen({
    Key key,
    @required this.userNameHolder,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String messageText;

  ScrollController _scrollController = ScrollController();
  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect(uri);
    controller = TextEditingController();
    channel.stream.listen((data) {
      setState(() {
        list.add(data);
        messages.add(Message(client: widget.userNameHolder, text: data));
//        list
//            .map((data) => Message(
//          client: widget.userNameHolder,
//          text: data,
//        ));
      });
    });}

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Scaffold(
      appBar: AppBar(
        leading: null,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                children: messages
                    .map((data) => MessageBubble(
                          client: data.client,
                          text: data.text,
                          isMe: data.client == widget.userNameHolder,
                        ))
                    .toList(),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.orange,
                  width: 2.0,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: (value) {
                        messageText = value;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      sendMessage();
                      controller.clear();
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    if (controller.text.isNotEmpty) {
      channel.sink.add(controller.text);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.client, this.text, this.isMe});

  final String client;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            client,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.deepOrangeAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final String client;

  Message({
    this.text,
    this.client,
  });
}
