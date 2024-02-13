// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chatgpt_completions/chatgpt_completions.dart';
import 'package:demo_app/model/message.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class InfoPopup extends StatefulWidget {
  final String profession;

  const InfoPopup({super.key, required this.profession});

  @override
  _InfoPopupState createState() => _InfoPopupState();
}

class _InfoPopupState extends State<InfoPopup> {
  List<Message> theseMsgs = [];
  StreamSubscription? thisResponseSubscription;
  String definition = "";
  ScrollController scrollController = ScrollController();
  bool isTyping = false;

  @override
  void initState() {
    sendMsg("What is the definition of: ${widget.profession}?");
    super.initState();
  }

  void sendMsg(String command) async {
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
        theseMsgs.clear();

        theseMsgs.insert(
          0,
          Message(
            false,
            characters,
          ),
        );
        setState(() {});
      },
      onStreamCreated: (subscription) {
        thisResponseSubscription = subscription;
      },
      // Debounce 100ms for receive next value
      debounce: const Duration(milliseconds: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: SizedBox(
        height: screenWidth * .5,
        width: screenWidth * .4,
        child: ListView.builder(
          controller: scrollController,
          itemCount: theseMsgs.length,
          itemBuilder: (context, index) {
            isTyping && index == 0
                ? Column(
                    children: [
                      BubbleNormal(
                        text: theseMsgs[0].msg,
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
                              fontSize: screenWidth * .05,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : BubbleNormal(
                    text: theseMsgs[index].msg,
                    isSender: theseMsgs[index].isSender,
                    color: ui.Color.fromARGB(255, 189, 225, 190),
                  );
          },
        ),
      ),
    );
  }
}
