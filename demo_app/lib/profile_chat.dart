// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:typed_data';

import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chatgpt_completions/chatgpt_completions.dart';
import 'package:demo_app/bloc/home_bloc.dart';
import 'package:demo_app/bloc/home_event.dart';
import 'package:demo_app/chat.dart';
import 'package:demo_app/model/message.dart';
import 'package:demo_app/model/profile_info.dart';
import 'package:demo_app/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import 'package:flutter_svg/flutter_svg.dart';

class ProfileChat extends StatefulWidget {
  final String photo;
  final BuildContext context;
  final String name;
  final String description;
  final String profession;
  final String location;
  final int salary;
  final int distance;

  const ProfileChat({
    super.key,
    required this.name,
    required this.description,
    required this.photo,
    required this.context,
    required this.profession,
    required this.location,
    required this.salary,
    required this.distance,
  });

  @override
  _ProfileChatState createState() => _ProfileChatState();
}

class _ProfileChatState extends State<ProfileChat> {
  TextEditingController controller = TextEditingController();
  List<Message> msgs = [];
  StreamSubscription? responseSubscription;
  String definition = "";

  @override
  Widget build(context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(0.0),
              alignment: Alignment.centerRight,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(
                  Icons.info_outline,
                  size: screenWidth * .05,
                ),
                onPressed: () {
                  setState(
                    () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Container(
                              padding: EdgeInsets.only(
                                top: 20,
                              ),
                              height: screenWidth * .8,
                              child: Column(
                                children: [
                                  Text(
                                    "Interested in working as a",
                                    style: TextStyle(
                                      fontSize: screenWidth * .055,
                                    ),
                                  ),
                                  Text(
                                    "${widget.profession}?",
                                    style: TextStyle(
                                      fontSize: screenWidth * .055,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Text(
                                      "Have a look at these resources!",
                                      style: TextStyle(
                                        fontSize: screenWidth * .04,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      height: screenWidth * .2,
                                      width: screenWidth * .8,
                                      child: Card(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Top Programs",
                                              style: TextStyle(
                                                fontSize: screenWidth * .05,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.open_in_new,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      height: screenWidth * .2,
                                      width: screenWidth * .8,
                                      child: Card(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Learn more",
                                              style: TextStyle(
                                                fontSize: screenWidth * .05,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.open_in_new,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Center(
                child: Text(
              '~${widget.name}~',
              style: TextStyle(
                fontSize: screenWidth * .07,
                height: 0,
                fontWeight: FontWeight.bold,
              ),
            )),
            SizedBox(
              height: 20,
            ),
            Container(
              width: screenWidth * .35,
              height: screenWidth * .35,
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
              height: 20,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profession: ${widget.profession}',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: screenWidth * .045,
                      height: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Salary: \$${widget.salary}',
                style: TextStyle(
                  fontSize: screenWidth * .045,
                  height: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Location: ${widget.location}',
                style: TextStyle(
                  fontSize: screenWidth * .045,
                  height: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      content: Container(
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
