class Movies {
  String? id;
  String? imagePath;
  String? bannerImagePath;
  String? rating;
  String? title;
  String? description;
  String? genre;
  String? duration;
  String? releaseDate;
  String? cast;

  Movies({
    this.id,
    this.imagePath,
    this.bannerImagePath,
    this.rating,
    this.title,
    this.description,
    this.genre,
    this.duration,
    this.releaseDate,
    this.cast,
  });

  factory Movies.fromJson(Map<String, dynamic> json) {
    return Movies(
      id: json['id'],
      imagePath: json['image_path'],
      bannerImagePath: json['banner_image_path'],
      rating: json['rating'],
      title: json['title'],
      description: json['description'],
      genre: json['genre'],
      duration: json['duration'],
      releaseDate: json['release_date'],
      cast: json['cast'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_path': imagePath,
      'banner_image_path': bannerImagePath,
      'rating': rating,
      'title': title,
      'description': description,
      'genre': genre,
      'duration': duration,
      'release_date': releaseDate,
      'cast': cast,
    };
  }
}
