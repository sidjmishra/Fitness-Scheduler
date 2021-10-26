import 'dart:async';

import 'package:fitness_planner_app/screens/exercise_list.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ExerciseList())),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "https://i.pinimg.com/564x/e1/d2/20/e1d220927dac5a7c8a44a8970ee48b7d.jpg",
      fit: BoxFit.fill,
    );
  }
}
