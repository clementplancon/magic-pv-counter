import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:magic_app_counter/models/player_settings.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:wakelock/wakelock.dart';

import 'components/dice_face.dart';
import 'components/player_zone.dart';
import 'components/settings_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 200));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  await Future.delayed(const Duration(milliseconds: 200));
  Wakelock.enable();
  SharedPreferences.getInstance().then((prefs) {
    runApp(MyApp(prefs: prefs));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.prefs}) : super(key: key);

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    sleep(const Duration(seconds: 1));
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      sleep(const Duration(seconds: 1));
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      return MaterialApp(
        title: 'Magix Life Total',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.black45),
        home: MyHomePage(prefs: prefs),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.prefs}) : super(key: key);

  final SharedPreferences prefs;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final SharedPreferences prefs;

  int _playerNumber = 2;

  int _counterPlayer1 = 20;
  int _counterPlayer2 = 20;
  int _counterPlayer3 = 20;
  int _counterPlayer4 = 20;

  int _totalLifeSettings = 20;

  int _colorIndexPlayer1 = 0;
  int _colorIndexPlayer2 = 0;
  int _colorIndexPlayer3 = 0;
  int _colorIndexPlayer4 = 0;

  PlayerSettings settingsP1 =
      PlayerSettings(false, 0, false, 0, false, false, false, 0, 0, 0, 0, 0, 0);
  PlayerSettings settingsP2 =
      PlayerSettings(false, 0, false, 0, false, false, false, 0, 0, 0, 0, 0, 0);
  PlayerSettings settingsP3 =
      PlayerSettings(false, 0, false, 0, false, false, false, 0, 0, 0, 0, 0, 0);
  PlayerSettings settingsP4 =
      PlayerSettings(false, 0, false, 0, false, false, false, 0, 0, 0, 0, 0, 0);

  // IconData twoPlayersDispo = Icons.view_agenda_sharp;
  // IconData threePlayersDispo = Icons.space_dashboard_sharp;
  // IconData fourPlayersDispo = Icons.grid_view_sharp;

  bool isDiceLaunch = false;
  int _diceResultPlayer1 = 0;
  int _diceResultPlayer2 = 0;
  int _diceResultPlayer3 = 0;
  int _diceResultPlayer4 = 0;
  bool _diceWinnerPlayer1 = false;
  bool _diceWinnerPlayer2 = false;
  bool _diceWinnerPlayer3 = false;
  bool _diceWinnerPlayer4 = false;
  int selectedDiceOption = 20;

  @override
  void initState() {
    prefs = widget.prefs;

    // Load P1 Life from shared preferences
    int? lifeP1 = prefs.getInt('_counterPlayer1');
    if (lifeP1 != null) {
      _counterPlayer1 = lifeP1;
    }

    // Load P2 Life from shared preferences
    int? lifeP2 = prefs.getInt('_counterPlayer2');
    if (lifeP2 != null) {
      _counterPlayer2 = lifeP2;
    }

    // Load P3 Life from shared preferences
    int? lifeP3 = prefs.getInt('_counterPlayer3');
    if (lifeP3 != null) {
      _counterPlayer3 = lifeP3;
    }

    // Load P4 Life from shared preferences
    int? lifeP4 = prefs.getInt('_counterPlayer4');
    if (lifeP4 != null) {
      _counterPlayer4 = lifeP4;
    }

    int? playerNumber = prefs.getInt('_playerNumber');
    if (playerNumber != null) {
      _playerNumber = playerNumber;
    }

    // Load Max Start Life Settings
    int? maxStartLife = prefs.getInt('_totalLifeSettings');
    if (maxStartLife != null) {
      _totalLifeSettings = maxStartLife;
    }

    // Load P1 Color from shared preferencess
    int? colorP1 = prefs.getInt('_colorIndexPlayer1');
    if (colorP1 != null) {
      _colorIndexPlayer1 = colorP1;
    }

    // Load P2 Color from shared preferences
    int? colorP2 = prefs.getInt('_colorIndexPlayer2');
    if (colorP2 != null) {
      _colorIndexPlayer2 = colorP2;
    }

    // Load P3 Color from shared preferencess
    int? colorP3 = prefs.getInt('_colorIndexPlayer3');
    if (colorP3 != null) {
      _colorIndexPlayer3 = colorP3;
    }

    // Load P4 Color from shared preferences
    int? colorP4 = prefs.getInt('_colorIndexPlayer4');
    if (colorP4 != null) {
      _colorIndexPlayer4 = colorP4;
    }

    // Load P1 Settings from shared preferencess
    String? serializedSettings1 = prefs.getString('settingsP1');
    if (serializedSettings1 != null) {
      settingsP1 = PlayerSettings.fromJson(jsonDecode(serializedSettings1));
    }

    // Load P2 Setting from shared preferences
    String? serializedSettings2 = prefs.getString('settingsP2');
    if (serializedSettings2 != null) {
      settingsP2 = PlayerSettings.fromJson(jsonDecode(serializedSettings2));
    }

    // Load P3 Settings from shared preferencess
    String? serializedSettings3 = prefs.getString('settingsP3');
    if (serializedSettings3 != null) {
      settingsP3 = PlayerSettings.fromJson(jsonDecode(serializedSettings3));
    }

    // Load P4 Setting from shared preferences
    String? serializedSettings4 = prefs.getString('settingsP4');
    if (serializedSettings4 != null) {
      settingsP4 = PlayerSettings.fromJson(jsonDecode(serializedSettings4));
    }

    super.initState();
  }

  void _setCounter1(int val) {
    _counterPlayer1 = val;
    prefs.setInt('_counterPlayer1', _counterPlayer1);
  }

  void _setCounter2(int val) {
    _counterPlayer2 = val;
    prefs.setInt('_counterPlayer2', _counterPlayer2);
  }

  void _setCounter3(int val) {
    _counterPlayer3 = val;
    prefs.setInt('_counterPlayer3', _counterPlayer3);
  }

  void _setCounter4(int val) {
    _counterPlayer4 = val;
    prefs.setInt('_counterPlayer4', _counterPlayer4);
  }

  Future<void> _launchDice() async {
    // Define a list of integer options
    List<int> options = [2, 3, 4, 6, 10, 20, 100];
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        List<Widget> optionWidgets = options.map((int option) {
          return TextButton(
            child: Text("D$option"),
            onPressed: () {
              // Update the selected option when the user makes a choice
              setState(() {
                selectedDiceOption = option;
              });
              Navigator.of(context).pop();
            },
          );
        }).toList();

        // Return the dialog widget
        return AlertDialog(
          title: Text('Choose a dice option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: optionWidgets,
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
              setState(() {
                selectedDiceOption = 0;
              });
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
    if (selectedDiceOption == 0) {
      return;
    }
    setState(() {
      isDiceLaunch = true;
    });
    for (var i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _diceResultPlayer1 = Random().nextInt(selectedDiceOption) + 1;
        _diceResultPlayer2 = Random().nextInt(selectedDiceOption) + 1;
        if (_playerNumber > 2) {
          _diceResultPlayer3 = Random().nextInt(selectedDiceOption) + 1;
        }
        if (_playerNumber > 3) {
          _diceResultPlayer4 = Random().nextInt(selectedDiceOption) + 1;
        }
      });
      if (i == 9) {
        if (_diceResultPlayer1 > _diceResultPlayer2 &&
            _diceResultPlayer1 > _diceResultPlayer3 &&
            _diceResultPlayer1 > _diceResultPlayer4) _diceWinnerPlayer1 = true;
        if (_diceResultPlayer2 > _diceResultPlayer1 &&
            _diceResultPlayer2 > _diceResultPlayer3 &&
            _diceResultPlayer2 > _diceResultPlayer4) _diceWinnerPlayer2 = true;
        if (_diceResultPlayer3 > _diceResultPlayer1 &&
            _diceResultPlayer3 > _diceResultPlayer2 &&
            _diceResultPlayer3 > _diceResultPlayer4) _diceWinnerPlayer3 = true;
        if (_diceResultPlayer4 > _diceResultPlayer1 &&
            _diceResultPlayer4 > _diceResultPlayer2 &&
            _diceResultPlayer4 > _diceResultPlayer3) _diceWinnerPlayer4 = true;
      }
    }
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
      isDiceLaunch = false;
      _diceWinnerPlayer1 = false;
      _diceWinnerPlayer2 = false;
      _diceWinnerPlayer3 = false;
      _diceWinnerPlayer4 = false;
    });
  }

  _setTotalLife(int totalLife) {
    setState(() {
      _counterPlayer1 = totalLife;
      _counterPlayer2 = totalLife;
      _counterPlayer3 = totalLife;
      _counterPlayer4 = totalLife;
      _totalLifeSettings = totalLife;
      prefs.setInt('_totalLifeSettings', _totalLifeSettings);
    });
  }

  _resetLife() {
    setState(() {
      _counterPlayer1 = _totalLifeSettings;
      _counterPlayer2 = _totalLifeSettings;
      _counterPlayer3 = _totalLifeSettings;
      _counterPlayer4 = _totalLifeSettings;
      _totalLifeSettings = _totalLifeSettings;
    });
  }

  _changePlayerColor1(int playerColor1) {
    _colorIndexPlayer1 = playerColor1;
    prefs.setInt('_colorIndexPlayer1', _colorIndexPlayer1);
  }

  _changePlayerColor2(int playerColor2) {
    _colorIndexPlayer2 = playerColor2;
    prefs.setInt('_colorIndexPlayer2', _colorIndexPlayer2);
  }

  _changePlayerColor3(int playerColor3) {
    _colorIndexPlayer3 = playerColor3;
    prefs.setInt('_colorIndexPlayer3', _colorIndexPlayer3);
  }

  _changePlayerColor4(int playerColor4) {
    _colorIndexPlayer4 = playerColor4;
    prefs.setInt('_colorIndexPlayer4', _colorIndexPlayer4);
  }

  _changerPlayer1Settings(PlayerSettings p1) {
    settingsP1 = p1;
    prefs.setString('settingsP1', jsonEncode(p1.toJson()));
  }

  _changerPlayer2Settings(PlayerSettings p2) {
    settingsP2 = p2;
    prefs.setString('settingsP2', jsonEncode(p2.toJson()));
  }

  _changerPlayer3Settings(PlayerSettings p3) {
    settingsP3 = p3;
    prefs.setString('settingsP3', jsonEncode(p3.toJson()));
  }

  _changerPlayer4Settings(PlayerSettings p4) {
    settingsP4 = p4;
    prefs.setString('settingsP4', jsonEncode(p4.toJson()));
  }

  _changePlayerNumber(int playerNumber) {
    setState(() {
      _playerNumber = playerNumber;
      prefs.setInt('_playerNumber', _playerNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _playerNumber > 2
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RotatedBox(
                          quarterTurns: 1,
                          child: isDiceLaunch
                              ? DiceFace(
                                  number: _diceResultPlayer1,
                                  isWinner: _diceWinnerPlayer1,
                                  isDoubleView: true,
                                  key: UniqueKey(),
                                )
                              : PlayerZone(
                                  backColor: _colorIndexPlayer1,
                                  changePlayerLife: (val) => _setCounter1(val),
                                  changePlayerSettings: (val) =>
                                      _changerPlayer1Settings(val),
                                  pSettings: settingsP1,
                                  lifeCount: _counterPlayer1,
                                  changePlayerColor: (val1) =>
                                      _changePlayerColor1(val1),
                                  prefs: prefs,
                                  isDoubleView: true,
                                  key: UniqueKey(),
                                )),
                      RotatedBox(
                          quarterTurns: 3,
                          child: isDiceLaunch
                              ? DiceFace(
                                  number: _diceResultPlayer3,
                                  isWinner: _diceWinnerPlayer3,
                                  isDoubleView: true,
                                  key: UniqueKey(),
                                )
                              : PlayerZone(
                                  backColor: _colorIndexPlayer3,
                                  changePlayerLife: (val) => _setCounter3(val),
                                  changePlayerSettings: (val) =>
                                      _changerPlayer3Settings(val),
                                  pSettings: settingsP3,
                                  lifeCount: _counterPlayer3,
                                  changePlayerColor: (val3) =>
                                      _changePlayerColor3(val3),
                                  prefs: prefs,
                                  isDoubleView: true,
                                  key: UniqueKey(),
                                )),
                    ],
                  )
                : RotatedBox(
                    quarterTurns: 2,
                    child: isDiceLaunch
                        ? DiceFace(
                            number: _diceResultPlayer1,
                            isWinner: _diceWinnerPlayer1,
                            isDoubleView: false,
                            key: UniqueKey(),
                          )
                        : PlayerZone(
                            backColor: _colorIndexPlayer1,
                            changePlayerLife: (val) => _setCounter1(val),
                            changePlayerSettings: (val) =>
                                _changerPlayer1Settings(val),
                            pSettings: settingsP1,
                            lifeCount: _counterPlayer1,
                            changePlayerColor: (val1) =>
                                _changePlayerColor1(val1),
                            prefs: prefs,
                            isDoubleView: false,
                            key: UniqueKey(),
                          )),
            SettingsBar(
              diceFunc: _launchDice,
              lifeFunc: (value) => _setTotalLife(value),
              resetFunc: _resetLife,
              playerFunc: (value) => _changePlayerNumber(value),
            ),
            _playerNumber > 3
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RotatedBox(
                          quarterTurns: 1,
                          child: isDiceLaunch
                              ? DiceFace(
                                  number: _diceResultPlayer2,
                                  isWinner: _diceWinnerPlayer2,
                                  isDoubleView: true,
                                  key: UniqueKey(),
                                )
                              : PlayerZone(
                                  backColor: _colorIndexPlayer2,
                                  changePlayerLife: (val) => _setCounter2(val),
                                  changePlayerSettings: (val) =>
                                      _changerPlayer2Settings(val),
                                  pSettings: settingsP2,
                                  lifeCount: _counterPlayer2,
                                  changePlayerColor: (val2) =>
                                      _changePlayerColor1(val2),
                                  prefs: prefs,
                                  isDoubleView: true,
                                  key: UniqueKey(),
                                )),
                      RotatedBox(
                          quarterTurns: 3,
                          child: isDiceLaunch
                              ? DiceFace(
                                  number: _diceResultPlayer4,
                                  isWinner: _diceWinnerPlayer4,
                                  isDoubleView: true,
                                  key: UniqueKey(),
                                )
                              : PlayerZone(
                                  backColor: _colorIndexPlayer4,
                                  changePlayerLife: (val) => _setCounter4(val),
                                  changePlayerSettings: (val) =>
                                      _changerPlayer4Settings(val),
                                  pSettings: settingsP4,
                                  lifeCount: _counterPlayer4,
                                  changePlayerColor: (val4) =>
                                      _changePlayerColor4(val4),
                                  prefs: prefs,
                                  isDoubleView: true,
                                  key: UniqueKey(),
                                )),
                    ],
                  )
                : isDiceLaunch
                    ? DiceFace(
                        number: _diceResultPlayer2,
                        isWinner: _diceWinnerPlayer2,
                        isDoubleView: false,
                        key: UniqueKey(),
                      )
                    : PlayerZone(
                        backColor: _colorIndexPlayer2,
                        changePlayerLife: (val) => _setCounter2(val),
                        changePlayerSettings: (val) =>
                            _changerPlayer2Settings(val),
                        pSettings: settingsP2,
                        lifeCount: _counterPlayer2,
                        changePlayerColor: (val2) => _changePlayerColor2(val2),
                        prefs: prefs,
                        isDoubleView: false,
                        key: UniqueKey(),
                      ),
          ],
        ),
      ),
    );
  }
}
