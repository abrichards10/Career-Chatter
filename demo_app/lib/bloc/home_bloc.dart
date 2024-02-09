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
  }

  Future<void> savedProfileMethod(
      SavedProfileEvent event, Emitter<HomeState> emit) async {
    if (PrefsHelper().savedProfile != "") {
      encodedList = ProfileData.decode(PrefsHelper().savedProfile);
    }

    print(
      "name: ${event.name}, \ndescription: ${event.description},\nphoto: ${event.photo},\nlocation: ${event.location} \nprofession: ${event.profession}, \nsalary: ${event.salary}, \ndistance: ${event.distance}",
    );

    encodedList.insert(
      0,
      ProfileData(
        name: event.name,
        description: event.description,
        photo: event.photo,
        location: event.location,
        profession: event.profession,
        salary: event.salary.toString(),
        distance: event.distance.toString(),
      ),
    );

    // print("Encoded AFTER: ${encodedList.first.name}");

    // PrefsHelper().savedProfile = ProfileData.encode(encodedList);

    // print("Encoded AFTER: ENCODE${PrefsHelper().savedProfile}");

    // List<ProfileData> savedProfileList =
    //     ProfileData.decode(PrefsHelper().savedProfile);

    // print("Saved profile list: $savedProfileList");

    emit(SavedProfileState(encodedList));
  }
}
