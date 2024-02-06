// Load and obtain the shared preferences for this app.
import 'package:demo_app/prefs_keys.dart';
import 'package:prefs/prefs.dart';

class PrefsHelper {
  static final PrefsHelper _helper = PrefsHelper._internal();

  factory PrefsHelper() {
    return _helper;
  }

  PrefsHelper._internal();

  String get name => Prefs.getString(PrefKeys.name) ?? "";
  String get photo => Prefs.getString(PrefKeys.photo) ?? "";

  String get description => Prefs.getString(PrefKeys.description) ?? "";
  String get profession => Prefs.getString(PrefKeys.profession) ?? "";
  String get salary => Prefs.getString(PrefKeys.salary) ?? "";
  String get location => Prefs.getString(PrefKeys.location) ?? "";
  String get distance => Prefs.getString(PrefKeys.distance) ?? "";

  String get savedProfile =>
      Prefs.getString(PrefKeys.savedProfile) ?? ""; // SAVED PROFILE

  set name(String value) => Prefs.setString(PrefKeys.name, value);
  set photo(String value) => Prefs.setString(PrefKeys.photo, value);

  set description(String value) => Prefs.setString(PrefKeys.description, value);
  set profession(String value) => Prefs.setString(PrefKeys.profession, value);
  set salary(String value) => Prefs.setString(PrefKeys.salary, value);
  set location(String value) => Prefs.setString(PrefKeys.location, value);
  set distance(String value) => Prefs.setString(PrefKeys.distance, value);

  set savedProfile(String value) =>
      Prefs.setString(PrefKeys.savedProfile, value);
}
