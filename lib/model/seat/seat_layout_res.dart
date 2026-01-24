class SeatLayoutResponse {
  final bool status;
  final String message;
  final SeatData? data;

  SeatLayoutResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory SeatLayoutResponse.fromJson(Map<String, dynamic> json) {
    return SeatLayoutResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? SeatData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class SeatData {
  final bool isDone;
  final Show? show;
  final Stage? stage;

  SeatData({
    required this.isDone,
    this.show,
    this.stage,
  });

  factory SeatData.fromJson(Map<String, dynamic> json) {
    return SeatData(
      isDone: json['isDone'] ?? false,
      show: json['show'] != null ? Show.fromJson(json['show']) : null,
      stage: json['stage'] != null ? Stage.fromJson(json['stage']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'isDone': isDone,
        'show': show?.toJson(),
        'stage': stage?.toJson(),
      };
}

class Show {
  final int id;
  final String title;
  final String description;
  final String genre;
  final int duration;
  final String imagePath;
  final String bannerImagePath;
  final String language;
  final String rating;
  final int price;
  final int status;
  final List<Showtimes> showtime;

  Show({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    required this.duration,
    required this.imagePath,
    required this.bannerImagePath,
    required this.language,
    required this.rating,
    required this.price,
    required this.status,
    required this.showtime,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      genre: json['genre'] ?? '',
      duration: json['duration'] ?? 0,
      imagePath: json['image_path'] ?? '',
      bannerImagePath: json['banner_image_path'] ?? '',
      language: json['language'] ?? '',
      rating: json['rating'] ?? '',
      price: json['price'] ?? 0,
      status: json['status'] ?? 0,
      showtime: (json["showtimes"] as List<dynamic>? ?? [])
          .map((e) => Showtimes.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'genre': genre,
        'duration': duration,
        'image_path': imagePath,
        'banner_image_path': bannerImagePath,
        'language': language,
        'rating': rating,
        'price': price,
        'status': status,
      };
}

class Showtimes {
  final int? id;
  final int? showId;
  final String? date;
  final String? startTime;
  final int? stageId;

  Showtimes({
    required this.id,
    required this.showId,
    required this.date,
    required this.startTime,
    required this.stageId,
  });

  factory Showtimes.fromJson(Map<String, dynamic> json) {
    return Showtimes(
      id: json["id"] ?? 0,
      showId: json["show_id"] ?? "",
      date: json["date"] ?? "",
      startTime: json["start_time"],
      stageId: json["stage_id"],
    );
  }
}

class Stage {
  final int id;
  final int locationId;
  final int stageNumber;
  final int totalSeats;
  final Slocation? slocation;
  final List<Cseat> cseats;

  Stage({
    required this.id,
    required this.locationId,
    required this.stageNumber,
    required this.totalSeats,
    this.slocation,
    required this.cseats,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json['id'] ?? 0,
      locationId: json['location_id'] ?? 0,
      stageNumber: json['stage_number'] ?? 0,
      totalSeats: json['total_seats'] ?? 0,
      slocation: json['slocation'] != null
          ? Slocation.fromJson(json['slocation'])
          : null,
      cseats: (json['cseats'] as List<dynamic>? ?? [])
          .map((e) => Cseat.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'location_id': locationId,
        'stage_number': stageNumber,
        'total_seats': totalSeats,
        'slocation': slocation?.toJson(),
        'cseats': cseats.map((e) => e.toJson()).toList(),
      };
}

class Slocation {
  final int id;
  final String name;
  final String location;
  final int totalStage;

  Slocation({
    required this.id,
    required this.name,
    required this.location,
    required this.totalStage,
  });

  factory Slocation.fromJson(Map<String, dynamic> json) {
    return Slocation(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      totalStage: json['total_stage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'total_stage': totalStage,
      };
}

class Cseat {
  final int id;
  final int stageId;
  final String seatNumber;
  final String seatType;
  final String section;
  final String price;
  final String commissionPrice;
  final bool booked;

  Cseat({
    required this.id,
    required this.stageId,
    required this.seatNumber,
    required this.seatType,
    required this.section,
    required this.price,
    required this.commissionPrice,
    required this.booked,
  });

  factory Cseat.fromJson(Map<String, dynamic> json) {
    return Cseat(
      id: json['id'] ?? 0,
      stageId: json['stage_id'] ?? 0,
      seatNumber: json['seat_number'] ?? '',
      seatType: json['seat_type'] ?? '',
      section: json['section'] ?? '',
      price: json['price'] ?? '',
      commissionPrice: json['commission_price'] ?? '',
      booked: json['booked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'stage_id': stageId,
        'seat_number': seatNumber,
        'seat_type': seatType,
        'section': section,
        'price': price,
        'commission_price': commissionPrice,
        'booked': booked,
      };
}
