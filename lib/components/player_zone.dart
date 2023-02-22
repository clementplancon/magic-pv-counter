import 'dart:async';

import 'package:flutter/material.dart';
import 'package:magic_app_counter/models/player_settings.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerZone extends StatefulWidget {
  const PlayerZone(
      {Key? key,
      required this.backColor,
      required this.changePlayerLife,
      required this.changePlayerSettings,
      required this.pSettings,
      required this.lifeCount,
      required this.changePlayerColor,
      required this.prefs,
      required this.isDoubleView})
      : super(key: key);

  final Function changePlayerLife;
  final Function changePlayerColor;
  final Function changePlayerSettings;
  final PlayerSettings pSettings;
  final int lifeCount;
  final int backColor;
  final SharedPreferences prefs;
  final bool isDoubleView;

  @override
  State<PlayerZone> createState() => _PlayerZoneState();
}

class _PlayerZoneState extends State<PlayerZone> {
  late final Function changePlayerLife;
  late final Function changePlayerColor;
  late final SharedPreferences prefs;
  late final Function changePlayerSettings;
  late final bool isDoubleView;

  late PlayerSettings pSettings;

  // Color Gesture params
  late int backColor;
  bool isColorPickerOnScreen = false;

  bool isMenuPlayerOnScreen = false;

  // Life Gesture Params
  late int lifeCount;
  late int lifeChangingCount = 0;
  bool decrementOnGoing = false;
  bool incrementOnGoing = false;
  int decrementDuration = 0;
  int incrementDuration = 0;
  late Timer changingCountTimer;

  // Night/Day Counter params
  bool isNightDayCounterActive = false;
  int nightDayCounterState = 0;

  // Poison counter params
  bool isPoisonCounterActive = false;
  IconData iconPoison = Icons.coronavirus_outlined;
  int poisonCount = 0;

  // Initiative counter params
  bool isInitiativeCounterActive = false;
  bool hasInit = false;

  // Manapool params
  bool isManaPoolActive = false;
  int greenCount = 0;
  int redCount = 0;
  int whiteCount = 0;
  int blackCount = 0;
  int blueCount = 0;
  int noColorCount = 0;

  List<Color> colors = [
    const Color.fromARGB(255, 0, 0, 0),
    const Color.fromARGB(255, 177, 154, 61),
    const Color.fromARGB(255, 137, 31, 23),
    const Color.fromARGB(255, 18, 69, 111),
    const Color.fromARGB(255, 11, 97, 14),
    const Color.fromARGB(255, 69, 69, 69)
  ];

