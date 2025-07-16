import 'dart:async';

import 'package:flutter/material.dart';

class LinearTimer extends StatefulWidget {
  const LinearTimer({super.key});

  @override
  State<LinearTimer> createState() => _LinearTimerState();
}

class _LinearTimerState extends State<LinearTimer> {

  int segundosRestantes = 8;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer){
      if(segundosRestantes == 0){
        timer.cancel();
        Navigator.of(context).pop();
      }
      else{
        setState(() {
          segundosRestantes --;
        });
      }
    });

  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progreso = segundosRestantes / 8;
    return LinearProgressIndicator(
      value: progreso,
      backgroundColor: const Color(0xFFCC9932),
      color: const Color(0xff0f1424),
    );
  }
}