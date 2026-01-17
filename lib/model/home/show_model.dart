class ShowModel {
  final bool status;
  final String message;
  final ShowData data;

  ShowModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    return ShowModel(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: ShowData.fromJson(json['data']),
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

class ShowData {
  final Show show;
  final List<Showtime> showtimes;

  ShowData({
    required this.show,
    required this.showtimes,
  });

  factory ShowData.fromJson(Map<String, dynamic> json) {
    return ShowData(
      show: Show.fromJson(json['show']),
      showtimes:
          (json['showtimes'] as List).map((e) => Showtime.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'show': show.toJson(),
      'showtimes': showtimes.map((e) => e.toJson()).toList(),
    };
  }
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
  final String createdAt;
  final String updatedAt;

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
    required this.createdAt,
    required this.updatedAt,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      genre: json['genre'] as String,
      duration: json['duration'] as int,
      imagePath: json['image_path'] as String,
      bannerImagePath: json['banner_image_path'] as String,
      language: json['language'] as String,
      rating: json['rating'] as String,
      price: json['price'] as int,
      status: json['status'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Showtime {
  final int id;
  final int showId;
  final int stageId;
  final String date;
  final String startTime;
  final String createdAt;
  final String updatedAt;
  final bool isDone;

  Showtime({
    required this.id,
    required this.showId,
    required this.stageId,
    required this.date,
    required this.startTime,
    required this.createdAt,
    required this.updatedAt,
    required this.isDone,
  });

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      id: json['id'] as int,
      showId: json['show_id'] as int,
      stageId: json['stage_id'] as int,
      date: json['date'] as String,
      startTime: json['start_time'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      isDone: json['isDone'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'show_id': showId,
      'stage_id': stageId,
      'date': date,
      'start_time': startTime,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'isDone': isDone,
    };
  }
}
