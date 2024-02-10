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
      print("TRIED TO DECODE");
      encodedList = ProfileData.decode(PrefsHelper().savedProfile);
    }

    print(
      "name: ${event.name}, \ndescription: ${event.description},\nlocation: ${event.location} \nprofession: ${event.profession}, \nsalary: ${event.salary}, \ndistance: ${event.distance}",
    );
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

      print("Encoded AFTER: ENCODE${PrefsHelper().savedProfile}");

      List<ProfileData> savedProfileList =
          ProfileData.decode(PrefsHelper().savedProfile);

      print("Saved profile list: ${savedProfileList.last.name}");
      print("Saved profile list: ${savedProfileList.last.distance}");
      print("Saved profile list: ${savedProfileList.last.salary}");

      print("Saved profile list: ${savedProfileList.first.name}");
      print("Saved profile list: ${savedProfileList.first.distance}");
      print("Saved profile list: ${savedProfileList.first.salary}");

      emit(SavedProfileState(encodedList));
    }
  }
}
