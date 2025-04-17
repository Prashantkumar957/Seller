import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GifTest extends StatefulWidget {
  const GifTest({super.key});

  @override
  State<GifTest> createState() => _GifTestState();
}

class _GifTestState extends State<GifTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image(image: AssetImage("assets/images/splash_screen.gif")),
    );
  }
}