import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DiceFace extends StatefulWidget {
  const DiceFace(
      {Key? key,
      required this.number,
      required this.isWinner,
      required this.isDoubleView})
      : super(key: key);

  final int number;
  final bool isWinner;
  final bool isDoubleView;

  @override
  State<DiceFace> createState() => _DiceFaceState();
}

class _DiceFaceState extends State<DiceFace> {
  late final int number;
  late final bool isWinner;
  late final bool isDoubleView;

  @override
  void initState() {
    isWinner = widget.isWinner;
    number = widget.number;
    isDoubleView = widget.isDoubleView;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isDoubleView ? 50.w : 46.h,
      width: isDoubleView ? 46.h : 100.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 22.5.w,
            height: 22.5.w,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white,
                    style: BorderStyle.solid,
                    width: 0.8.w)),
            child: Center(
                child: Text(
              number.toString(),
              style: TextStyle(
                  fontSize: 4.h,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            )),
          ),
          isWinner
              ? Text(
                  'WINNER !',
                  style: TextStyle(
                      fontSize: 2.5.h,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                )
              : Container()
        ],
      ),
    );
  }
}
