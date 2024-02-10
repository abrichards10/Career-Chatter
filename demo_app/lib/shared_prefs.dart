// Load and obtain the shared preferences for this app.
import 'package:demo_app/prefs.dart';
import 'package:demo_app/prefs_keys.dart';

class PrefsHelper {
  static final PrefsHelper _helper = PrefsHelper._internal();

  factory PrefsHelper() {
    return _helper;
  }

  PrefsHelper._internal();

  String get name => Prefs.getString(PrefKeys.kname) ?? "";
  String get photo => Prefs.getString(PrefKeys.kphoto) ?? "";

  // String get description => Prefs.getString(PrefKeys.description) ?? "";
  String get profession =>
      Prefs.getString(PrefKeys.kprofession) ?? "Software Engineer";
  int get salary => Prefs.getInt(PrefKeys.ksalary) ?? 50000;
  String get location => Prefs.getString(PrefKeys.klocation) ?? "San Francisco";
  int get distance => Prefs.getInt(PrefKeys.kdistance) ?? 10;

  String get savedProfile =>
      Prefs.getString(PrefKeys.ksavedProfile) ?? ""; // SAVED PROFILE

  set name(String value) => Prefs.setString(PrefKeys.kname, value);
  set photo(String value) => Prefs.setString(PrefKeys.kphoto, value);

  // set description(String value) => Prefs.setString(PrefKeys.description, value);
  set profession(String value) => Prefs.setString(PrefKeys.kprofession, value);
  set salary(int value) => Prefs.setInt(PrefKeys.ksalary, value);
  set location(String value) => Prefs.setString(PrefKeys.klocation, value);
  set distance(int value) => Prefs.setInt(PrefKeys.kdistance, value);

  set savedProfile(String value) {
    Prefs.setString(PrefKeys.ksavedProfile, value);
  }
}
