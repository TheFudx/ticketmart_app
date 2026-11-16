class ApiString {
  ApiString._();

  //  static const String baseUrl = "https://ticketmart.co/UAT/public/api"; // UAT
  static const String baseUrl = "https://ticketmart.co/api";
  static const String loginUrl = "$baseUrl/login";
  static const String logoutUrl = "$baseUrl/logout";
  static const String homePageUrl = "$baseUrl/home-page"; // Method Get
  static const String showtimeUrl =
      "$baseUrl/comedy-shows/show-times"; // Method Post
  static const String seatLayout =
      "$baseUrl/comedy-shows/seat-layout"; // Method Post
  static const String paymentSucces = "$baseUrl/payment-success";
  static const String paymentFail = "$baseUrl/payment-fail";
  static const String profile = "$baseUrl/user-profile";
  static const String appVersionChecker = "$baseUrl/latest_version";

  // VIP Invitation System URLs (v1)
  static const String invitationBannerUrl = "$baseUrl/v1/invitations/banner";
  static String invitationEventDetailsUrl(String slug) =>
      "$baseUrl/v1/invitations/events/$slug";
  static String invitationSendOtpUrl(String slug) =>
      "$baseUrl/v1/invitations/events/$slug/send-otp";
  static String invitationVerifyOtpUrl(String slug) =>
      "$baseUrl/v1/invitations/events/$slug/verify-otp";
  static String invitationVerifyUrl(String slug) =>
      "$baseUrl/v1/invitations/events/$slug/verify";
  static String invitationMyCardUrl(String slug) =>
      "$baseUrl/v1/invitations/events/$slug/my-card";
  static String invitationCardDownloadUrl(String slug, String token) =>
      "$baseUrl/v1/invitations/events/$slug/card/download?token=$token";
  static String invitationQrUrl(String token) =>
      "$baseUrl/v1/invitations/qr/$token";

  static const Map<String, String> header = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const String androidStoreUrl =
      "https://play.google.com/store/apps/details?id=com.alphastudioz.ticketmart";

  static const String iosStoreUrl =
      "https://play.google.com/store/apps/details?id=com.alphastudioz.ticketmart";
}
