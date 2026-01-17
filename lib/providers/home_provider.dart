import 'package:flutter/material.dart';
import 'package:ticketmart/model/home/home_model.dart';

import '../repository/home_respository.dart';

class HomeProvider with ChangeNotifier {
  List<ComedyShow?> _comedyShow = [];
  bool _isLoading = true;

  List<ComedyShow?> get comedyShow => _comedyShow;
  bool get isLoading => _isLoading;

  Future<void> fetchData() async {
    if (!_isLoading) return;

    _comedyShow = await HomeRespository.homeProvider();
    _isLoading = false;
    notifyListeners();
  }
}
