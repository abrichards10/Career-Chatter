// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chatgpt_completions/chatgpt_completions.dart';
import 'package:demo_app/bloc/home_bloc.dart';
import 'package:demo_app/bloc/home_event.dart';
import 'package:demo_app/chat.dart';
import 'package:demo_app/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import 'package:flutter_svg/flutter_svg.dart';

class Profile extends StatefulWidget {
  final String photo;
  final BuildContext context;
  final String name;
  final String description;
  final String profession;
  final String location;
  final int salary;
  final int distance;
  final double? rating;

  const Profile({
    super.key,
    required this.name,
    required this.description,
    required this.photo,
    required this.context,
    required this.profession,
    required this.location,
    required this.salary,
    required this.distance,
    this.rating,
  });

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
            Text(
              'Hi! I\'m ${widget.name}',
              style: TextStyle(
                fontSize: screenWidth * .07,
                height: 3,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<HomeBloc>().add(
                                SavedProfileEvent(
                                  widget.name,
                                  widget.photo,
                                  "",
                                  widget.profession,
                                  widget.location,
                                  widget.salary,
                                  widget.distance,
                                ),
                              );
                          Navigator.pop(context);
                          // Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CareerChat(
                                name: widget.name,
                                photo: widget.photo,
                                description: widget.description,
                                profession: widget.profession,
                                location: widget.location,
                                salary: widget.salary,
                                distance: widget.distance,
                                rating: widget.rating,
                              ),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            'Chat',
                            style: TextStyle(
                              fontSize: screenWidth * .04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: screenWidth * .04,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.description,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: screenWidth * .045,
                ),
              ),
            ),
            SizedBox(
              height: 10,
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
                      fontSize: screenWidth * .04,
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
                  fontSize: screenWidth * .04,
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
                  fontSize: screenWidth * .04,
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
