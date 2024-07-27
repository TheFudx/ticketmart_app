// movie_details_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadTheatreCards extends MovieDetailsEvent {
  final String selectedDate;

  const LoadTheatreCards(this.selectedDate);

  @override
  List<Object> get props => [selectedDate];
}

// States
abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();

  @override
  List<Object> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class TheatreCardsLoaded extends MovieDetailsState {
  final List<String> theatreCards;

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
  MovieDetailsBloc() : super(MovieDetailsInitial());

  Stream<MovieDetailsState> mapEventToState(MovieDetailsEvent event) async* {
    if (event is LoadTheatreCards) {
      try {
        // Fetch data based on the selected date
        final theatreCards = await _fetchTheatreCards(event.selectedDate);
        yield TheatreCardsLoaded(theatreCards);
      } catch (e) {
        yield const TheatreCardsError('Failed to load theatre cards');
      }
    }
  }

  Future<List<String>> _fetchTheatreCards(String date) async {
    // Simulate fetching data
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    // This is where you would normally fetch data from an API
    return ['Card for $date'];
  }
}
