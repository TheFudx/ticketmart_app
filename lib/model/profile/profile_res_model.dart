class ProfileResponse {
  final bool status;
  final String message;
  final Data data;

  ProfileResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class Data {
  final UserProfile user;
  final List<ComedyShowBooking> comedyShowsBooking;

  Data({
    required this.user,
    required this.comedyShowsBooking,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      user: UserProfile.fromJson(json['user']),
      comedyShowsBooking: (json['comedy_shows_booking'] as List)
          .map((e) => ComedyShowBooking.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'comedy_shows_booking':
          comedyShowsBooking.map((e) => e.toJson()).toList(),
    };
  }
}

class UserProfile {
  final int id;
  final String name;
  final String email;
  final String mobile;
  final String role;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.role,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'role': role,
    };
  }
}

class ComedyShowBooking {
  final int showId;
  final String showTitle;
  final String showDate;
  final String startTime;
  final List<Booking> bookings;

  ComedyShowBooking({
    required this.showId,
    required this.showTitle,
    required this.showDate,
    required this.startTime,
    required this.bookings,
  });

  factory ComedyShowBooking.fromJson(Map<String, dynamic> json) {
    return ComedyShowBooking(
      showId: json['show_id'],
      showTitle: json['show_title'],
      showDate: json['show_date'],
      startTime: json['start_time'],
      bookings:
          (json['bookings'] as List).map((e) => Booking.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'show_id': showId,
      'show_title': showTitle,
      'show_date': showDate,
      'start_time': startTime,
      'bookings': bookings.map((e) => e.toJson()).toList(),
    };
  }
}

class Booking {
  final int bookingId;
  final int totalSeats;
  final String totalAmount;
  final List<Seat> seats;

  Booking({
    required this.bookingId,
    required this.totalSeats,
    required this.totalAmount,
    required this.seats,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['booking_id'],
      totalSeats: json['total_seats'],
      totalAmount: json['total_amount'],
      seats: (json['seats'] as List).map((e) => Seat.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'total_seats': totalSeats,
      'total_amount': totalAmount,
      'seats': seats.map((e) => e.toJson()).toList(),
    };
  }
}

class Seat {
  final String seatType;
  final List<String> seats;

  Seat({
    required this.seatType,
    required this.seats,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      seatType: json['seat_type'],
      seats: List<String>.from(json['seats']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seat_type': seatType,
      'seats': seats,
    };
  }
}
