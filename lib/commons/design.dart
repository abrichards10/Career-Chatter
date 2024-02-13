// ignore_for_file: prefer_const_constructors, avoid_print
// COMMON SHARED WIDGETS

import 'package:demo_app/model/profile_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

final mainFont = GoogleFonts.hahmlet();
// final mainFont = GoogleFonts.buda();
// final mainFont = GoogleFonts.comicNeue();

Widget imageAndTextRow(ProfileData thisProfile, double screenWidth) {
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
        textColumn(thisProfile, screenWidth),
      ],
    ),
  );
}

Widget textColumn(ProfileData thisProfile, double screenWidth) {
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
                    SizedBox(
                      width: screenWidth * .01,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: screenWidth * .05,
                    )
                  ],
                ),
              ),
      ],
    ),
  );
}
