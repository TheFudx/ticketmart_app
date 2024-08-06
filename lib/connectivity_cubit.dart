import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityCubit extends Cubit<bool> {
  ConnectivityCubit() : super(true) {
    _startListening();
  }

  final Connectivity _connectivity = Connectivity();

  void _startListening() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      emit(result != ConnectivityResult.none);
    } as void Function(List<ConnectivityResult> event)?);
  }
}
