import 'dart:convert';

import 'package:demo_app/api_service.dart';
import 'package:demo_app/bloc/home_event.dart';
import 'package:demo_app/bloc/home_state.dart';
import 'package:demo_app/model/profile_info.dart';
import 'package:demo_app/shared_prefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<ProfileData> encodedList = [];
  final ApiService apiService;

  HomeBloc(this.apiService) : super(InitState()) {
    _handleEvents();
  }

  _handleEvents() {
    on<SavedProfileEvent>(savedProfileMethod);
    on<RemoveProfileEvent>(removeProfileMethod);
    on<ReturnSavedProfile>(returnSavedProfileMethod);
  }

  Future<void> returnSavedProfileMethod(
      ReturnSavedProfile event, Emitter<HomeState> emit) async {
    List<ProfileData> savedProfileList =
        ProfileData.decode(PrefsHelper().savedProfile);
    emit(ReturnSavedProfileState(savedProfileList));
  }

  Future<void> savedProfileMethod(
      SavedProfileEvent event, Emitter<HomeState> emit) async {
    if (PrefsHelper().savedProfile != "") {
      encodedList = ProfileData.decode(PrefsHelper().savedProfile);
    }

    // print(
    //   "name: ${event.name}, \ndescription: ${event.description},\nlocation: ${event.location} \nprofession: ${event.profession}, \nsalary: ${event.salary}, \ndistance: ${event.distance}, \nphoto: ${event.photo}",
    // );

    if (event.name != null) {
      encodedList.insert(
        0,
        ProfileData(
          name: event.name,
          description: "SUP", // event.description,
          location: event.location,
          profession: event.profession,
          salary: event.salary.toString(),
          distance: event.distance.toString(),
          photo: event.photo,
        ),
      );

      PrefsHelper().savedProfile = ProfileData.encode(encodedList);

      List<ProfileData> savedProfileList =
          ProfileData.decode(PrefsHelper().savedProfile);

      emit(SavedProfileState(savedProfileList));
    }
  }

  Future<void> removeProfileMethod(
      RemoveProfileEvent event, Emitter<HomeState> emit) async {
    print("INNER REMOVE STATE");
    emit(RemoveProfileState());
  }
}
