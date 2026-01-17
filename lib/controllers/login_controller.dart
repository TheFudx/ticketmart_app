import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketmart/repository/auth/login.dart';

import '../providers/user_provider.dart';
import '../utils/date_utils.dart';

class LoginController {
  final BuildContext context;

  LoginController(this.context);

  Future<String?> submit({
    required String email,
    required String mobile,
  }) async {
    try {
      final response = await LoginRespository.login(email, mobile);

      if (!response.status) {
        return response.message;
      }

      await storageData(
        response.data.user.id,
        response.data.user.email,
        response.data.user.mobile,
        response.data.token,
        response.data.user,
      );

      if (!context.mounted) return null;

      context.read<UserProvider>().setUser(response.data.user);
      return null;
    } catch (e) {
      return "Something went wrong";
    }
  }
}
