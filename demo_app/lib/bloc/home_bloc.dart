import 'dart:convert';

import 'package:demo_app/api_service.dart';
import 'package:demo_app/bloc/home_event.dart';
import 'package:demo_app/bloc/home_state.dart';
import 'package:demo_app/model/profile_info.dart';
import 'package:demo_app/prefs/shared_prefs.dart';
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
    on<AddRatingEvent>(addRatingToProfileMethod);
  }

  Future<void> addRatingToProfileMethod(
      AddRatingEvent event, Emitter<HomeState> emit) async {
    encodedList = ProfileData.decode(PrefsHelper().savedProfile);

    for (int i = 0; i < encodedList.length; i++) {
      print('SEARCHING>>>');
      print(encodedList[i].name);
      if (event.name == encodedList[i].name) {
        print("ADDDING RATING: ${event.rating} to ${encodedList[i].name}");
        encodedList[i].rating = event.rating;
      }
    }
    emit(AddRatingState(encodedList));
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

    if (event.name != null) {
      encodedList.insert(
        0,
        ProfileData(
          name: event.name,
          description: event.description,
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
