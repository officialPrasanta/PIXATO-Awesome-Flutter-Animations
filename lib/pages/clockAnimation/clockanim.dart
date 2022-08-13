// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pixato/pages/clockAnimation/Helpers/custom_clock_painter.dart';
import 'package:pixato/pages/clockAnimation/Helpers/custom_wave_widget.dart';

class ClockAnimationPage extends StatefulWidget {
  const ClockAnimationPage({Key? key}) : super(key: key);

  @override
  State<ClockAnimationPage> createState() => _ClockAnimationPageState();
}

class _ClockAnimationPageState extends State<ClockAnimationPage>
    with SingleTickerProviderStateMixin {
  DateFormat timeFormat = DateFormat('hh : mm : ss a');
  DateFormat dateFormat = DateFormat('EE, d MMMM');
  String time = '';
  String date = '';
  DateTime now = DateTime.now();
  @override
  void initState() {
    // now = DateTime.now();
    date = dateFormat.format(now);
    Timer.periodic(
        Duration(seconds: 1),
        (timer) => setState(() {
              now = DateTime.now();
              time = timeFormat.format(now);
            }));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Color(0xFF13243D),
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            SizedBox(
              width: 200,
              height: 200,
              child: Transform.rotate(
                angle: -(90 * pi / 180),
                child: CustomPaint(
                  painter: ClockPaint(now: now),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    time,
                    style: GoogleFonts.boogaloo(
                        color: Color(0xFFF2F2F2), fontSize: 32),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    date,
                    style: GoogleFonts.boogaloo(
                        color: Color(0xFF5B708F), fontSize: 20),
                  ),
                ],
              ),
            ),
            // Spacer(),
            // Spacer(),
            // Align(
            //   alignment: Alignment.bottomCenter,
            Expanded(
              child: WeavyWave(
                layerCount: 4,
                waveAmplitude: 15,
                durations: const <int>[15000, 5000, 10000, 15000],
                colors: const [
                  Color(0x60FFACDC),
                  Color(0x92FFACDC),
                  Color(0xA6FFACDC),
                  Color.fromARGB(199, 255, 172, 220),
                ],
                waveFrequencies: const <double>[1.6, 1.7, 2.3, 2.1],
                heightPercentage: const <double>[0.8, 0.65, 0.5, 0.3],
                canvasMaxHeight: 400,
                wavePhase: 20,
              ),
            ),
            // )
          ],
        ),
      ),
    );
  }
}
