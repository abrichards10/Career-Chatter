class ProfileData {
  String? name;
  String? description;
  String? photo;
  String? location;
  String? profession;
  String? salary;

  ProfileData({
    this.name,
    this.description,
    this.photo,
    this.location,
    this.profession,
    this.salary,
  });

  factory ProfileData.fromJson(Map<String, dynamic> parsedJson) {
    return ProfileData(
      name: parsedJson['name'] ?? "No Name",
      description: parsedJson['description'] ?? "No Description",
      photo: parsedJson['name'] ?? "Mohammed",
      location: parsedJson['name'] ?? "Mohammed",
      profession: parsedJson['name'] ?? "Mohammed",
      salary: parsedJson['name'] ?? "Mohammed",
    );
  }
}
