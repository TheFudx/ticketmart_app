class UserProfileResp {
  final String status;
  final String message;
  final User? user;

  UserProfileResp({
    required this.status,
    required this.message,
    this.user,
  });

  factory UserProfileResp.fromJson(Map<String, dynamic> json) {
    return UserProfileResp(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      user: json['user'] != null && json['user'] is Map<String, dynamic>
          ? User.fromJson(json['user'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'user': user?.toJson(),
    };
  }
}

class User {
  final String? id;
  final String? name;
  final String? email;
  final String? mobileNo;
  final String? emailVerifiedAt;
  final String? role;
  final String? password;
  final String? rememberToken;
  final String? createdAt;
  final String? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.mobileNo,
    this.emailVerifiedAt,
    this.role,
    this.password,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
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
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'mobile_no': mobileNo,
        'email_verified_at': emailVerifiedAt,
        'role': role,
        'password': password,
        'remember_token': rememberToken,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
