abstract class HomeEvent {}

class SavedProfileEvent extends HomeEvent {
  final String name;
  final String photo;
  final String description;
  final String profession;
  final String location;
  final int salary;
  final int distance;

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

class RemoveProfileEvent extends HomeEvent {}

class ReturnSavedProfile extends HomeEvent {}

class AddRatingEvent extends HomeEvent {
  final String? name;
  final double rating;

  AddRatingEvent(
    this.rating,
    this.name,
  );
}
