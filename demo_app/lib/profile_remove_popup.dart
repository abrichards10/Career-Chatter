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
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.5),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 50),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.delete,
            color: Colors.black,
            size: 27.6, // 15% larger size
          ),
          SizedBox(height: 8),
          Text(
            "Are you sure you\nwant to unsave this profile?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Poppins-Bold',
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 10),
              Container(
                width: 87,
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    if (!dismissed) {
                      Navigator.pop(context);
                    }
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEb00FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.625),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    "Yes",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Poppins-Bold',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                width: 87,
                height: 35,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFFEb00FF)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.625),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    "No",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Poppins-Bold',
                      color: Color(0xFFEb00FF),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10)
            ],
          ),
        ],
      ),
    );
  }
}
