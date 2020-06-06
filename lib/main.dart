import 'package:flutter/material.dart';
import 'package:fluttermessenger/screens/login_screen.dart';
import 'package:fluttermessenger/screens/welcome_screen.dart';
import 'package:fluttermessenger/screens/chat_screen.dart';

void main() => runApp(Messenger());

class Messenger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(),
      initialRoute: WelcomeScreen.id,
      routes:{
        WelcomeScreen.id: (context) => WelcomeScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        LoginScreen.id: (context) => LoginScreen(),
      },
    );
  }
}
