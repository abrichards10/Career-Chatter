import 'package:dart_openai/dart_openai.dart';
import 'package:demo_app/design.dart';
import 'package:demo_app/home.dart';
import 'package:demo_app/my_keys.dart';
import 'package:flutter/material.dart';

void main() {
  OpenAI.apiKey = OpenAiKey;
  OpenAI.requestsTimeOut =
      const Duration(seconds: 60); // 60 seconds before request times out
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: mainFont.fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        appBarTheme: AppBarTheme(color: Color.fromARGB(255, 195, 226, 161)),
        useMaterial3: true,
      ),
      home: CareerChatbotPage(),
    );
  }
}
