// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:demo_app/design.dart';
import 'package:demo_app/model/message.dart';
import 'package:demo_app/my_keys.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CareerChat extends StatefulWidget {
  final String name;
  final List painters;

  CareerChat({required this.name, required this.painters});

  @override
  State<CareerChat> createState() => _CareerChatState();
}

class _CareerChatState extends State<CareerChat> {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<Message> msgs = [];
  bool isTyping = false;
  String prevResponse = "";
  String sentMessage = "";

  void sendMsg(String command) async {
    controller.clear();
    try {
      if (command.isNotEmpty) {
        setState(
          () {
            msgs.insert(0, Message(true, command));
            isTyping = true;
          },
        );
        scrollController.animateTo(0.0,
            duration: const Duration(seconds: 1), curve: Curves.easeOut);
        var response = await http.post(
          Uri.parse("https://api.openai.com/v1/chat/completions"),
          headers: {
            "Authorization": "Bearer $OpenAiKey",
            "Content-Type": "application/json"
          },
          body: jsonEncode(
            {
              "model": "gpt-3.5-turbo",
              "messages": [
                {
                  "role": "user",
                  "content": command,
                }
              ]
            },
          ),
        );
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          setState(
            () {
              isTyping = false;
              msgs.insert(
                0,
                Message(
                  false,
                  json["choices"][0]["message"]["content"]
                      .toString()
                      .trimLeft(),
                ),
              );

              prevResponse = msgs[0].msg;
              print("PREV RESPONSE: $prevResponse");
            },
          );
          scrollController.animateTo(0.0,
              duration: const Duration(seconds: 1), curve: Curves.easeOut);
        }
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Some error occurred, please try again!",
        style: TextStyle(
          fontFamily: mainFont.fontFamily,
        ),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxHeight = screenWidth * .1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Container(
              height: screenWidth * .1,
              width: screenWidth * .1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueGrey.withOpacity(0.5),
                border: Border.all(width: 3, color: Colors.teal),
              ),
              child: widget.painters.isEmpty ? Container() : widget.painters[0],
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              widget.name,
              style: TextStyle(
                fontFamily: mainFont.fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * .07,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: screenWidth * .01,
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: msgs.length,
              shrinkWrap: true,
              reverse: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenWidth * .01,
                  ),
                  child: isTyping && index == 0
                      ? Column(
                          children: [
                            BubbleNormal(
                              text: msgs[0].msg,
                              isSender: true,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: screenWidth * .04,
                                top: screenWidth * .01,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Typing...",
                                  style: TextStyle(
                                    fontFamily: mainFont.fontFamily,
                                    fontSize: screenWidth * .05,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      : BubbleNormal(
                          text: msgs[index].msg,
                          isSender: msgs[index].isSender,
                        ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              screenWidth * .04,
              screenWidth * .1,
              screenWidth * .04,
              screenWidth * .04,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: screenWidth * .03,
                        right: screenWidth * .03,
                      ),
                      width: screenWidth * .5,
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            screenWidth * .04,
                            screenWidth * .04,
                            screenWidth * .04,
                            screenWidth * .04,
                          ),
                          child: Text(
                            "What skills are most important for success in this field?",
                            style: TextStyle(
                              fontFamily: mainFont.fontFamily,
                              fontSize: screenWidth * .04,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      sendMsg(
                          "What skills are most important for success in this field?");
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: screenWidth * .03,
                        right: screenWidth * .03,
                      ),
                      width: screenWidth * .5,
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            screenWidth * .04,
                            screenWidth * .04,
                            screenWidth * .04,
                            screenWidth * .04,
                          ),
                          child: Text(
                            "How do you handle difficult situations or conflicts at work?",
                            style: TextStyle(
                              fontFamily: mainFont.fontFamily,
                              fontSize: screenWidth * .04,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      sendMsg(
                        "How do you handle difficult situations or conflicts at work?",
                      );
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: screenWidth * .03,
                        right: screenWidth * .03,
                      ),
                      width: screenWidth * .5,
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            screenWidth * .04,
                            screenWidth * .04,
                            screenWidth * .04,
                            screenWidth * .04,
                          ),
                          child: Text(
                            "Can you describe a typical day in your job?",
                            style: TextStyle(
                              fontFamily: mainFont.fontFamily,
                              fontSize: screenWidth * .04,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      sendMsg(
                        "Can you describe a typical day in your job?",
                      );
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: screenWidth * .03,
                        right: screenWidth * .03,
                      ),
                      width: screenWidth * .5,
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            screenWidth * .04,
                            screenWidth * .04,
                            screenWidth * .04,
                            screenWidth * .04,
                          ),
                          child: Text(
                            "How do you handle work-life balance in this career?",
                            style: TextStyle(
                              fontFamily: mainFont.fontFamily,
                              fontSize: screenWidth * .04,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      sendMsg(
                        "How do you handle work-life balance in this career?",
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              screenWidth * .04,
              screenWidth * .04,
              screenWidth * .04,
              screenWidth * .1,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: boxHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 223, 236, 209),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * .04,
                          ),
                          child: TextField(
                            controller: controller,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(
                              fontFamily: mainFont.fontFamily,
                            ),
                            onSubmitted: (value) {
                              sendMsg(value);
                              sentMessage = value;
                            },
                            textInputAction: TextInputAction.send,
                            showCursor: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter text",
                              hintStyle: TextStyle(
                                fontFamily: mainFont.fontFamily,
                                height: screenWidth * .01,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        sendMsg(sentMessage); // TODO: Change
                      },
                      child: Container(
                        height: screenWidth * .1,
                        width: screenWidth * .1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)),
                        child: Icon(
                          Icons.send,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * .03,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
