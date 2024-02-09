// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

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
import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CareerChatbotPage extends StatefulWidget {
  @override
  _CareerChatbotPageState createState() => _CareerChatbotPageState();
}

class _CareerChatbotPageState extends State<CareerChatbotPage> {
  List<String> _response = [];
  String? currentHeadshot = "";
  var randomNames = RandomNames(Zone.us);

  String photo = RandomAvatarString(
    DateTime.now().toIso8601String(),
    trBackground: false,
  );

  var profile = ProfileData(
    photo: RandomAvatarString(
      DateTime.now().toIso8601String(),
      trBackground: false,
    ),
  );
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
    if (PrefsHelper().name != "") {
      print("profileList::: $profileList");
      profileList = ProfileData.decode(PrefsHelper().savedProfile);
    }
    _list.addAll(profileList);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _imageAndTextRow(ProfileData profile, double screenWidth) {
    print("PICTURE DATA: ${profile.photo}");
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
            width: screenWidth * .2,
            height: screenWidth * .2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey.withOpacity(0.5),
              border: Border.all(
                width: 3,
                color: Colors.teal,
              ),
            ),
            child: SvgPicture.string(
              profile.photo,
            ), // Container(),
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
      _list.addAll(state.data);
      print("lIST: $_list");
      PrefsHelper().savedProfile = ProfileData.encode(state.data);
      setState(() {});
    }
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
                DropdownSearch<String>(
                  items: professions,
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    textAlignVertical: TextAlignVertical.center,
                    dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                  ),
                  onChanged: (value) {
                    setState(() {
                      PrefsHelper().profession = value.toString();
                    });
                  },
                  selectedItem: PrefsHelper().profession,
                ),
                Text(
                  "Location",
                  style: TextStyle(
                    fontSize: screenWidth * .05,
                    height: 3,
                  ),
                ),
                DropdownSearch<String>(
                  items: locations,
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    textAlignVertical: TextAlignVertical.center,
                    dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                  ),
                  onChanged: (value) {
                    setState(() {
                      PrefsHelper().location = value.toString();
                    });
                  },
                  selectedItem: PrefsHelper().location,
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
                      "\$${PrefsHelper().salary}   ",
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
                  child: SizedBox(
                    width: screenWidth * 2,
                    child: Slider(
                      min: 0,
                      max: 400000,
                      divisions: 100,
                      value: PrefsHelper().salary.toDouble(),
                      label: PrefsHelper().salary.toString(),
                      onChanged: (value) {
                        setState(() {
                          PrefsHelper().salary = value.toInt();
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
                      "${PrefsHelper().distance} mi  ",
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
                  child: SizedBox(
                    width: screenWidth * 2,
                    child: Slider(
                      value: PrefsHelper().distance.toDouble(),
                      max: 100,
                      divisions: 100,
                      label: PrefsHelper().distance.toString(),
                      onChanged: (double value) {
                        setState(() {
                          PrefsHelper().distance = value.toInt();
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
                      // sendMsg(
                      //     "what is the range of the average salary of an artist located in grass valley, ca - just give me the numbers");

                      photo = RandomAvatarString(
                        DateTime.now().toIso8601String(),
                        trBackground: false,
                      );

                      print("PHOTO:: $photo");

                      String name = randomNames.name();
                      String description =
                          'Hi! I\'m $name and I am a ${PrefsHelper().profession}.  I make \$${PrefsHelper().salary} per year and I live in ${PrefsHelper().location}';

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Profile(
                            name: name,
                            description: description,
                            photo: photo,
                            response: _response,
                            context: context,
                            profession: PrefsHelper().profession,
                            location: PrefsHelper().location,
                            salary: PrefsHelper().salary,
                            distance: PrefsHelper().distance,
                          );
                        },
                      );
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
                          print("${_list[index]}");
                          ProfileData profile = _list[index];

                          print("BEFORE PROFILE: ${profile.name}");
                          print("BEFORE PROFILE: ${profile.photo}");
                          print("BEFORE PROFILE: ${profile.description}");

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
                                    profile: profile,
                                    dismissed: true,
                                  ),
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
                                        photo: profile.photo,
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
