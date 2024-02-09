import 'dart:convert';

import 'package:random_avatar/random_avatar.dart';

class ProfileData {
  String? name;
  String? description;
  String photo;
  String? location;
  String? profession;
  String? salary;
  String? distance;

  ProfileData({
    this.name,
    this.description,
    required this.photo,
    this.location,
    this.profession,
    this.salary,
    this.distance,
  });

  factory ProfileData.fromJson(Map<String, dynamic> parsedJson) {
    return ProfileData(
      name: parsedJson['name'] ?? "Mohammed",
      description: parsedJson['description'] ?? "No Description",
      photo: parsedJson['name'] ??
          RandomAvatarString(
            DateTime.now().toIso8601String(),
            trBackground: false,
          ),
      location: parsedJson['name'] ?? "San Francisco",
      profession: parsedJson['name'] ?? "Software Engineer",
      salary: parsedJson['name'] ?? "50000",
      distance: parsedJson['name'] ?? "5",
    );
  }

  static Map<String, dynamic> toMap(ProfileData data) => {
        'name': data.name,
        'description': data.description,
        'photo': data.photo,
        'location': data.location,
        'profession': data.profession,
        'salary': data.salary,
        'distance': data.distance,
      };

  static String encode(List<ProfileData> savedDataList) => json.encode(
        savedDataList
            .map<Map<String, dynamic>>((data) => ProfileData.toMap(data))
            .toList(),
        toEncodable: (savedDataList) => savedDataList,
      );

  static List<ProfileData> decode(String savedProfileString) =>
      (json.decode(savedProfileString) as List<dynamic>)
          .map<ProfileData>((item) => ProfileData.fromJson(item))
          .toList();
}