// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:chatgpt_completions/chatgpt_completions.dart';
import 'package:demo_app/bloc/home_bloc.dart';
import 'package:demo_app/bloc/home_event.dart';
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
  var randomNames =
      RandomNames(Zone.us); // TODO: change for inclusive language regions

  final _random = new Random();

  var profile = ProfileData(
    photo: RandomAvatarString(
      DateTime.now().toIso8601String(),
      trBackground: false,
    ),
  );

  List<ProfileData> _profileList = [];

  String? currentSavedProfileInfoScreen = "";
  bool thereIsError = false;

  StreamSubscription? responseSubscription;

  double sliderSalary = PrefsHelper().salary.toDouble();
  double sliderDistance = PrefsHelper().distance.toDouble();

  void _showFilters() async {
    // this will contain the result from Navigator.pop(context, result)
    final _selectedFilters = await showDialog<double>(
      context: context,
      builder: (context) => CareerFilters(
        initialSalary: sliderSalary,
        initialDistance: sliderDistance,
      ),
    );

    // execution of this code continues when the dialog was closed (popped)

    // note that the result can also be null, so check it
    // (back button or pressed outside of the dialog)
    if (_selectedFilters != null) {
      setState(() {
        sliderSalary = _selectedFilters;
      });
    }
  }

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
    super.initState();

    if (_profileList.isNotEmpty) {
      _profileList = ProfileData.decode(PrefsHelper().savedProfile);
    }

    context.read<HomeBloc>().add(ReturnSavedProfile());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _imageAndTextRow(ProfileData thisProfile, double screenWidth) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        0,
        screenWidth * .01,
        0,
        screenWidth * .01,
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
              thisProfile.photo,
            ), // Container(),
          ),
          _textColumn(thisProfile, screenWidth),
        ],
      ),
    );
  }

  Widget _textColumn(ProfileData thisProfile, double screenWidth) {
    return Container(
      width: screenWidth - 170,
      padding: EdgeInsets.fromLTRB(
        screenWidth * .038,
        0,
        0,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                thisProfile.name.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: screenWidth * .04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                thisProfile.profession.toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: screenWidth * .033,
                ),
              ),
            ],
          ),
          thisProfile.rating == null
              ? Container()
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        thisProfile.rating.toString(),
                        style: TextStyle(
                          fontSize: screenWidth * .04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  _dishDisplayBlocListener(BuildContext context, HomeState state) {
    if (state is SavedProfileState) {
      print("SAVED");
      _profileList = state.data;
      PrefsHelper().savedProfile = ProfileData.encode(state.data);
      setState(() {});
    }
    if (state is RemoveProfileState) {
      print("GOT TO INNERRRR ");
      _profileList.removeWhere(
          (element) => element.name == currentSavedProfileInfoScreen);
      currentSavedProfileInfoScreen == "";
      PrefsHelper().savedProfile = ProfileData.encode(_profileList);
      setState(() {});
    }
    if (state is ReturnSavedProfileState) {
      print("GOT TO RETURNSAVED");
      _profileList = state.data;
      PrefsHelper().savedProfile = ProfileData.encode(state.data);

      print(_profileList);
      setState(() {});
    }

    if (state is AddRatingState) {
      _profileList = state.data;
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
            leading: IconButton(
              icon: Icon(Icons.menu_book_sharp),
              onPressed: () {},
            ),
            title: Text(
              'Career Chatbot',
              style: TextStyle(
                fontSize: screenWidth * .07,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(icon: Icon(Icons.menu), onPressed: () {}),
            ]),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          height: screenWidth * .3,
                          width: screenWidth * .6,
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                screenWidth * .04,
                                screenWidth * .04,
                                screenWidth * .04,
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
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image(
                                        image: AssetImage(
                                            "assets/blank_profile.png"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Randomize!",
                                    style: TextStyle(
                                      fontSize: screenWidth * .045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            String randomName = randomNames.name();
                            String thisProfession = professions[
                                _random.nextInt(professions.length)];
                            String thisLocation =
                                locations[_random.nextInt(locations.length)];
                            int thisSalary = _random.nextInt(400000) +
                                15000; // TODO: change to calculated;
                            int thisDistance = _random.nextInt(25);

                            String thisDescription =
                                'Hi! I\'m $randomName and I am a $thisProfession.  I make \$$thisSalary per year and I live in $thisLocation';

                            showDialog(
                              context: context,
                              builder: (context) {
                                return Profile(
                                  name: randomName,
                                  photo: RandomAvatarString(
                                    DateTime.now().toIso8601String(),
                                    trBackground: false,
                                  ),
                                  description: thisDescription,
                                  context: context,
                                  profession: thisProfession,
                                  location: thisLocation,
                                  salary: thisSalary,
                                  distance: thisDistance,
                                );
                              },
                            );
                          });
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          height: screenWidth * .3,
                          width: screenWidth * .3,
                          child: Card(
                            child: Text(
                              "+",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: screenWidth * .2,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          _showFilters();
                        },
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    _profileList.isEmpty
                        ? _defaultListView(screenWidth)
                        : SizedBox(
                            height: screenWidth * 1.3,
                            child: ListView.builder(
                              itemCount: _profileList.length,
                              itemBuilder: (context, index) {
                                ProfileData thisProfile = _profileList[index];

                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  child: Dismissible(
                                    key: Key(thisProfile.name
                                        .toString()), // TODO: CHANGE TO ID
                                    confirmDismiss:
                                        (DismissDirection direction) async {
                                      return await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            ProfileDataRemovePopup(
                                          profile: thisProfile,
                                          dismissed: true,
                                        ),
                                      );
                                    },
                                    onDismissed: (direction) {
                                      setState(() {
                                        context
                                            .read<HomeBloc>()
                                            .add(RemoveProfileEvent());
                                        _profileList.removeAt(index);
                                      });
                                    },
                                    background: Container(
                                      color: Colors.red,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                        currentSavedProfileInfoScreen =
                                            thisProfile.name;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CareerChat(
                                              name:
                                                  (thisProfile.name).toString(),
                                              photo: thisProfile.photo,
                                              description: thisProfile
                                                  .description
                                                  .toString(),
                                              profession: thisProfile.profession
                                                  .toString(),
                                              salary: int.parse(thisProfile
                                                  .salary
                                                  .toString()),
                                              location: thisProfile.location
                                                  .toString(),
                                              distance: int.parse(thisProfile
                                                  .distance
                                                  .toString()),
                                              rating: thisProfile.rating,
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
                                              _imageAndTextRow(
                                                thisProfile,
                                                screenWidth,
                                              ),
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

  Widget _defaultListView(double screenWidth) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            screenWidth * .045,
            screenWidth * .03,
            screenWidth * .045,
            0,
          ),
          child: Column(
            children: [
              Text(
                'You have no conversations! \n\nTo add one, tap one of the buttons above ☝',
                style: TextStyle(fontSize: screenWidth * .05),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// FILTERS: TODO: MOVE

class CareerFilters extends StatefulWidget {
  /// initial selection for the slider
  final double initialSalary;
  final double initialDistance;

  const CareerFilters({
    required this.initialSalary,
    required this.initialDistance,
  }) : super();

  @override
  _CareerFiltersState createState() => _CareerFiltersState();
}

class _CareerFiltersState extends State<CareerFilters> {
  /// current selection of the slider
  late double _salary;
  late double _distance;
  var randomNames = RandomNames(Zone.us);

  @override
  void initState() {
    super.initState();
    _salary = widget.initialSalary;
    _distance = widget.initialDistance;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, _salary);
            Navigator.pop(context, _distance);
          },
          child: Container(
            height: 0,
          ),
        )
      ],
      content: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Profession",
              style: TextStyle(
                fontSize: screenWidth * .05,
                height: 3,
                fontWeight: FontWeight.bold,
              ),
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
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Location",
              style: TextStyle(
                fontSize: screenWidth * .05,
                height: 3,
                fontWeight: FontWeight.bold,
              ),
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
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Minimum Salary",
                style: TextStyle(
                  fontSize: screenWidth * .05,
                  height: 3,
                  fontWeight: FontWeight.bold,
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
                value: _salary,
                label: PrefsHelper().salary.toString(),
                onChanged: (value) {
                  setState(() {
                    _salary = value;
                    PrefsHelper().salary = _salary.toInt();
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
                  fontWeight: FontWeight.bold,
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
                value: _distance,
                max: 100,
                divisions: 100,
                label: PrefsHelper().distance.toString(),
                onChanged: (double value) {
                  setState(() {
                    _distance = value;
                    PrefsHelper().distance = _distance.toInt();
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 3,
              ),
              onPressed: () {
                setState(() {
                  // sendMsg(
                  //     "what is the range of the average salary of an artist located in grass valley, ca - just give me the numbers");

                  String photo = RandomAvatarString(
                    DateTime.now().toIso8601String(),
                    trBackground: false,
                  );

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
              child: Text(
                'Generate!',
                style: TextStyle(
                  fontSize: screenWidth * .04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
