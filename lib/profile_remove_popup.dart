// ignore_for_file: prefer_const_constructors

import 'package:demo_app/model/profile_info.dart';
import 'package:flutter/material.dart';

class ProfileDataRemovePopup extends StatefulWidget {
  final ProfileData profile;
  final bool dismissed;
  const ProfileDataRemovePopup({
    Key? key,
    required this.profile,
    required this.dismissed,
  }) : super(key: key);

  @override
  State<ProfileDataRemovePopup> createState() =>
      _SavedScreenRemovePopup(dismissed: dismissed);
}

class _SavedScreenRemovePopup extends State<ProfileDataRemovePopup> {
  final bool dismissed;
  _SavedScreenRemovePopup({required this.dismissed});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.5),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * .5),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.delete,
            size: screenWidth * .06,
          ),
          SizedBox(
            height: screenWidth * .03,
          ),
          Text(
            "Are you sure you\nwant to delete this conversation?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * .04,
            ),
          ),
          SizedBox(height: screenWidth * .04),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: screenWidth * .04,
              ),
              Container(
                width: screenWidth * .23,
                height: screenWidth * .1,
                child: ElevatedButton(
                  onPressed: () {
                    if (!dismissed) {
                      Navigator.pop(context);
                    }
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15.625),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    "Yes",
                    style: TextStyle(
                      fontSize: screenWidth * .04,
                    ),
                  ),
                ),
              ),
              Container(
                width: screenWidth * .23,
                height: screenWidth * .1,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.625),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    "No",
                    style: TextStyle(
                      fontSize: screenWidth * .04,
                      fontFamily: 'Poppins-Bold',
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * .04)
            ],
          ),
        ],
      ),
    );
  }
}
