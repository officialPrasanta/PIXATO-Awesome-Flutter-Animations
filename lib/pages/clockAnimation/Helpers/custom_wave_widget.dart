import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

enum Direction { right, left }

class WeavyWave extends StatefulWidget {
  WeavyWave(
      {required this.layerCount,
      this.waveAmplitude = 10.0,
      this.waveFrequencies = const [1.6],
      this.wavePhase = 0.2,
      this.durations = const [6000],
      // this.isLoop = true,
      this.colors = const [Color(0x812195F3)],
      this.heightPercentage = const [0.2],
      this.canvasMaxHeight = 200,
      // this.size = const Size(double.infinity, double.infinity),
      this.flowDirection = Direction.right,
      Key? key})
      : super(key: key);

  int layerCount;
  double waveAmplitude;
  List<double> waveFrequencies;
  double wavePhase;
  List<int> durations;
  // bool isLoop;
  List<Color> colors;
  List<double> heightPercentage;
  double canvasMaxHeight;
  // Size size;
  Direction flowDirection;

  @override
  State<WeavyWave> createState() => _WeavyWaveState();
}

class _WeavyWaveState extends State<WeavyWave> with TickerProviderStateMixin {
  late List<AnimationController> _waveAnimControllers;
  late List<Animation<double>> _wavePhases;
  List<int> _durations = <int>[];
  List<double> _waveFrequencies = <double>[];
  List<Color> _colors = <Color>[];
  List<double> _heightPercentage = <double>[];

  void _initAnim() {
    if (widget.layerCount > 1) {
      //check if layerCount and durations, waveFrequencies,
      //colors, heightPercentages are same or not

      //:duration
      if (widget.layerCount == widget.durations.length) {
        _durations = widget.durations;
      } else if (widget.layerCount > widget.durations.length) {
        _durations = [];
        _durations.addAll(widget.durations);
        _durations = _durations +
            List<int>.generate(
                (widget.layerCount - widget.durations.length), (_) => 6000);
      } else {
        _durations = widget.durations.sublist(0, widget.layerCount);
      }
      //: waveFrequencies
      if (widget.layerCount == widget.waveFrequencies.length) {
        _waveFrequencies = widget.waveFrequencies;
      } else if (widget.layerCount > widget.waveFrequencies.length) {
        _waveFrequencies = [];
        _waveFrequencies.addAll(widget.waveFrequencies);
        _waveFrequencies = _waveFrequencies +
            List<double>.generate(
                (widget.layerCount - widget.waveFrequencies.length),
                (_) => 1.6);
      } else {
        _waveFrequencies = widget.waveFrequencies.sublist(0, widget.layerCount);
      }
      //: colors
      if (widget.layerCount == widget.colors.length) {
        _colors = widget.colors;
      } else if (widget.layerCount > widget.colors.length) {
        _colors = [];
        _colors.addAll(widget.colors);
        _colors = _colors +
            List<Color>.generate((widget.layerCount - widget.colors.length),
                (_) => Color(0x812195F3));
      } else {
        _colors = widget.colors.sublist(0, widget.layerCount);
      }

      //: heightPercentage
      if (widget.layerCount == widget.heightPercentage.length) {
        _heightPercentage = widget.heightPercentage;
      } else if (widget.layerCount > widget.heightPercentage.length) {
        _heightPercentage = [];
        _heightPercentage.addAll(widget.heightPercentage);
        _heightPercentage = _heightPercentage +
            List<double>.generate(
                (widget.layerCount - widget.heightPercentage.length),
                (_) => 0.2);
      } else {
        _heightPercentage =
            widget.heightPercentage.sublist(0, widget.layerCount);
      }
    } else if (widget.layerCount == 1) {
      _durations = [widget.durations[0]];
      _waveFrequencies = [widget.waveFrequencies[0]];
      _colors = [widget.colors[0]];
      _heightPercentage = [widget.heightPercentage[0]];
    } else {
      throw ('Count must not less than Integer 1');
    }

    _waveAnimControllers = _durations.map((duration) {
      return AnimationController(
          duration: Duration(milliseconds: duration), vsync: this);
    }).toList();

    _wavePhases = _waveAnimControllers.map((AnimationController controller) {
      CurvedAnimation curve =
          CurvedAnimation(parent: controller, curve: Curves.easeInOut);

      Animation<double> value =
          Tween<double>(begin: widget.wavePhase, end: 360 + widget.wavePhase)
              .animate(curve)
            ..addListener(() {
              if (mounted) {
                setState(() {});
              }
            });
      value.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
      controller.forward();
      return value;
    }).toList();
  }

  void _disposeControllers() {
    for (AnimationController controller in _waveAnimControllers) {
      controller.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    _initAnim();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  _buildLayers() {
    List<Widget> layers = [];
    double _height = 0.0;
    Size _size;
    for (int i = 0; i < widget.layerCount; i++) {
      _height = widget.canvasMaxHeight * _heightPercentage[i];
      _size = Size(double.infinity, _height);
      layers.add(
        Align(
          alignment: Alignment.bottomCenter,
          child: CustomPaint(
            painter: _WeavyWavePaint(
              color: _colors[i],
              waveFrequency: _waveFrequencies[i],
              amplitude: widget.waveAmplitude,
              wavePhase: _wavePhases[i],
            ),
            size: _size,
          ),
        ),
      );
    }
    // print('Layers: ${layers.length}');
    return layers;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _buildLayers(),
    );
  }
}

class _WeavyWavePaint extends CustomPainter {
  _WeavyWavePaint({
    required this.color,
    required this.waveFrequency,
    required this.amplitude,
    required this.wavePhase,
  });

  Animation<double>? wavePhase;

  double viewWidth = 0.0;
  Color color;
  double waveFrequency;
  double amplitude;

  double _tempA = 0.0;
  double _tempB = 0.0;

  double _getSinY(
      {required double startradius,
      required double waveFrequency,
      required int currentposition}) {
    if (_tempA == 0) {
      _tempA = 2 * pi / viewWidth;
    }
    if (_tempB == 0) {
      _tempB = 2 * pi / 360.0;
    }

    return sin(
        _tempA * waveFrequency * (currentposition + 1) + startradius * _tempB);
  }

  void _setPath(Canvas canvas, Size size) {
    Paint _wave = Paint()..color = color;
    double y = 0.0;

    Path _path = Path();

    viewWidth = size.width;
    double viewCenterY = size.height * (0.20 + 0.1);
    _path.reset();
    _path.moveTo(
        0.0,
        viewCenterY +
            amplitude *
                _getSinY(
                    currentposition: -1,
                    startradius: wavePhase!.value * 2 + 30,
                    waveFrequency: waveFrequency));
    for (int x = 0; x < size.width + 1; x++) {
      y = viewCenterY +
          (-0.8) *
              amplitude *
              _getSinY(
                  startradius: wavePhase!.value * 2 + 30,
                  waveFrequency: waveFrequency,
                  currentposition: x);
      _path.lineTo(x.toDouble(), y);
    }

    _path.lineTo(size.width, size.height);
    _path.lineTo(0.0, size.height);
    _path.close();
    canvas.drawPath(_path, _wave);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _setPath(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
