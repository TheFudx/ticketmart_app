import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/api_string.dart';
import '../../../../utils/app_assets.dart';
import '../../../../utils/app_string.dart';

AppBar appBar() {
  return AppBar(
    leading: Image.asset(
      AppAssets.logo,
      width: 60,
      height: 60,
    ),
  );
}

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

void showUpdateDialogBox(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismiss on tap outside
    builder: (context) => AlertDialog(
      backgroundColor: Colors.black,
      title: Text(
        AppString.updateRequired,
        style: txtStyle(),
      ),
      content: Text(
        AppString.newVersionText,
        style: txtStyle(),
      ),
      actions: [
        TextButton(
          child: const Text(AppString.update),
          onPressed: () {
            final url =
                Platform.isAndroid ? ApiString.appAndroid : ApiString.appIos;
            launchURLRed(url);
          },
        ),
        TextButton(
          child: const Text(AppString.exit),
          onPressed: () => exit(0),
        ),
      ],
    ),
  );
}

void launchURLRed(String url) async {
  Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    log("Could not launch $url");
  }
}

TextStyle txtStyle({color = Colors.white, fontWeight = FontWeight.normal}) {
  return TextStyle(color: color, fontWeight: fontWeight);
}
