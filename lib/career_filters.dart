// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:demo_app/commons/options.dart';
import 'package:demo_app/profile.dart';
import 'package:demo_app/prefs/shared_prefs.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:random_name_generator/random_name_generator.dart';

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
            height: screenWidth * .04,
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
          SizedBox(
            height: screenWidth * .05,
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
          SizedBox(
            height: screenWidth * .05,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "*Note: Results are not always an accurate representation of professions in the area, they are merely an estimate.",
              style: TextStyle(
                fontSize: screenWidth * .03,
              ),
            ),
          )
        ],
      ),
    );
  }
}
