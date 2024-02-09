// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:demo_app/bloc/home_bloc.dart';
import 'package:demo_app/bloc/home_event.dart';
import 'package:demo_app/chat.dart';
import 'package:demo_app/model/profile_info.dart';
import 'package:demo_app/shared_prefs.dart';
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
  });

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                'Hi! I\'m ${widget.name}',
                style: TextStyle(
                  fontSize: screenWidth * .06,
                  height: 4,
                ),
              ),
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
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CareerChat(
                                name: widget.name,
                                photo: widget.photo,
                              ),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            'Chat',
                            style: TextStyle(
                              fontSize: screenWidth * .04,
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
            const SizedBox(height: 16.0),
            Text(widget.description.toString()),
            const SizedBox(height: 10.0),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Profession: ${widget.profession}',
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text('Salary: ${widget.salary}'),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text('Location: ${widget.location}'),
            ),
          ],
        ),
      ),
    );
  }
}
