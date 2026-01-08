class LoginRequest {
  final String email;
  final String mobile;

  LoginRequest({
    required this.email,
    required this.mobile,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "mobile": mobile,
    };
  }
}
