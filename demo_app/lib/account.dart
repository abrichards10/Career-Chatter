// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:math';

import 'package:demo_app/commons/options.dart';
import 'package:demo_app/prefs/shared_prefs.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_avatar/random_avatar.dart';
import 'dart:ui' as ui;

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => AccountState();
}

class AccountState extends State<Account> with SingleTickerProviderStateMixin {
  final TextEditingController _textEditingController1 = TextEditingController();
  final formKey1 = GlobalKey<FormState>();
  late ConfettiController _controllerCenter; // CONFETTI! :D

  File? imageFile;

  final TextEditingController _assetController = TextEditingController();

  ImageProvider<Object> userImage = AssetImage("assets/blank_profile.png");

  bool showAvg = false;

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
  void initState() {
    _textEditingController1.text = PrefsHelper().accountName;
    _controllerCenter = ConfettiController(
      duration: const Duration(seconds: 1),
    );
    super.initState();
  }

  @override
  void dispose() {
    _assetController.dispose();
    _controllerCenter.dispose(); // Dispose of confetti
    super.dispose();
  }

  _pickImageSource(double screenWidth) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 90, vertical: 120),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        String svg = RandomAvatarString(
                          DateTime.now().toIso8601String(),
                          trBackground: true,
                        );
                        painters.clear();

                        painters.add(
                          RandomAvatar(
                            DateTime.now().toIso8601String(),
                            height: 130,
                            width: 132,
                          ),
                        );
                        _assetController.text = svg;
                        setState(() {});
                      },
                      tooltip: 'Generate',
                      child: Icon(
                        Icons.gesture,
                      ),
                    ),
                    TextButton(
                      child: Text(
                        '  Approve ✓',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * .04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        PrefsHelper().randomImageChosen = true;
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget gradientDecor() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 195, 226, 161),
            Color.fromARGB(255, 255, 255, 255),
          ],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
      ),
    );
  }

  Widget userIcon(height, width) {
    return GestureDetector(
      onTap: () {
        _pickImageSource(width);
      },
      child: CircleAvatar(
        radius: height / 11,
        child: (PrefsHelper().randomImageChosen && painters.isNotEmpty)
            ? painters[0]
            : CircleAvatar(
                backgroundImage:
                    imageFile == null ? userImage : FileImage(imageFile!),
                radius: height / 10,
              ),
      ),
    );
  }

  Form userName() {
    if (PrefsHelper().accountName == "Name" ||
        PrefsHelper().accountName == "") {
      _textEditingController1.text = "Name";
    }
    return Form(
      key: formKey1,
      child: Row(
        children: [
          GestureDetector(
            child: SizedBox(
              height: 50,
              child: Text(
                _textEditingController1.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Card(
                    margin: EdgeInsets.fromLTRB(
                      70,
                      MediaQuery.of(context).size.height / 2.5,
                      70,
                      MediaQuery.of(context).size.height / 2.5,
                    ),
                    child: SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _textEditingController1,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Who are you?',
                          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        ),
                        maxLength: 20,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        onSubmitted: (value) {
                          PrefsHelper().accountName = value;
                          _textEditingController1.text = value;
                          _controllerCenter.play(); // Confetti!
                          Navigator.pop(context);
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(
            width: 50,
          )
        ],
      ),
    );
  }

  Widget headerChild(String header, String value) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            header,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }

  Widget infoChild(double width, IconData icon, data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        child: Row(
          children: <Widget>[
            SizedBox(
              width: width / 10,
            ),
            Icon(
              icon,
              size: 36.0,
            ),
            SizedBox(
              width: width / 20,
            ),
            Text(
              data,
              style: TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
        onTap: () {
          // print('Info Object selected');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        gradientDecor(),
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
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            userIcon(height, width),
                            userName(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 30, top: 30, bottom: 10),
                child: Text(
                  "Profession Prefs",
                  style: TextStyle(
                    fontSize: width * .05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: Wrap(
                      spacing: 3,
                      direction: Axis.horizontal,
                      children: [
                        for (var i in careersWithEmoji)
                          TextButton(
                            child: Text(
                              i,
                              style: TextStyle(
                                fontSize: width * .05,
                              ),
                            ),
                            onPressed: () {
                              print(i);
                              PrefsHelper().savedProfessions.insert(0, i);

                              print(PrefsHelper().savedProfessions);
                              setState(() {});
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Text("HELLOP{DNSKPJ:EBF}")
            ],
          ),
        ),
        confetti(_controllerCenter),
      ],
    );
  }
}
