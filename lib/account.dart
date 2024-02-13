// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:math';

import 'package:demo_app/commons/options.dart';
import 'package:demo_app/prefs/shared_prefs.dart';
import 'package:confetti/confetti.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
  final TextEditingController _textEditingController2 = TextEditingController();

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  late ConfettiController _controllerCenter; // CONFETTI! :D

  File? imageFile;

  final TextEditingController _assetController = TextEditingController();

  ImageProvider<Object> userImage = AssetImage("assets/blank_profile.png");

  bool showAvg = false;

  List<bool> isSelectedList =
      List.generate(careersWithEmoji.length, (index) => false);

  double _preferredSalary = PrefsHelper().salary.toDouble();

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
    _textEditingController2.text = PrefsHelper().accountLocation;

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
          insetPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * .2,
            vertical: screenWidth * .4,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenWidth * .02,
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
                            height: screenWidth * .35,
                            width: screenWidth * .35,
                          ),
                        );
                        _assetController.text = svg;
                        setState(() {});
                      },
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

  Form userName(double screenWidth) {
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
              height: screenWidth * .1,
              child: Text(
                _textEditingController1.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * .05,
                ),
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Card(
                    margin: EdgeInsets.fromLTRB(
                      screenWidth * .15,
                      MediaQuery.of(context).size.height / 2.5,
                      screenWidth * .15,
                      MediaQuery.of(context).size.height / 2.5,
                    ),
                    child: SizedBox(
                      width: screenWidth * .3,
                      child: TextField(
                        controller: _textEditingController1,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Who are you?',
                          contentPadding: EdgeInsets.fromLTRB(
                            screenWidth * .04,
                            screenWidth * .04,
                            screenWidth * .04,
                            0,
                          ),
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
            width: screenWidth * .1,
          )
        ],
      ),
    );
  }

// FOR LATER
  userLocation(double screenWidth) {
    if (PrefsHelper().accountLocation == "Location" ||
        PrefsHelper().accountLocation == "") {
      _textEditingController2.text = "Location";
    }
    return GestureDetector(
      child: SizedBox(
        height: 50,
        child: Text(
          _textEditingController2.text,
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
            return AlertDialog(
              insetPadding: EdgeInsets.all(50),
              content: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Location",
                      style: TextStyle(
                        fontSize: screenWidth * .05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Card(
                    child: DropdownSearch<String>(
                      items: locations,
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        textAlignVertical: TextAlignVertical.center,
                        dropdownSearchDecoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          PrefsHelper().accountLocation = value.toString();
                        });
                      },
                      selectedItem: PrefsHelper().accountLocation,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
                            Column(
                              children: [
                                userName(width),
                                // userLocation(width),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  left: width * .05,
                  top: width * .05,
                  bottom: width * .02,
                ),
                child: Row(
                  children: [
                    Text(
                      "Profession Prefs",
                      style: TextStyle(
                        fontSize: width * .05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(
                          Icons.info_outline,
                          size: width * .05,
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
                                        top: width * .01,
                                      ),
                                      height: width * .3,
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Note:",
                                              style: TextStyle(
                                                fontSize: width * .045,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "These preferences will reflect in your Explore page!",
                                            style: TextStyle(
                                              fontSize: width * .035,
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
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        // color: Color.fromARGB(255, 230, 255, 201),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    padding: EdgeInsets.only(
                      right: width * .04,
                      left: width * .04,
                    ),
                    margin: EdgeInsets.only(
                      right: width * .04,
                      left: width * .04,
                    ),
                    child: Wrap(
                      spacing: 4,
                      direction: Axis.horizontal,
                      children: List.generate(careersWithEmoji.length, (index) {
                        return TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: isSelectedList[index]
                                ? Color.fromARGB(255, 187, 224, 190)
                                : Color.fromARGB(255, 240, 254, 223),
                            padding: EdgeInsets.fromLTRB(
                              width * .02,
                              0,
                              width * .02,
                              0,
                            ),
                            elevation: 2,
                            side: BorderSide(
                              color: isSelectedList[index]
                                  ? Color.fromARGB(255, 93, 135, 95)
                                  : Color.fromARGB(255, 178, 199, 151),
                            ),
                          ),
                          child: Text(
                            careersWithEmoji[index],
                            style: TextStyle(
                              fontSize: width * .04,
                            ),
                          ),
                          onPressed: () {
                            // Toggle the selected state
                            List<String> thisList =
                                PrefsHelper().savedProfessions;

                            isSelectedList[index]
                                ? thisList.remove(careersWithEmoji[index])
                                : thisList.insert(
                                    0,
                                    careersWithEmoji[index].toString(),
                                  );

                            isSelectedList[index] = !isSelectedList[
                                index]; // Toggle the selected state of the button at index

                            PrefsHelper().savedProfessions = thisList;
                            print(PrefsHelper().savedProfessions);
                            setState(() {});
                          },
                        );
                      }),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  left: width * .05,
                  top: 0,
                  bottom: width * .01,
                  right: width * .05,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Salary Prefs",
                          style: TextStyle(
                            fontSize: width * .05,
                            height: 3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "\$${PrefsHelper().preferredSalary}   ",
                          style: TextStyle(
                            fontSize: width * .04,
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        overlayShape: SliderComponentShape.noOverlay,
                      ),
                      child: SizedBox(
                        width: width * 2,
                        child: Slider(
                          min: 0,
                          max: 400000,
                          divisions: 100,
                          value: PrefsHelper().preferredSalary.toDouble(),
                          label: PrefsHelper().preferredSalary.toString(),
                          onChanged: (value) {
                            setState(() {
                              _preferredSalary = value;
                              PrefsHelper().preferredSalary =
                                  _preferredSalary.toInt();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: width * .6,
              )
            ],
          ),
        ),
        confetti(_controllerCenter),
      ],
    );
  }
}
