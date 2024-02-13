// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chatgpt_completions/chatgpt_completions.dart';
import 'package:confetti/confetti.dart';
import 'package:demo_app/bloc/home_bloc.dart';
import 'package:demo_app/bloc/home_event.dart';
import 'package:demo_app/bloc/home_state.dart';
import 'package:demo_app/commons/design.dart';
import 'package:demo_app/model/message.dart';
import 'package:demo_app/profile.dart';
import 'package:demo_app/profile_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CareerChat extends StatefulWidget {
  final String name;
  final String photo;
  final String description;
  final String profession;
  final String location;
  final int salary;
  final int distance;
  final double? rating;

  CareerChat({
    required this.name,
    required this.photo,
    required this.description,
    required this.profession,
    required this.location,
    required this.salary,
    required this.distance,
    required this.rating,
  });

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
  late ConfettiController _controllerCenter; // CONFETTI! :D
  late Color starColor;

  String careerPrompt = "";
  void sendMsg(String command, String displayMessage) async {
    controller.clear();

    setState(
      () {
        msgs.insert(0, Message(true, displayMessage));
        isTyping = true;
      },
    );
    scrollController.animateTo(0.0,
        duration: const Duration(seconds: 1), curve: Curves.easeOut);

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
        setState(
          () {
            msgs.clear();

            isTyping = false;
            msgs.insert(
              0,
              Message(
                false,
                characters,
              ),
            );

            prevResponse = msgs[0].msg;
          },
        );
      },
      onStreamCreated: (subscription) {
        responseSubscription = subscription;
      },
      // Debounce 100ms for receive next value
      debounce: const Duration(milliseconds: 100),
    );
    scrollController.animateTo(0.0,
        duration: const Duration(seconds: 1), curve: Curves.easeOut);
  }

  @override
  void initState() {
    careerPrompt =
        "Pretend you are ${widget.name} and you live in ${widget.location} working as a ${widget.profession} making ${widget.salary} dollars per year. You live ${widget.distance} miles away from ${widget.location}";

    _controllerCenter = ConfettiController(
      duration: const Duration(seconds: 1),
    );
    // sendMsg("$careerPrompt. Say hi");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerCenter.dispose(); // Dispose of confetti
  }

  Widget confetti(ConfettiController controllerCenter) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: controllerCenter,
        blastDirectionality: BlastDirectionality
            .explosive, // don't specify a direction, blast randomly
        shouldLoop: false, // start again as soon as the animation is finished
        colors: [
          ui.Color.fromARGB(255, 208, 255, 217),
          ui.Color.fromARGB(255, 175, 255, 186),
          ui.Color.fromARGB(255, 139, 255, 147),
          ui.Color.fromARGB(255, 237, 255, 149),
          ui.Color.fromARGB(255, 246, 255, 115),
        ],
        numberOfParticles: 20,
        maxBlastForce: 40,
        createParticlePath: drawCircle,
      ),
    );
  }

  Path drawCircle(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final degreesPerStep = degToRad(1);
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxHeight = screenWidth * .1;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                padding: EdgeInsets.only(
                  right: 15,
                ),
                iconSize: screenWidth * .08,
                icon: Icon(
                  widget.rating == null ? Icons.star_border_sharp : Icons.star,
                  color: widget.rating == null
                      ? Colors.black
                      : ui.Color.fromARGB(255, 199, 186, 15),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container(
                          height: screenWidth * .43,
                          width: screenWidth * .8,
                          child: Column(
                            children: [
                              Text(
                                "Rate ${widget.name}!",
                                style: TextStyle(
                                  fontSize: screenWidth * .06,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "How is your experience?",
                                style: TextStyle(
                                  fontSize: screenWidth * .04,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              RatingBar.builder(
                                initialRating: widget.rating ?? 3,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  context.read<HomeBloc>().add(
                                        AddRatingEvent(rating, widget.name),
                                      );
                                  print(rating);
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              ElevatedButton(
                                child: Text(
                                  "Done ✮⋆˙",
                                  style: TextStyle(
                                    fontSize: screenWidth * .04,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _controllerCenter.play(); // Confetti!
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
            title: GestureDetector(
              child: Row(
                children: [
                  Container(
                    height: screenWidth * .1,
                    width: screenWidth * .1,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueGrey.withOpacity(0.5),
                      border: Border.all(width: 2, color: Colors.teal),
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
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ProfileChat(
                      name: widget.name,
                      description: widget.description,
                      photo: widget.photo,
                      context: context,
                      profession: widget.profession,
                      location: widget.location,
                      salary: widget.salary,
                      distance: widget.distance,
                    );
                  },
                );
              },
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
                              color: ui.Color.fromARGB(255, 189, 225, 190),
                            ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  screenWidth * .04,
                  screenWidth * .04,
                  screenWidth * .04,
                  screenWidth * .01,
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
                              "$careerPrompt What skills are most important for success in this field?",
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
                            "$careerPrompt. How do you handle difficult situations or conflicts at work?",
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
                            "$careerPrompt. Can you describe a typical day in your job?",
                            " Can you describe a typical day in your job?",
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
                            "$careerPrompt. How do you handle work-life balance in this career?",
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
                  screenWidth * .2,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
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
                                textCapitalization:
                                    TextCapitalization.sentences,
                                onSubmitted: (value) {
                                  sendMsg(
                                      "$careerPrompt. What would you say to this: $value",
                                      value);
                                  sentMessage = value;
                                },
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 20,
                                textInputAction: TextInputAction.send,
                                showCursor: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter text",
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            sendMsg(
                                "$careerPrompt. What would you say to this: $sentMessage",
                                sentMessage);
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
        ),
        confetti(_controllerCenter),
      ],
    );
  }
}
