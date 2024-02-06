abstract class HomeEvent {}

class SavedProfileEvent extends HomeEvent {
  final String name;
  final String photo;
  final String description;
  final String profession;
  final String location;
  final String salary;
  final String distance;

  SavedProfileEvent(
    this.name,
    this.photo,
    this.description,
    this.profession,
    this.location,
    this.salary,
    this.distance,
  );
}