  substract() async {
    setState(() {
      lifeCount--;
      changeCountState(-1);
      decrementDuration++;
    });
    if (decrementDuration >= 10) {
      await Future.delayed(const Duration(milliseconds: 50));
    } else {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (decrementOnGoing) {
      substract();
    }
  }

  addCounter() async {
    setState(() {
      lifeCount++;
      changeCountState(1);
      incrementDuration++;
    });
    if (incrementDuration >= 10) {
      await Future.delayed(const Duration(milliseconds: 50));
    } else {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (incrementOnGoing) {
      addCounter();
    }
  }

  changeBackColor(int index) {
    setState(() {
      backColor = index;
    });
    changePlayerColor(backColor);
  }

  displayColorPicker() {
    setState(() {
      isMenuPlayerOnScreen = false;
      isColorPickerOnScreen = !isColorPickerOnScreen;
    });
  }

  displayMenuPlayer() {
    setState(() {
      isColorPickerOnScreen = false;
      isMenuPlayerOnScreen = !isMenuPlayerOnScreen;
    });
  }

  changeCountState(int change) {
    changingCountTimer.cancel();
    setState(() {
      lifeChangingCount = lifeChangingCount + change;
    });
    changingCountTimer =
        Timer(const Duration(milliseconds: 1500), () => resetChangeState());
  }

  changeDayNightState() {
    if (nightDayCounterState == 1) {
      setState(() {
        nightDayCounterState = 2;
        pSettings.isNonOrDayOrNight = 2;
      });
      changePlayerSettings(pSettings);
    } else if (nightDayCounterState == 2 || nightDayCounterState == 0) {
      setState(() {
        nightDayCounterState = 1;
        pSettings.isNonOrDayOrNight = 1;
      });
      changePlayerSettings(pSettings);
    }
  }

  resetDayNightState() {
    setState(() {
      nightDayCounterState = 0;
      pSettings.isNonOrDayOrNight = 0;
    });
    changePlayerSettings(pSettings);
  }

  resetChangeState() {
    setState(() {
      lifeChangingCount = 0;
    });
  }

  changeInitState() {
    setState(() {
      hasInit = !hasInit;
      pSettings.hasInitiative = hasInit;
    });
    changePlayerSettings(pSettings);
  }

  substractPoisonCounterDown() {
    setState(() {
      poisonCount--;
      pSettings.nbPoisonCounter = poisonCount;
    });
    changePlayerSettings(pSettings);
  }

  addPoisonCounterDown() {
    setState(() {
      poisonCount++;
      pSettings.nbPoisonCounter = poisonCount;
    });
    changePlayerSettings(pSettings);
  }

  IconData getNightDayIconData() {
    if (nightDayCounterState == 1) {
      return Icons.light_mode_outlined;
    } else if (nightDayCounterState == 2) {
      return Icons.dark_mode_outlined;
    } else {
      return Icons.remove;
    }
  }

  IconData getInitIconData() {
    if (hasInit) {
      return Icons.offline_bolt;
    } else {
      return Icons.offline_bolt_outlined;
    }
  }

  @override
  void initState() {
    backColor = widget.backColor;
    changePlayerLife = widget.changePlayerLife;
    lifeCount = widget.lifeCount;
    changePlayerColor = widget.changePlayerColor;
    changePlayerSettings = widget.changePlayerSettings;
    pSettings = widget.pSettings;
    changingCountTimer =
        Timer(const Duration(milliseconds: 1500), () => resetChangeState());
    prefs = widget.prefs;
    isDoubleView = widget.isDoubleView;
    isNightDayCounterActive = pSettings.isNightDayCounter;
    nightDayCounterState = pSettings.isNonOrDayOrNight;
    isPoisonCounterActive = pSettings.isPoisonCounter;
    poisonCount = pSettings.nbPoisonCounter;
    isInitiativeCounterActive = pSettings.isInitiativeCounter;
    hasInit = pSettings.hasInitiative;
    isManaPoolActive = pSettings.isManaPool;
    greenCount = pSettings.nbGreen;
    blueCount = pSettings.nbBlue;
    redCount = pSettings.nbRed;
    blackCount = pSettings.nbBlack;
    whiteCount = pSettings.nbWhite;
    noColorCount = pSettings.nbNoColor;
    super.initState();
  }

  @override
  void dispose() {
    changingCountTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isDoubleView ? 50.w : 46.h,
      width: isDoubleView ? 46.h : 100.w,
      decoration: BoxDecoration(
          color: colors[backColor],
          border: Border.all(color: Colors.white, width: 0.5)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          isDoubleView
              ? Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => displayColorPicker(),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: isDoubleView ? 0.5.h : 1.h,
                            right: isDoubleView ? 1.h : 3.w),
                        child: Icon(
                          Icons.palette,
                          color: Colors.white,
                          size: isDoubleView ? 2.h : 2.5.h,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => displayMenuPlayer(),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: isDoubleView ? 0.5.h : 1.h,
                            left: isDoubleView ? 1.h : 3.w),
                        child: Icon(
                          Icons.reorder,
                          color: Colors.white,
                          size: isDoubleView ? 1.5.h : 2.5.h,
                        ),
                      ),
                    ),
                    isNightDayCounterActive
                        ? GestureDetector(
                            onTap: () => changeDayNightState(),
                            onLongPress: () => resetDayNightState(),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: isDoubleView ? 0.5.h : 1.h),
                              child: Icon(getNightDayIconData(),
                                  color: Colors.white,
                                  size: isDoubleView ? 1.8.h : 3.h),
                            ),
                          )
                        : Container(),
                    isInitiativeCounterActive
                        ? GestureDetector(
                            onTap: () => changeInitState(),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: isDoubleView ? 0.5.h : 1.h),
                              child: Icon(getInitIconData(),
                                  color: Colors.white,
                                  size: isDoubleView ? 1.8.h : 3.h),
                            ),
                          )
                        : Container(),
                    isPoisonCounterActive
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: isDoubleView ? 0.5.h : 1.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => substractPoisonCounterDown(),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: isDoubleView ? 0.5.w : 1.w),
                                    child: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  poisonCount.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isDoubleView ? 12 : 18),
                                ),
                                Icon(
                                  Icons.coronavirus,
                                  size: isDoubleView ? 1.8.h : 3.h,
                                  color: Colors.white,
                                ),
                                GestureDetector(
                                  onTap: () => addPoisonCounterDown(),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: isDoubleView ? 0.5.w : 1.w),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    GestureDetector(
                      onTap: () => displayColorPicker(),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: isDoubleView ? 0.5.h : 1.h,
                            right: isDoubleView ? 1.h : 3.w),
                        child: Icon(
                          Icons.palette,
                          color: Colors.white,
                          size: isDoubleView ? 1.5.h : 2.5.h,
                        ),
                      ),
                    ),
                  ],
                ),
          drawZone(),
          isDoubleView
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildGreenManaCounter(),
                    buildRedManaCounter(),
                    buildBlueManaCounter(),
                    buildBlackManaCounter(),
                    buildWhiteManaCounter(),
                    buildNoColorManaCounter(),
                  ],
                ), //MANAZONE
        ],
      ),
    );
  }

  Widget drawZone() {
    if (isMenuPlayerOnScreen) {
      return getPlayerMenu();
    } else if (isColorPickerOnScreen) {
      return getColorPicker();
    } else {
      return getLifeZone();
    }
  }

  Widget getLifeZone() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
              onTap: () {
                setState(() {
                  lifeCount--;
                  changeCountState(-1);
                  changePlayerLife(lifeCount);
                });
              },
              onLongPressStart: (details) {
                setState(() {
                  decrementOnGoing = true;
                });
                substract();
              },
              onLongPressEnd: (details) {
                setState(() {
                  decrementOnGoing = false;
                  decrementDuration = 0;
                  changePlayerLife(lifeCount);
                });
              },
              child: Container(
                  height: isDoubleView ? 25.w : 35.h,
                  width: isDoubleView ? 35.h : 25.w,
                  color: colors[backColor],
                  child: const Center(
                      child: Icon(Icons.remove, color: Colors.white)))),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: isDoubleView ? 5.w : 10.h,
              padding: EdgeInsets.only(bottom: isDoubleView ? 0.5.h : 1.h),
              child: Text(
                lifeChangingCount != 0
                    ? (lifeChangingCount > 0
                        ? "+$lifeChangingCount"
                        : lifeChangingCount.toString())
                    : '',
                style: TextStyle(
                    fontSize: isDoubleView ? 2.h : 4.h, color: Colors.white),
              ),
            ),
            Text(
              lifeCount.toString(),
              style: TextStyle(
                  fontSize: isDoubleView ? 4.h : 8.h, color: Colors.white),
            ),
            Container(
              height: isDoubleView ? 5.w : 10.h,
              padding: EdgeInsets.only(top: isDoubleView ? 0.5.h : 1.h),
            ),
          ],
        ),
        Expanded(
          child: GestureDetector(
              onTap: () {
                setState(() {
                  lifeCount++;
                  changeCountState(1);
                  changePlayerLife(lifeCount);
                });
              },
              onLongPressStart: (details) {
                setState(() {
                  incrementOnGoing = true;
                });
                addCounter();
              },
              onLongPressEnd: (details) {
                setState(() {
                  incrementOnGoing = false;
                  incrementDuration = 0;
                  changePlayerLife(lifeCount);
                });
              },
              child: Container(
                  height: isDoubleView ? 17.5.h : 35.h,
                  width: isDoubleView ? 35.h : 25.w,
                  color: colors[backColor],
                  child: const Center(
                      child: Icon(Icons.add, color: Colors.white)))),
        ),
      ],
    );
  }

  Widget getColorPicker() {
    return Center(
      child: Container(
        height: isDoubleView ? 15.w : 15.h,
        width: isDoubleView ? 70.w : 80.w,
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.white, width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                changeBackColor(0);
                displayColorPicker();
              },
              child: Container(
                height: isDoubleView ? 5.w : 10.w,
                width: isDoubleView ? 5.w : 10.w,
                decoration: BoxDecoration(
                    color: colors[0],
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white, width: 1)),
              ),
            ),
            GestureDetector(
              onTap: () {
                changeBackColor(1);
                displayColorPicker();
              },
              child: Container(
                height: isDoubleView ? 5.w : 10.w,
                width: isDoubleView ? 5.w : 10.w,
                decoration: BoxDecoration(
                    color: colors[1],
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white, width: 1)),
              ),
            ),
            GestureDetector(
              onTap: () {
                changeBackColor(2);
                displayColorPicker();
              },
              child: Container(
                height: isDoubleView ? 5.w : 10.w,
                width: isDoubleView ? 5.w : 10.w,
                decoration: BoxDecoration(
                    color: colors[2],
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white, width: 1)),
              ),
            ),
            GestureDetector(
              onTap: () {
                changeBackColor(3);
                displayColorPicker();
              },
              child: Container(
                height: isDoubleView ? 5.w : 10.w,
                width: isDoubleView ? 5.w : 10.w,
                decoration: BoxDecoration(
                    color: colors[3],
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white, width: 1)),
              ),
            ),
            GestureDetector(
              onTap: () {
                changeBackColor(4);
                displayColorPicker();
              },
              child: Container(
                height: isDoubleView ? 5.w : 10.w,
                width: isDoubleView ? 5.w : 10.w,
                decoration: BoxDecoration(
                    color: colors[4],
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white, width: 1)),
              ),
            ),
            GestureDetector(
              onTap: () {
                changeBackColor(5);
                displayColorPicker();
              },
              child: Container(
                height: isDoubleView ? 5.w : 10.w,
                width: isDoubleView ? 5.w : 10.w,
                decoration: BoxDecoration(
                    color: colors[5],
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white, width: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getPlayerMenu() {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        height: isDoubleView ? 15.h : 30.h,
        width: isDoubleView ? 30.h : 70.w,
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.white, width: 1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Night/Day counter :',
                  style: TextStyle(color: Colors.white),
                ),
                Switch(
                  value: isNightDayCounterActive,
                  inactiveTrackColor: Colors.white24,
                  onChanged: (newValue) {
                    setState(() {
                      isNightDayCounterActive = newValue;
                      pSettings = PlayerSettings(
                          isNightDayCounterActive,
                          nightDayCounterState,
                          isPoisonCounterActive,
                          poisonCount,
                          isInitiativeCounterActive,
                          hasInit,
                          isManaPoolActive,
                          greenCount,
                          blueCount,
                          redCount,
                          blackCount,
                          whiteCount,
                          noColorCount);
                    });
                    changePlayerSettings(pSettings);
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Initiative counter :',
                  style: TextStyle(color: Colors.white),
                ),
                Switch(
                  value: isInitiativeCounterActive,
                  inactiveTrackColor: Colors.white24,
                  onChanged: (newValue) {
                    setState(() {
                      isInitiativeCounterActive = newValue;
                      pSettings = PlayerSettings(
                          isNightDayCounterActive,
                          nightDayCounterState,
                          isPoisonCounterActive,
                          poisonCount,
                          isInitiativeCounterActive,
                          hasInit,
                          isManaPoolActive,
                          greenCount,
                          blueCount,
                          redCount,
                          blackCount,
                          whiteCount,
                          noColorCount);
                    });
                    changePlayerSettings(pSettings);
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Poison counter :',
                  style: TextStyle(color: Colors.white),
                ),
                Switch(
                  value: isPoisonCounterActive,
                  inactiveTrackColor: Colors.white24,
                  onChanged: (newValue) {
                    setState(() {
                      isPoisonCounterActive = newValue;
                      pSettings = PlayerSettings(
                          isNightDayCounterActive,
                          nightDayCounterState,
                          isPoisonCounterActive,
                          poisonCount,
                          isInitiativeCounterActive,
                          hasInit,
                          isManaPoolActive,
                          greenCount,
                          blueCount,
                          redCount,
                          blackCount,
                          whiteCount,
                          noColorCount);
                    });
                    changePlayerSettings(pSettings);
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Mana pool :',
                  style: TextStyle(color: Colors.white),
                ),
                Switch(
                  value: isManaPoolActive,
                  inactiveTrackColor: Colors.white24,
                  onChanged: (newValue) {
                    setState(() {
                      isManaPoolActive = newValue;
                      pSettings = PlayerSettings(
                          isNightDayCounterActive,
                          nightDayCounterState,
                          isPoisonCounterActive,
                          poisonCount,
                          isInitiativeCounterActive,
                          hasInit,
                          isManaPoolActive,
                          greenCount,
                          blueCount,
                          redCount,
                          blackCount,
                          whiteCount,
                          noColorCount);
                    });
                    changePlayerSettings(pSettings);
                  },
                )
              ],
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    pSettings = PlayerSettings(
                        isNightDayCounterActive,
                        nightDayCounterState,
                        isPoisonCounterActive,
                        poisonCount,
                        isInitiativeCounterActive,
                        hasInit,
                        isManaPoolActive,
                        greenCount,
                        blueCount,
                        redCount,
                        blackCount,
                        whiteCount,
                        noColorCount);
                  });
                  changePlayerSettings(pSettings);
                  displayMenuPlayer();
                },
                child: const Text(
                  'CLOSE',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildGreenManaCounter() {
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,

    // );
    return Container();
  }

  Widget buildRedManaCounter() {
    return Container();
  }

  Widget buildBlueManaCounter() {
    return Container();
  }

  Widget buildBlackManaCounter() {
    return Container();
  }

  Widget buildWhiteManaCounter() {
    return Container();
  }

  Widget buildNoColorManaCounter() {
    return Container();
  }
}
