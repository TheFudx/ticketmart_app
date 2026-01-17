import 'package:flutter/material.dart';

InputDecoration loginInputDec(String text, IconData icon) {
  return InputDecoration(
    labelText: text,
    border: const OutlineInputBorder(),
    prefixIcon: Icon(icon),
  );
}
