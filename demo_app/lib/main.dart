import 'package:dart_openai/dart_openai.dart';
import 'package:demo_app/home.dart';
import 'package:demo_app/my_keys.dart';
import 'package:flutter/material.dart';

void main() {
  OpenAI.apiKey = OpenAiKey;
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CareerChatbotPage(),
    );
  }
}
