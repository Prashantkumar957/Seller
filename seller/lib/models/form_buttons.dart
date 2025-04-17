import 'package:flutter/material.dart';

Widget buildActionButton(
    {required String label, required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Colors.white,
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );
}
