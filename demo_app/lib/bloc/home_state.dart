import 'package:demo_app/model/profile_info.dart';

abstract class HomeState {}

class InitState extends HomeState {}

class SavedProfileState extends HomeState {
  List<ProfileData> data;
  SavedProfileState(this.data);
}
