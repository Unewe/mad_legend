class GameContext {
  static final GameContext _instance = GameContext._internal();
  factory GameContext() => _instance;

  GameContext._internal() {
// init things inside this
  }
}
