import 'dart:convert';

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

  factory ProfileData.fromJson(Map<String, dynamic> jsonData) {
    return ProfileData(
      name: jsonData['name'],
      description: jsonData['description'],
      photo: jsonData['photo'],
      location: jsonData['location'],
      profession: jsonData['profession'],
      salary: jsonData['salary'],
      distance: jsonData['distance'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "photo": photo,
        "location": location,
        "profession": profession,
        "salary": salary,
        "distance": distance,
      };

  static Map<String, dynamic> toMap(ProfileData data) => {
        'name': data.name,
        'description': data.description,
        'photo': data.photo,
        'location': data.location,
        'profession': data.profession,
        'salary': data.salary,
        'distance': data.distance,
      };

  static String encode(List<ProfileData> profileDataList) => json.encode(
        profileDataList
            .map<Map<String, dynamic>>((data) => ProfileData.toMap(data))
            .toList(),
        toEncodable: (profileDataList) => profileDataList,
      );

  static List<ProfileData> decode(String savedProfileString) =>
      (json.decode(savedProfileString) as List<dynamic>)
          .map<ProfileData>((item) => ProfileData.fromJson(item))
          .toList();
}
