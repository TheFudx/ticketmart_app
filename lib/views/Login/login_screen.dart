import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticketmart/controllers/login_controller.dart';
import 'package:ticketmart/views/home/drawer/home_screen.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_string.dart';
import 'widget/login_screen_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  late FocusNode _focusNode;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = LoginController(context);

    final error = await controller.submit(
        email: _emailController.text, mobile: _mobileController.text);

    if (error != null) {
      _showError(error);
      return;
    }
    Get.off(() => const HomeScreen());
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _mobileController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.logingTxt),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Logo Theme
              Image.asset(
                AppAssets.logo,
                height: 250,
                width: 200,
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 30),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: loginInputDec(AppString.emailTxt, Icons.email),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppString.plzEntEmailTxt;
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return AppString.plzEntEmailTxt;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Mobile Number Field
              TextFormField(
                controller: _mobileController,
                decoration: loginInputDec(AppString.mobileNumTxt, Icons.phone),
                keyboardType: TextInputType.phone,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppString.plzEntMobTxt;
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return AppString.mobLengTxt;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Color(0xFF000000),
                    ),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: const Text(AppString.submit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
