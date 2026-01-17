class ApiString {
  ApiString._();
  static const String alphaBaseUrl =
      'https://alphastudioz.in/ticketmart-test/public/flutter-app'; // Testing Server

  //    "https://ticketmart.co/public/flutter-app"; // Replace with your server address
  static const String userEndpoint = "/user";
  static const String bookingEndpoint =
      "/booking"; // Add this line for the booking endpoint

  static String get movies => "$alphaBaseUrl$userEndpoint/movies.php";
  static String get theatres => "$alphaBaseUrl$userEndpoint/theatres.php";
  static String get dataUrl => "$alphaBaseUrl$userEndpoint/profile_modal.php";
  static String get seatCount => "$alphaBaseUrl$userEndpoint/seat_count.php";
  static String get screens => "$alphaBaseUrl$userEndpoint/screen.php";

  static String get seats =>
      "$alphaBaseUrl$userEndpoint/fetch_seats.php"; // Add this line for the bookings endpoint

  static const String baseUrl = "https://ticketmart.co/UAT/public/api";
  static const String loginUrl = "$baseUrl/login";
  static const String logoutUrl = "$baseUrl/logout";
  static const String homePageUrl = "$baseUrl/home-page"; // Method Get
  static const String showtimeUrl =
      "$baseUrl/comedy-shows/show-times"; // Method Post
  static const String seatLayout =
      "$baseUrl/comedy-shows/seat-layout"; // Method Post
}
