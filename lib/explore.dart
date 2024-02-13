// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:demo_app/bloc/home_bloc.dart';
import 'package:demo_app/bloc/home_event.dart';
import 'package:demo_app/chat.dart';
import 'package:demo_app/commons/design.dart';
import 'package:demo_app/model/profile_info.dart';
import 'package:demo_app/commons/options.dart';
import 'package:demo_app/profile_remove_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<ProfileData> _exploreProfileList = [];
  final _random = Random();

  @override
  void initState() {
    for (int i = 0; i < 10; i++) {
      String randomName = RandomNames(Zone.us).name();
      String thisProfession = professions[_random.nextInt(professions.length)];
      String thisLocation = locations[_random.nextInt(locations.length)];
      int thisSalary =
          _random.nextInt(400000) + 15000; // TODO: change to calculated;
      int thisDistance = _random.nextInt(25);
      String thisDescription =
          'Hi! I\'m $randomName and I am a $thisProfession.  I make \$$thisSalary per year and I live in $thisLocation';

      _exploreProfileList.insert(
        0,
        ProfileData(
          name: randomName,
          description: thisDescription,
          photo: RandomAvatarString(
            DateTime.now().toIso8601String(),
            trBackground: false,
          ),
          profession: thisProfession,
          salary: thisSalary.toString(),
          distance: thisDistance.toString(),
          location: thisLocation,
        ),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Explore 🔥',
          style: TextStyle(
            fontSize: screenWidth * .06,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
        height: screenWidth * 1.3,
        child: ListView.builder(
          itemCount: _exploreProfileList.length,
          itemBuilder: (context, index) {
            ProfileData thisProfile = _exploreProfileList[index];

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
                key: Key(thisProfile.name.toString()), // TODO: CHANGE TO ID
                confirmDismiss: (DismissDirection direction) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) => ProfileDataRemovePopup(
                      profile: thisProfile,
                      dismissed: true,
                    ),
                  );
                },
                onDismissed: (direction) {
                  setState(() {
                    context.read<HomeBloc>().add(RemoveProfileEvent());
                    _exploreProfileList.removeAt(index);
                  });
                },
                background: Container(
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                    // currentSavedProfileInfoScreen = thisProfile.name;
                    context.read<HomeBloc>().add(
                          SavedProfileEvent(
                            (thisProfile.name).toString(),
                            thisProfile.photo,
                            thisProfile.description.toString(),
                            thisProfile.profession.toString(),
                            thisProfile.location.toString(),
                            int.parse(thisProfile.salary.toString()),
                            int.parse(thisProfile.distance.toString()),
                          ),
                        );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CareerChat(
                            name: (thisProfile.name).toString(),
                            photo: thisProfile.photo,
                            description: thisProfile.description.toString(),
                            profession: thisProfile.profession.toString(),
                            salary: int.parse(thisProfile.salary.toString()),
                            location: thisProfile.location.toString(),
                            distance:
                                int.parse(thisProfile.distance.toString()),
                            rating: thisProfile.rating == null
                                ? null
                                : double.parse(thisProfile.rating.toString())),
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
    );
  }
}
