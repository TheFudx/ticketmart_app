import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(HomeState()) {
    on<NavigateToHome>((event, emit) => emit(HomeState()));
    on<NavigateToSearch>((event, emit) => emit(SearchState()));
    on<NavigateTooffers>((event, emit) => emit(OffersState()));
    on<NavigateToProfile>((event, emit) => emit(ProfileState()));
  }
}
