// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';

import 'package:chatgpt_completions/chatgpt_completions.dart';
import 'package:demo_app/bloc/home_bloc.dart';
import 'package:demo_app/bloc/home_state.dart';
import 'package:demo_app/chat.dart';
import 'package:demo_app/design.dart';
import 'package:demo_app/model/profile_info.dart';
import 'package:demo_app/options.dart';
import 'package:demo_app/profile.dart';
import 'package:demo_app/profile_remove_popup.dart';
import 'package:demo_app/shared_prefs.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:random_name_generator/random_name_generator.dart';

class CareerChatbotPage extends StatefulWidget {
  @override
  _CareerChatbotPageState createState() => _CareerChatbotPageState();
}

class _CareerChatbotPageState extends State<CareerChatbotPage> {
  late SingleValueDropDownController _cnt;
  late SingleValueDropDownController _cnt1;

  double _currentSliderValue = 50000;
  double _currentSliderValue1 = 10;

  List<String> _response = [];
  String? currentHeadshot = "";
  final TextEditingController _controller = TextEditingController();
  final List<Widget> _painters = <Widget>[];
  var randomNames = RandomNames(Zone.us);
  var profile = ProfileData();
  var profession = "";
  var location = "";
  var salary = "";
  var distance = "";
  List<ProfileData> profileList = [];
  List<ProfileData> _list = [];
  String? currentSavedDishInfoScreen = "";
  bool thereIsError = false;

  StreamSubscription? responseSubscription;

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
        profile.description = characters;
        setState(() {});
      },
      onStreamCreated: (subscription) {
        responseSubscription = subscription;
      },
      // Debounce 100ms for receive next value
      debounce: const Duration(milliseconds: 100),
    );
  }

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    _cnt1 = SingleValueDropDownController();

    if (PrefsHelper().name != "") {
      profileList = ProfileData.decode(PrefsHelper().savedProfile);
    }
    _list.addAll(profileList);
    super.initState();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _imageAndTextRow(ProfileData profile, double screenWidth) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        0,
        screenWidth * .01,
        0,
        screenWidth * .04,
      ),
      child: Row(
        children: [
          Container(
            height: screenWidth * .22,
            width: screenWidth * .35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Color(0xFFEb00FF),
                width: 2,
              ),
              image: !thereIsError
                  ? DecorationImage(
                      image: NetworkImage(profile.photo.toString()),
                      onError: (Object e, StackTrace? stackTrace) {
                        if (stackTrace != null) {
                          log(stackTrace.toString());
                        }
                        setState() {
                          print("🚩THERES AN ERORRRR");
                          thereIsError = true;
                        }
                      },
                      fit: BoxFit.fill,
                    )
                  : DecorationImage(
                      image: AssetImage("assets/blank_profile.png"),
                    ),
            ),
          ),
          _textColumn(profile, screenWidth),
        ],
      ),
    );
  }

  Widget _textColumn(ProfileData profile, double screenWidth) {
    return Container(
      width: screenWidth - 200,
      padding: EdgeInsets.fromLTRB(
        screenWidth * .038,
        0,
        0,
        0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${profile.name.toString()}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Poppins-Bold',
              fontSize: screenWidth * .038,
              color: Colors.black,
            ),
          ),
          Text(
            "${profile.description.toString()}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Poppins-Medium',
              fontSize: screenWidth * .034,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  _dishDisplayBlocListener(BuildContext context, HomeState state) {
    if (state is SavedProfileState) {
      print("SAVED");
      _list.clear();
      _list.addAll(state.data);
      PrefsHelper().savedProfile = ProfileData.encode(state.data);
      setState(() {});
    }

    // if (state is RemoveDishFromListState) {
    //   _list.clear();
    //   _list.addAll(state.list);
    //   PrefsHelper().savedPrefs = SavedData.encode(state.list);
    //   setState(() {});
    // }

    // if (state is RemoveDishFromInnerState) {
    //   print("GOT TO INNERRRR ");
    //   _list.removeWhere(
    //       (element) => element.dishId == currentSavedDishInfoScreen);
    //   currentSavedDishInfoScreen == "";
    //   PrefsHelper().savedPrefs = SavedData.encode(_list);
    //   setState(() {});
    // }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<HomeBloc, HomeState>(
      listener: _dishDisplayBlocListener,
      child: Scaffold(
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
                  searchDecoration:
                      const InputDecoration(hintText: "Enter a profession"),
                  validator: (value) {
                    if (value == null) {
                      return "Required field";
                    } else {
                      return null;
                    }
                  },
                  dropDownItemCount: 6,
                  dropDownList: dropdownValues,
                  onChanged: (val) {
                    profession = val.toString();
                  },
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
                  dropDownItemCount: 4,
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
                          salary = _currentSliderValue.toString();
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
                          distance = _currentSliderValue1.toString();
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      sendMsg(
                          "what is the range of the average salary of an artist located in grass valley, ca - just give me the numbers");

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

                      String name = randomNames.name();
                      String description = "Sup";
                      String photo = "assets/blank_profile.png"; // TODO: CHANGE

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Profile(
                            name: name,
                            painters: _painters,
                            response: _response,
                            context: context,
                            profession: profession,
                            location: location,
                            salary: salary,
                            distance: distance,
                          );
                        },
                      );
                      setState(() {});
                    });
                  },
                  child: const Text('Generate Bot'),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: screenWidth * .5,
                      child: ListView.builder(
                        itemCount: _list.length,
                        itemBuilder: (context, index) {
                          ProfileData profile = _list[index];

                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey[300]!, width: 1.5),
                              ),
                            ),
                            child: Dismissible(
                              key: Key(profile.name
                                  .toString()), // TODO: CHANGE TO ID
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                return await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      ProfileDataRemovePopup(
                                          profile: profile, dismissed: true),
                                );
                              },
                              onDismissed: (direction) {
                                setState(() {
                                  _list.removeWhere((element) =>
                                      element.name ==
                                      currentSavedDishInfoScreen);
                                  currentSavedDishInfoScreen == "";
                                  PrefsHelper().savedProfile =
                                      ProfileData.encode(_list);
                                  setState(() {});
                                  _list.removeAt(index);
                                });
                              },
                              background: Container(
                                color: Colors.red,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.delete,
                                        color: Colors.white,
                                        size: screenWidth * .1),
                                    SizedBox(width: screenWidth * .05),
                                  ],
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  currentSavedDishInfoScreen = profile.name;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CareerChat(
                                        name: (profile.name).toString(),
                                        painters: _painters,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    screenWidth * .02,
                                    screenWidth * .04,
                                    screenWidth * .02,
                                    screenWidth * .04,
                                  ),
                                  child: ListTile(
                                    title: Column(
                                      children: [
                                        _imageAndTextRow(profile, screenWidth),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
