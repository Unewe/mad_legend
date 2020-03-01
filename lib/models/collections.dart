import 'package:flame/sprite.dart';
import 'package:mad_legend/services/game_logic.dart';

class Cards {
  int id;
  String name;
  double chance;
  int dmgLow;
  int dmgHigh;
  Features feature;
  Cost costType;
  int costCount;
  Sprite img;

  String getShortDescription(Player player) {
    switch (feature) {
      case Features.meleeDefault:
        double dmgLowTmp = this.dmgLow.toDouble();
        double dmgHighTmp = this.dmgHigh.toDouble();
        if (player.getImprovements().isNotEmpty) {
          for (Cards improvement in player.getImprovements()) {
            dmgHighTmp += dmgHighTmp * improvement.chance;
            dmgLowTmp += dmgLowTmp * improvement.chance;
          }
        }
        return "${(dmgLowTmp).floor()}-${(dmgHighTmp).floor()}";
      case Features.rangedDefault:
        double dmgLowTmp = this.dmgLow.toDouble();
        if (player.getImprovements().isNotEmpty) {
          for (Cards improvement in player.getImprovements()) {
            dmgLowTmp += dmgLowTmp * improvement.chance;
          }
        }
        return "${(this.chance * 100).floor()}% ${(dmgLowTmp).floor()}";
      case Features.shieldDefault:
        double dmgLowTmp = this.dmgLow.toDouble();
//        if(player.getImprovements().isNotEmpty) {
//          for(Cards improvement in player.getImprovements()) {
//            dmgLowTmp += dmgLowTmp * improvement.chance;
//          }
//        }
        return "+${(dmgLowTmp).floor()}";
      case Features.prepareDefault:
        return "+1И+1К";
      case Features.curseDefault:
        return "2К";
      case Features.simpleCurse:
        return "-${this.costCount}HP";
      case Features.improvementDefault:
        return "+${(this.chance * 100).floor()}%";
      case Features.lastBreathDefault:
        return "${this.dmgHigh}*КП";
    }
    return "Рок это круто!!!";
  }

  String getDescription(Player player) {
    switch (feature) {
      case Features.meleeDefault:
        double dmgLowTmp = this.dmgLow.toDouble();
        double dmgHighTmp = this.dmgHigh.toDouble();
        if (player.getImprovements().isNotEmpty) {
          for (Cards improvement in player.getImprovements()) {
            dmgHighTmp += dmgHighTmp * improvement.chance;
            dmgLowTmp += dmgLowTmp * improvement.chance;
          }
        }
        return "Наносит ${(dmgLowTmp).floor()} - ${(dmgHighTmp).floor()} урона";
      case Features.rangedDefault:
        double dmgLowTmp = this.dmgLow.toDouble();
        if (player.getImprovements().isNotEmpty) {
          for (Cards improvement in player.getImprovements()) {
            dmgLowTmp += dmgLowTmp * improvement.chance;
          }
        }
        return "С верояьностью ${(this.chance * 100).floor()}% нанесет ${(dmgLowTmp).floor()} урона.";
      case Features.shieldDefault:
        double dmgLowTmp = this.dmgLow.toDouble();
        if (player.getImprovements().isNotEmpty) {
          for (Cards improvement in player.getImprovements()) {
            dmgLowTmp += dmgLowTmp * improvement.chance;
          }
        }
        return "Вы получите ${(dmgLowTmp).floor()} брони.";
      case Features.prepareDefault:
        return "Вы получите 1 очко инициативы, и 1 карту на выбор.";
      case Features.curseDefault:
        return "Добавляет 2 карты проклятия в колоду противника.";
      case Features.simpleCurse:
        return "Ненужный хлам. Просто выбросите и играйте дальше";
      case Features.improvementDefault:
        return "Ваша следующая атака улучшена на ${(this.chance * 100).floor()}%";
      case Features.lastBreathDefault:
        return "Наносит ${this.dmgHigh}, за каждое проклятие в колоде противника";
    }
    return "Рок это круто!!!";
  }

  Cards(this.id, this.name, this.chance, this.dmgLow, this.dmgHigh,
      this.feature, this.costType, this.costCount, this.img);

  static List<Cards> getDefaultCollection() {
    return List.of([
      defaultMeleeCard(),
      defaultMeleeCard(),
      defaultRangedCard(),
      defaultRangedCard(),
      defaultShieldCard(),
      defaultShieldCard(),
      defaultCurseCard(),
      defaultCurseCard(),
      defaultPrepareCard(),
      defaultImprovementCard()
    ]);
  }

  static Cards defaultMeleeCard() {
    return Cards(1, "Удар", 1, 4, 12, Features.meleeDefault, Cost.initiative, 2,
        Sprite('sword_default.png'));
  }

  static Cards defaultRangedCard() {
    return Cards(2, "Выстрел", 0.7, 10, 10, Features.rangedDefault,
        Cost.initiative, 2, Sprite('arrow_default.png'));
  }

  static Cards defaultShieldCard() {
    return Cards(3, "Щит", 1, 5, 5, Features.shieldDefault, Cost.initiative, 1,
        Sprite('shield_default.png'));
  }

  static Cards defaultPrepareCard() {
    return Cards(4, "Подготовка", 1, 1, 1, Features.prepareDefault, Cost.noCost,
        0, Sprite('prepare_default.png'));
  }

  static Cards defaultCurseCard() {
    return Cards(5, "Проклятие", 1, 3, 3, Features.curseDefault,
        Cost.initiative, 1, Sprite('curse_default.png'));
  }

  static Cards simpleCurse() {
    return Cards(6, "Мусор", 1, 1, 1, Features.simpleCurse, Cost.health, 2,
        Sprite('garbage_default.png'));
  }

  static Cards defaultImprovementCard() {
    return Cards(7, "Улучшение", 0.5, 1, 1, Features.improvementDefault,
        Cost.initiative, 1, Sprite('improvement_default.png'));
  }

  static Cards defaultLastBreathCard() {
    return Cards(8, "Последний вздох", 1, 2, 2, Features.improvementDefault,
        Cost.noCost, 0, Sprite('improvement_default.png'));
  }

  @override
  String toString() {
    return 'Cards{name: $name}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cards && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum Features {
  meleeDefault,
  rangedDefault,
  shieldDefault,
  prepareDefault,

  ///Проклятие.
  curseDefault,
  simpleCurse,

  ///Улучшение.
  improvementDefault,
  lastBreathDefault
}

enum Cost { initiative, health, noCost }
