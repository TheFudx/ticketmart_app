class ApiString {
  static const String baseUrl =
      'https://alphastudioz.in/ticketmart-test/public/flutter-app'; // Testing Server

  //    "https://ticketmart.co/public/flutter-app"; // Replace with your server address
  static const String userEndpoint = "/user";
  static const String bookingEndpoint =
      "/booking"; // Add this line for the booking endpoint

  static String get movies => "$baseUrl$userEndpoint/movies.php";
  static String get theatres => "$baseUrl$userEndpoint/theatres.php";
  static String get dataUrl => "$baseUrl$userEndpoint/profile_modal.php";
  static String get seatCount => "$baseUrl$userEndpoint/seat_count.php";
  static String get screens => "$baseUrl$userEndpoint/screen.php";
  static String get users => "$baseUrl$userEndpoint/users.php";
  static String get bookings =>
      "$baseUrl$bookingEndpoint/create_booking.php"; // Add this line for the bookings endpoint
  static String get seats =>
      "$baseUrl$userEndpoint/fetch_seats.php"; // Add this line for the bookings endpoint
  static String get theatresList => "$baseUrl$userEndpoint/theatres_list.php";

  static String get userProfile => "$baseUrl$userEndpoint/get_users.php";
}
