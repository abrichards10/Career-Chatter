// ignore_for_file: prefer_const_constructors

import 'package:demo_app/bloc/home_bloc.dart';
import 'package:demo_app/bloc/home_event.dart';
import 'package:demo_app/chat.dart';
import 'package:demo_app/model/profile_info.dart';
import 'package:demo_app/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatefulWidget {
  final List<Widget> painters;
  final List<String> response;
  final BuildContext context;
  final String name;
  final String profession;
  final String location;
  final String salary;
  final String distance;

  const Profile({
    super.key,
    required this.name,
    required this.painters,
    required this.response,
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
                  child: widget.painters.isEmpty
                      ? Container()
                      : widget.painters[0],
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
                                  "assets/blank_profile.png",
                                  "",
                                  widget.profession,
                                  widget.location,
                                  widget.salary,
                                  widget.distance,
                                ),
                              );

                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CareerChat(
                                    name: widget.name,
                                    painters: widget.painters)),
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
            Text(widget.response.toString()),
            Text('Hi! I\'m ${widget.name} and I am a ${widget.profession} '),
            Text('Profession: ${widget.profession}'),
            Text('Salary: ${widget.salary}'),
            Text('Location: ${widget.location}'),
          ],
        ),
      ),
    );
  }
}
