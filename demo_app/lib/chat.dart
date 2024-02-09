// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:ui' as ui;
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chatgpt_completions/chatgpt_completions.dart';
import 'package:demo_app/design.dart';
import 'package:demo_app/model/message.dart';
import 'package:demo_app/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CareerChat extends StatefulWidget {
  final String name;
  final String photo;

  CareerChat({required this.name, required this.photo});

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

  StreamSubscription? responseSubscription;

  void sendMsg(String command) async {
    controller.clear();

    ChatGPTCompletions.instance.textCompletions(
      TextCompletionsParams(
        messagesTurbo: [
          MessageTurbo(
            role: TurboRole.user,
            content: command,
          ),
        ],
        model: GPTModel.gpt3p5turbo,
      ),
      onStreamValue: (characters) {
        msgs.clear();

        msgs.insert(
          0,
          Message(
            false,
            characters,
          ),
        );
        setState(() {});
      },
      onStreamCreated: (subscription) {
        responseSubscription = subscription;
      },
      // Debounce 100ms for receive next value
      debounce: const Duration(milliseconds: 100),
    );
  }

  @override
  void initState() {
    // sendMsg("Hi!");
    super.initState();
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
              child: widget.photo == ""
                  ? Container()
                  : SvgPicture.string(
                      widget.photo,
                    ),
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
