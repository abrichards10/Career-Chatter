import 'package:chatgpt_completions/chatgpt_completions.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:demo_app/api_service.dart';
import 'package:demo_app/bloc/home_bloc.dart';
import 'package:demo_app/design.dart';
import 'package:demo_app/home.dart';
import 'package:demo_app/my_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prefs/prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OpenAI.apiKey = OpenAiKey;
  OpenAI.requestsTimeOut =
      const Duration(seconds: 60); // 60 seconds before request times out
  ChatGPTCompletions.instance.initialize(apiKey: OpenAiKey);
  await Prefs.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ApiService(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
              create: (context) =>
                  HomeBloc(RepositoryProvider.of<ApiService>(context))),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: mainFont.fontFamily,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
            appBarTheme: AppBarTheme(color: Color.fromARGB(255, 195, 226, 161)),
            useMaterial3: true,
          ),
          home: CareerChatbotPage(),
        ),
      ),
    );
  }
}
