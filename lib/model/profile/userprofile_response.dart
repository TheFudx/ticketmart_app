class UserResponse {
  final String status;
  final String message;
  final User user;

  UserResponse({
    required this.status,
    required this.message,
    required this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      status: json['status'],
      message: json['message'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final String id;
  final String? name;
  final String email;
  final String mobileNo;
  final String? emailVerifiedAt;
  final String role;
  final String? password;
  final String? rememberToken;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    this.name,
    required this.email,
    required this.mobileNo,
    this.emailVerifiedAt,
    required this.role,
    this.password,
    this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobileNo: json['mobile_no'],
      emailVerifiedAt: json['email_verified_at'],
      role: json['role'],
      password: json['password'],
      rememberToken: json['remember_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
