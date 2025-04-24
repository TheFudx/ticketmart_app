import 'movies.dart';

class MovieModel {
  List<Movies>? movies;

  MovieModel({this.movies});

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      movies: json['movies'] != null
          ? (json['movies'] as List).map((v) => Movies.fromJson(v)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movies': movies?.map((v) => v.toJson()).toList(),
    };
  }
}
