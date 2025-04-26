class UserprofileReq {
  String email;
  String mobileno;

  UserprofileReq({required this.email, required this.mobileno});

  Map<String, String> toJson() {
    return {'email': email, 'mobile_no': mobileno};
  }
}
