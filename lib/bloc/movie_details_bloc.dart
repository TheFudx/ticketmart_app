import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ticketmart/api_connection.dart'; // Ensure this path is correct

// Events
abstract class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadTheatreCards extends MovieDetailsEvent {
  final String date;
  final String movieId;

  const LoadTheatreCards(this.date, this.movieId);

  @override
  List<Object> get props => [date, movieId];
}

// States
abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();

  @override
  List<Object> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class TheatreCardsLoaded extends MovieDetailsState {
  final List<Map<String, dynamic>> theatreCards;

  const TheatreCardsLoaded(this.theatreCards);

  @override
  List<Object> get props => [theatreCards];
}

class TheatreCardsError extends MovieDetailsState {
  final String message;

  const TheatreCardsError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  MovieDetailsBloc() : super(MovieDetailsInitial()) {
    on<LoadTheatreCards>(_onLoadTheatreCards);
  }

  Future<void> _onLoadTheatreCards(
    LoadTheatreCards event,
    Emitter<MovieDetailsState> emit,
  ) async {
    try {
      final theatreCards = await ApiConnection.fetchScreens(event.movieId);
      emit(TheatreCardsLoaded(theatreCards));
    } catch (e) {
      emit(TheatreCardsError(e.toString()));
    }
  }
}
