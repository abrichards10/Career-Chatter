import 'package:demo_app/model/profile_info.dart';

abstract class HomeState {}

class InitState extends HomeState {}

class SavedProfileState extends HomeState {
  List<ProfileData> data;
  SavedProfileState(this.data);
}

class RemoveProfileState extends HomeState {
  RemoveProfileState();
}

class ReturnSavedProfileState extends HomeState {
  List<ProfileData> data;
  ReturnSavedProfileState(this.data);
}
