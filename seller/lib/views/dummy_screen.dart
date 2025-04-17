import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:seller/views/gif_test.dart';

class DummyScreen extends StatefulWidget {
  final String screenTitle;
  const DummyScreen(this.screenTitle, {super.key});

  @override
  State<DummyScreen> createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FxText.titleMedium(widget.screenTitle),
            // ElevatedButton(onPressed: () {
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => GifTest()));
            // }, child: Text("GIF")),
          ],
        ),
      ),
    );
  }
}