// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chatgpt_completions/chatgpt_completions.dart';
import 'package:demo_app/model/message.dart';
import 'package:flutter/material.dart';
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
              alignment: Alignment.centerRight,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(
                  Icons.info_outline,
                  size: screenWidth * .06,
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
                                      fontSize: screenWidth * .05,
                                    ),
                                  ),
                                  Text(
                                    "${widget.profession}?",
                                    style: TextStyle(
                                      fontSize: screenWidth * .05,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenWidth * .04,
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
                                    height: screenWidth * .04,
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
                                              height: screenWidth * .04,
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
                                              height: screenWidth * .04,
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
                fontWeight: FontWeight.bold,
              ),
            )),
            SizedBox(
              height: screenWidth * .04,
            ),
            Container(
              width: screenWidth * .35,
              height: screenWidth * .35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueGrey.withOpacity(0.5),
                border: Border.all(
                  width: 3,
                  color: Colors.teal,
                ),
              ),
              child: widget.photo == ""
                  ? Container()
                  : SvgPicture.string(
                      widget.photo,
                    ),
            ),
            SizedBox(
              height: screenWidth * .04,
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
