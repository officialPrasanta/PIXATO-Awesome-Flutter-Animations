// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixato/pages/animatedIcons/animated_icon_page.dart';
import 'package:pixato/pages/clockAnimation/clockanim.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF13243D),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 50,
            ),
            child: ListView(
              children: [
                menuButtons(
                  btnName: 'Clock Page',
                  btnFunctionality: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClockAnimationPage(),
                    ),
                  ),
                ),
                menuButtons(
                  btnName: 'Animated Icon',
                  btnFunctionality: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnimatedIconPage(),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  InkWell menuButtons(
      {required String btnName, required void Function() btnFunctionality}) {
    return InkWell(
      onTap: btnFunctionality,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.amber,
                  width: 2,
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  btnName,
                  style:
                      GoogleFonts.firaCode(fontSize: 18, color: Colors.amber),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
