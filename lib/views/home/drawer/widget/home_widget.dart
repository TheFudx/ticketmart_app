import 'package:flutter/material.dart';

Widget buildImageContainer(
  String imagePath, {
  required double width,
  required double height,
}) {
  return InkWell(
    onTap: () {},
    child: Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
