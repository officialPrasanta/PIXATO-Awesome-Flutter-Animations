import 'package:flutter/material.dart';
import 'package:pixato/common/appbar.dart';

class AnimatedIconPage extends StatefulWidget {
  const AnimatedIconPage({Key? key}) : super(key: key);

  @override
  State<AnimatedIconPage> createState() => _AnimatedIconPageState();
}

class _AnimatedIconPageState extends State<AnimatedIconPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void _trigger() {
    setState(() {
      isChanged = !isChanged;
      isChanged ? controller.forward() : controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        extendBodyBehindAppBar: true,
        body: Container(
          color: const Color(0xFF13243D),
          child: Center(
            child: IconButton(
                iconSize: 48,
                onPressed: _trigger,
                icon: AnimatedIcon(
                  icon: AnimatedIcons.close_menu,
                  progress: controller,
                  color: Colors.orange,
                )),
          ),
        ));
  }
}
