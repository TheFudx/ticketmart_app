class HomeModel {
  final bool status;
  final String message;
  final Data data;

  HomeModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final List<ComedyShow> comedyShows;

  Data({required this.comedyShows});

  factory Data.fromJson(Map<String, dynamic> json) {
    var list = json['comedy_shows'] as List? ?? [];
    List<ComedyShow> shows =
        list.map((item) => ComedyShow.fromJson(item)).toList();
    return Data(comedyShows: shows);
  }
}

class ComedyShow {
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
  final DateTime createdAt;
  final DateTime updatedAt;

  ComedyShow({
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

  factory ComedyShow.fromJson(Map<String, dynamic> json) {
    return ComedyShow(
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
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
