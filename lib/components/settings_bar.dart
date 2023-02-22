import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SettingsBar extends StatefulWidget {
  const SettingsBar({
    Key? key,
    required this.diceFunc,
    required this.lifeFunc,
    required this.resetFunc,
    required this.playerFunc,
  }) : super(key: key);

  final Function diceFunc;
  final Function lifeFunc;
  final Function resetFunc;
  final Function playerFunc;

  @override
  State<SettingsBar> createState() => _SettingsBarState();
}

class _SettingsBarState extends State<SettingsBar> {
  late final Function diceFunc;
  late final Function lifeFunc;
  late final Function resetFunc;
  late final Function playerFunc;
  late bool changingLifeTotal;
  late bool changingNumberPlayer;

  @override
  void initState() {
    diceFunc = widget.diceFunc;
    lifeFunc = widget.lifeFunc;
    resetFunc = widget.resetFunc;
    playerFunc = widget.playerFunc;
    changingLifeTotal = false;
    changingNumberPlayer = false;
    super.initState();
  }

  setLife(int newLifeTotal) {
    lifeFunc(newLifeTotal);
    setState(() {
      changingLifeTotal = false;
    });
  }

  setPlayerNumber(int playerNumber) {
    print(playerNumber);
    playerFunc(playerNumber);
    setState(() {
      changingNumberPlayer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 8.h,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
            bottom: BorderSide(color: Colors.white),
            top: BorderSide(color: Colors.white)),
      ),
      child: changingLifeTotal
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          changingLifeTotal = false;
                        });
                      },
                      icon: Icon(
                        Icons.undo,
                        color: Colors.white,
                        size: 2.4.h,
                      )),
                  IconButton(
                      onPressed: () => setLife(20),
                      icon: Text(
                        '20',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 2.5.h,
                        ),
                      )),
                  IconButton(
                      onPressed: () => setLife(30),
                      icon: Text(
                        '30',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 2.5.h,
                        ),
                      )),
                  IconButton(
                      onPressed: () => setLife(40),
                      icon: Text(
                        '40',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 2.5.h,
                        ),
                      )),
                ])
          : changingNumberPlayer
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              changingNumberPlayer = false;
                            });
                          },
                          icon: Icon(
                            Icons.undo,
                            color: Colors.white,
                            size: 2.4.h,
                          )),
                      IconButton(
                          onPressed: () => setPlayerNumber(2),
                          icon: Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 2.5.h,
                            ),
                          )),
                      IconButton(
                          onPressed: () => setPlayerNumber(3),
                          icon: Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 2.5.h,
                            ),
                          )),
                      IconButton(
                          onPressed: () => setPlayerNumber(4),
                          icon: Text(
                            '4',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 2.5.h,
                            ),
                          )),
                    ])
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      IconButton(
                          onPressed: () => diceFunc(),
                          icon: const Icon(
                            Icons.casino_sharp,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              changingLifeTotal = true;
                            });
                          },
                          icon: const Icon(
                            Icons.favorite_sharp,
                            color: Colors.white,
                          )),
                      SvgPicture.asset(
                        'images/Logo2.svg',
                        height: 7.5.h,
                      ),
                      IconButton(
                          onPressed: () => resetFunc(),
                          icon: const Icon(
                            Icons.restart_alt_sharp,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              changingNumberPlayer = true;
                            });
                          },
                          icon: const Icon(
                            Icons.group_add_sharp,
                            color: Colors.white,
                          )),
                    ]),
    );
  }
}
