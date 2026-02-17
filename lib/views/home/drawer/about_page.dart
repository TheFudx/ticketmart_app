import 'package:flutter/material.dart';

import '../../../utils/app_string.dart';
import 'widget/home_widget.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppString.aboutTxt,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSection(AppString.aboutTxt, AppString.aboutTxt1),
              buildSection(AppString.whoWeareTxt, AppString.aboutTxt2),
              const Text(AppString.whatWeOfferTxt, style: sectionTitleStyle),
              const SizedBox(height: 12.0),
              buildSubSection(AppString.selectTxt, AppString.aboutTxt3),
              buildSubSection(AppString.userTxt, AppString.aboutTxt4),
              buildSubSection(AppString.exclTxt, AppString.aboutTxt5),
              buildSubSection(AppString.custSuppTxt, AppString.aboutTxt6),
              buildSection(AppString.ourMissTxt, AppString.aboutTxt7),
              buildSection(AppString.joinUsTxt, AppString.aboutTxt8),
            ],
          ),
        ),
      ),
    );
  }
}
