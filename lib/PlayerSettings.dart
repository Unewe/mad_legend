class Player {
  String name;
  PlayerType type;

  int gold;
  int wood;
  int steel;
  int herb;
}

enum PlayerType {
  defaultPlayer,
  knight,
  archer,
  wizard,
  tramp,
  thief
}