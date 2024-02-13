// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';
import 'dart:math';

import 'package:chatgpt_completions/chatgpt_completions.dart';
import 'package:demo_app/account.dart';
import 'package:demo_app/bloc/home_bloc.dart';
import 'package:demo_app/bloc/home_event.dart';
import 'package:demo_app/bloc/home_state.dart';
import 'package:demo_app/career_filters.dart';
import 'package:demo_app/chat.dart';
import 'package:demo_app/commons/design.dart';
import 'package:demo_app/explore.dart';
import 'package:demo_app/model/profile_info.dart';
import 'package:demo_app/commons/options.dart';
import 'package:demo_app/profile.dart';
import 'package:demo_app/profile_remove_popup.dart';
import 'package:demo_app/prefs/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:random_name_generator/random_name_generator.dart';

class CareerChatbotPage extends StatefulWidget {
  @override
  _CareerChatbotPageState createState() => _CareerChatbotPageState();
}

class _CareerChatbotPageState extends State<CareerChatbotPage> {
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

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Account(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<HomeBloc, HomeState>(
      listener: _dishDisplayBlocListener,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).push(_createRoute());
            },
          ),
          title: Text(
            PrefsHelper().accountName == ""
                ? "Hello! 👋"
                : "Hi ${PrefsHelper().accountName}! 🎯",
            style: TextStyle(
              fontSize: screenWidth * .06,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.explore_sharp,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Explore(),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(
              screenWidth * .03,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    bottom: screenWidth * .01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: SizedBox(
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
                                    width: screenWidth * .04,
                                  ),
                                  Text(
                                    "Randomize!",
                                    style: TextStyle(
                                      fontSize: screenWidth * .04,
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
                        child: SizedBox(
                          height: screenWidth * .3,
                          width: screenWidth * .3,
                          child: Card(
                            child: Text(
                              "+",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: screenWidth * .16,
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
                                          Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: screenWidth * .1,
                                          ),
                                          SizedBox(
                                            width: screenWidth * .05,
                                          ),
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
                                              imageAndTextRow(
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
}
