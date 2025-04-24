import 'package:flutter/material.dart';

import '../utils/app_assets.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Coming Soon ")),
      body: Image.asset(
        AppAssets.comingSoon,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
