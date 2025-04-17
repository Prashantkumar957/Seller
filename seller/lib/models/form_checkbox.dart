import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

Widget buildGeneralCheckbox({
  required bool value,
  required String text,
  required ValueChanged<bool?>? onChanged,
}) =>
    Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(text),
      ],
    );

Widget buildGeneralSwitch({
  required bool value,
  required String text,
  required ValueChanged<bool> onChanged,
}) =>
    Row(
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
        FlutterSwitch(
          value: value,
          onToggle: onChanged,
          inactiveColor: const Color.fromARGB(255, 177, 177, 177),
          activeColor: const Color.fromARGB(255, 108, 39, 176),
          height: 30,
          width: 55,
        ),
      ],
    );
