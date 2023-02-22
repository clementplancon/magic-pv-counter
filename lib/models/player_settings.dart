import 'package:json_annotation/json_annotation.dart';

part 'player_settings.g.dart';

class PlayerSettings {
  late bool isNightDayCounter;
  late int isNonOrDayOrNight;
  late bool isPoisonCounter;
  late int nbPoisonCounter;
  late bool isInitiativeCounter;
  late bool hasInitiative;
  late bool isManaPool;
  late int nbGreen;
  late int nbBlue;
  late int nbRed;
  late int nbBlack;
  late int nbWhite;
  late int nbNoColor;

  PlayerSettings(
      this.isNightDayCounter,
      this.isNonOrDayOrNight,
      this.isPoisonCounter,
      this.nbPoisonCounter,
      this.isInitiativeCounter,
      this.hasInitiative,
      this.isManaPool,
      this.nbGreen,
      this.nbBlue,
      this.nbRed,
      this.nbBlack,
      this.nbWhite,
      this.nbNoColor);

  factory PlayerSettings.fromJson(Map<String, dynamic> json) =>
      _$PlayerSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerSettingsToJson(this);
}
