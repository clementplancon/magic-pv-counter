part of 'player_settings.dart';

PlayerSettings _$PlayerSettingsFromJson(Map<String, dynamic> json) =>
    PlayerSettings(
      json['isNightDayCounter'] as bool,
      json['isNonOrDayOrNight'] as int,
      json['isPoisonCounter'] as bool,
      json['nbPoisonCounter'] as int,
      json['isInitiativeCounter'] as bool,
      json['hasInitiative'] as bool,
      json['isManaPool'] as bool,
      json['nbGreen'] as int,
      json['nbBlue'] as int,
      json['nbRed'] as int,
      json['nbBlack'] as int,
      json['nbWhite'] as int,
      json['nbNoColor'] as int,
    );

Map<String, dynamic> _$PlayerSettingsToJson(PlayerSettings instance) =>
    <String, dynamic>{
      'isNightDayCounter': instance.isNightDayCounter,
      'isNonOrDayOrNight': instance.isNonOrDayOrNight,
      'isPoisonCounter': instance.isPoisonCounter,
      'nbPoisonCounter': instance.nbPoisonCounter,
      'isInitiativeCounter': instance.isInitiativeCounter,
      'hasInitiative': instance.hasInitiative,
      'isManaPool': instance.isManaPool,
      'nbGreen': instance.nbGreen,
      'nbBlue': instance.nbBlue,
      'nbRed': instance.nbRed,
      'nbBlack': instance.nbBlack,
      'nbWhite': instance.nbWhite,
      'nbNoColor': instance.nbNoColor,
    };
