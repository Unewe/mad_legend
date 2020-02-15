import 'package:mad_legend/services/game_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';

getProgress() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int counter = (prefs.getInt('counter') ?? 0) + 1;
  await prefs.setInt('counter', counter);
}