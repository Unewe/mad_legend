import 'package:mad_legend/game_logic.dart';

class Cards {
  int id;
  String name;
  double chance;
  int dmgLow;
  int dmgHigh;
  Features feature;
  Cost costType;
  int costCount;

  String getDescription(Player player) {
    switch (feature) {
      case Features.meleeDefault:
        double dmgLowTmp = this.dmgLow.toDouble();
        double dmgHighTmp = this.dmgHigh.toDouble();
        if(player.getImprovements().isNotEmpty) {
          for(Cards improvement in player.getImprovements()) {
            dmgHighTmp +=  dmgHighTmp * improvement.chance;
            dmgLowTmp += dmgLowTmp * improvement.chance;
          }
        }
        return "Наносит ${(dmgLowTmp).floor()} - ${(dmgHighTmp).floor()} урона";
      case Features.rangedDefault:
        double dmgLowTmp = this.dmgLow.toDouble();
        if(player.getImprovements().isNotEmpty) {
          for(Cards improvement in player.getImprovements()) {
            dmgLowTmp += dmgLowTmp * improvement.chance;
          }
        }
        return "С верояьностью ${(this.chance * 100).floor()}% нанесет ${(dmgLowTmp).floor()} урона.";
      case Features.shieldDefault:
        //Может и щит улучшить
        return "Вы получите ${(this.dmgLow).floor()} брони.";
      case Features.prepareDefault:
        return "Вы получите 1 очко инициативы, и 1 карту на выбор.";
      case Features.curseDefault:
        return "Добавляет 2 карты проклятия в колоду противника.";
      case Features.simpleCurse:
        return "Жалкое проклятие. Просто выбросите и играйте дальше";
      case Features.improvementDefault:
        return "Ваша следующая атака улучшена на ${(this.chance * 100).floor()}%";
      case Features.lastBreathDefault:
        return "Наносит ${this.dmgHigh}, за каждое проклятие в колоде противника";
    }
  }

  Cards(this.id, this.name, this.chance, this.dmgLow,
      this.dmgHigh, this.feature, this.costType, this.costCount);

  static List<Cards> getDefaultCollection() {
    return List.of([
      defaultMeleeCard(), defaultMeleeCard(),
      defaultRangedCard(), defaultRangedCard(),
      defaultShieldCard(), defaultShieldCard(),
      defaultCurseCard(), defaultCurseCard(),
      defaultPrepareCard(), defaultImprovementCard()
    ]);
  }

  static Cards defaultMeleeCard() {
    return Cards(1, "Удар", 1, 2, 12, Features.meleeDefault, Cost.initiative, 1);
  }

  static Cards defaultRangedCard() {
    return Cards(2, "Выстрел", 0.7, 10, 10, Features.rangedDefault, Cost.initiative, 1);
  }

  static Cards defaultShieldCard() {
    return Cards(3, "Щит", 1, 8, 12, Features.shieldDefault, Cost.initiative, 1);
  }

  static Cards defaultPrepareCard() {
    return Cards(4, "Подготовка", 1, 1, 1, Features.prepareDefault, Cost.noCost, 0);
  }

  static Cards defaultCurseCard() {
    return Cards(5, "Проклятие", 1, 1, 1, Features.curseDefault, Cost.health, 3);
  }

  static Cards simpleCurse() {
    return Cards(5, "Простое проклятие", 1, 1, 1, Features.simpleCurse, Cost.noCost, 0);
  }

  static Cards defaultImprovementCard() {
    return Cards(6, "Улучшение", 0.5, 1, 1, Features.improvementDefault, Cost.health, 3);
  }

  static Cards defaultLastBreathCard() {
    return Cards(7, "Последний вздох", 1, 2, 2, Features.improvementDefault, Cost.noCost, 0);
  }

  @override
  String toString() {
    return 'Cards{name: $name}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Cards &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;


}

enum Features {
  meleeDefault,
  rangedDefault,
  shieldDefault,
  prepareDefault,
  //Проклятие.
  curseDefault,
  simpleCurse,
  //Улучшение.
  improvementDefault,
  lastBreathDefault
}

enum Cost {
  initiative,
  health,
  noCost
}