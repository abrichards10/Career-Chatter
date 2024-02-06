// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:demo_app/chat.dart';
import 'package:demo_app/design.dart';
import 'package:demo_app/options.dart';
import 'package:demo_app/profile.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:random_name_generator/random_name_generator.dart';

class CareerChatbotPage extends StatefulWidget {
  @override
  _CareerChatbotPageState createState() => _CareerChatbotPageState();
}

class _CareerChatbotPageState extends State<CareerChatbotPage> {
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _minimumSalaryController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  late SingleValueDropDownController _cnt;
  late SingleValueDropDownController _cnt1;

  double _currentSliderValue = 50000;
  double _currentSliderValue1 = 10;

  List<String> _response = [];
  String? currentHeadshot = "";
  final TextEditingController _controller = TextEditingController();
  final List<Widget> _painters = <Widget>[];
  var randomNames = RandomNames(Zone.us);

  _generateBot() async {
    print("clicked");
    String profession = _professionController.text ?? "Software Engineer";
    double minimumSalary =
        double.tryParse(_minimumSalaryController.text) ?? 50000;
    String location = _locationController.text ?? "New York";
    double distance = double.tryParse(_distanceController.text) ?? 10;
    _response.clear();

    try {
      // The user message to be sent to the request.
      final userMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
              // 'Create a bot for profession: $profession, minimum salary: $minimumSalary, location: $location, distance: $distance and return attributes: profession, minimumSalary, location, distance, number of pets, whether or not they are married in a list format',
              'Return one random name, one profession, one salary, one location, and one distance'),
        ],
        role: OpenAIChatMessageRole.user,
      );

      final chatBot = OpenAI.instance.chat.createStream(
        model: "gpt-3.5-turbo",
        messages: [
          userMessage,
        ],
        seed: 423,
        n: 2,
      );

      chatBot.listen(
        // Listen to the stream.
        (streamChatCompletion) {
          final content =
              streamChatCompletion.choices.first.delta.content?[0].text;
          setState(() {
            print((content));
            // print("response: $_response");
            _response.insert(_response.length, (content).toString());
          });
        },
        onDone: () {
          print("Done");
          setState(() {});
        },
      );
    } catch (e) {
      print("There was an error");
      setState(() {
        _response = ['Error: $e'];
      });
    }
  }

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    _cnt1 = SingleValueDropDownController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Chatbot'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Profession",
                style: TextStyle(
                  fontSize: screenWidth * .05,
                  // height: 3,
                ),
              ),
              DropDownTextField(
                controller: _cnt,
                clearOption: true,
                enableSearch: true,
                // dropdownColor: Colors.green,
                searchDecoration:
                    const InputDecoration(hintText: "Enter a profession"),
                validator: (value) {
                  if (value == null) {
                    return "Required field";
                  } else {
                    return null;
                  }
                },
                dropDownItemCount: professions.length,
                dropDownList: dropdownValues,
                onChanged: (val) {},
              ),
              Text(
                "Location",
                style: TextStyle(
                  fontSize: screenWidth * .05,
                  height: 3,
                ),
              ),
              DropDownTextField(
                controller: _cnt1,
                clearOption: true,
                enableSearch: true,
                // dropdownColor: Colors.green,
                searchDecoration:
                    const InputDecoration(hintText: "Enter a location"),
                validator: (value) {
                  if (value == null) {
                    return "Required field";
                  } else {
                    return null;
                  }
                },
                dropDownItemCount: locations.length,
                dropDownList: dropdownValuesLocation,
                onChanged: (val) {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Minimum Salary",
                    style: TextStyle(
                      fontSize: screenWidth * .05,
                      height: 3,
                    ),
                  ),
                  Text(
                    "\$${_currentSliderValue.round()}   ",
                    style: TextStyle(
                      fontSize: screenWidth * .04,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Container(
                  width: screenWidth * 2,
                  child: Slider(
                    min: 0,
                    max: 400000,
                    divisions: 100,
                    value: _currentSliderValue,
                    label: _currentSliderValue.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Distance",
                    style: TextStyle(
                      fontSize: screenWidth * .05,
                      height: 3,
                    ),
                  ),
                  Text(
                    "${_currentSliderValue1.round()} mi  ",
                    style: TextStyle(
                      fontSize: screenWidth * .04,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Container(
                  width: screenWidth * 2,
                  child: Slider(
                    value: _currentSliderValue1,
                    max: 100,
                    divisions: 100,
                    label: _currentSliderValue1.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue1 = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _generateBot();

                    String svg = RandomAvatarString(
                      DateTime.now().toIso8601String(),
                      trBackground: false,
                    );

                    _painters.clear();

                    _painters.add(
                      RandomAvatar(
                        DateTime.now().toIso8601String(),
                        height: 50,
                        width: 52,
                      ),
                    );
                    _controller.text = svg;

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Profile(
                          name: randomNames.name(),
                          painters: _painters,
                          response: _response,
                          context: context,
                        );
                      },
                    );
                  });
                },
                child: const Text('Generate Bot'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
