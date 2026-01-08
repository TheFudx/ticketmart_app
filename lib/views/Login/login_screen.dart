import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticketmart/views/home/drawer/home_screen.dart';

import '../../repository/auth/login.dart';
import '../../storage/shared_pref_helper.dart';
import '../../utils/app_assets.dart';

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
    try {
      final response = await LoginRespository.login(
        _emailController.text,
        _mobileController.text,
      );

      if (response.status) {
        await storageData(
          response.data.user.id,
          response.data.user.email,
          response.data.user.mobile,
          response.data.token,
        );
        Get.off(() => HomeScreen(response.data.user.id));
      } else {
        _showError(response.message);
      }
    } catch (e) {
      _showError("Something went wrong $e");
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> storageData(
    int userId,
    String userEmail,
    String userMobile,
    String userToken,
  ) async {
    await Future.wait([
      SharedPrefHelper.setUserId(userId),
      SharedPrefHelper.setUserEmail(userEmail),
      SharedPrefHelper.setUserMobile(userMobile),
      SharedPrefHelper.setUserToken(userToken),
    ]);
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
        title: const Text('Login '),
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
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Mobile Number Field
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return "Mobile must be 10 digits";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
