// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:demo_app/bloc/home_bloc.dart';
import 'package:demo_app/bloc/home_event.dart';
import 'package:demo_app/chat.dart';
import 'package:demo_app/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                height: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: screenWidth * .03,
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
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * .04,
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
                        left: screenWidth * .04,
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
              height: screenWidth * .04,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * .04,
                ),
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

