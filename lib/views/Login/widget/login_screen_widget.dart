import 'package:flutter/material.dart';

InputDecoration loginInputDec(String text, IconData icon) {
  return InputDecoration(
    labelText: text,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    prefixIcon: Icon(icon),
  );
}
