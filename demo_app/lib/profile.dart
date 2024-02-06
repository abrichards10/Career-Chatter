// ignore_for_file: prefer_const_constructors

import 'package:demo_app/chat.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final List<Widget> painters;
  final List<String> response;
  final BuildContext context;
  final String name;

  const Profile(
      {super.key,
      required this.name,
      required this.painters,
      required this.response,
      required this.context});

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
                // Text(_response.toString()),
                // Text('Name: ${profile['name']}'),
                // Text('Profession: ${profile['profession']}'),
                // Text('Salary: ${profile['salary']}'),
                // Text('Location: ${profile['location']}'),
                // Text('Has Pet: ${profile['has_pet']}'),
                // Text('Married: ${profile['married']}'),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(widget.response.toString()),
          ],
        ),
      ),
    );
  }
}
