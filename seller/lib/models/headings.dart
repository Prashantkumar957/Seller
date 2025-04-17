import 'package:flutter/material.dart';

Text stepHeading(String text) => Text(
      text,
      style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
    );

Text pageHeading(String text) => Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );

Text sectionHeading(String text) => Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
    );

Text sectionTitle(String text) => Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
