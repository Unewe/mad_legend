import 'package:mad_legend/services/player-logic.dart';
import 'package:shared_preferences/shared_preferences.dart';

const gameTitle = "MadLegends";
const pName = "${gameTitle}PlayerName";
const pClass = "${gameTitle}PlayerClass";

Future<Player> getPlayer() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String playerName = prefs.getString(pName);
  String playerClassString = prefs.getString(pClass);

  PlayerClass playerClass;

  for(PlayerClass value in PlayerClass.values) {
    if(value.toString() == playerClassString) {
      playerClass = value;
      break;
    }
  }

  Player player;

  if(playerName == null || playerClass == null) {
    player = Player("Default", PlayerClass.DEFAULT);
    savePlayerName(player.name);
    savePlayerClass(player.playerClass);
  } else {
    player = Player(playerName, playerClass);
  }
  return player;
}

Future<String> getPlayerName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(pName);
}

Future<bool> savePlayerName(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(pName, name);
}

Future<bool> savePlayerClass(PlayerClass playerClass) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(pClass, playerClass.toString());
}