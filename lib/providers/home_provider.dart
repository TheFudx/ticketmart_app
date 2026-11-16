import 'package:flutter/material.dart';
import 'package:ticketmart/model/home/home_model.dart';
import 'package:ticketmart/model/invitation/invitation_model.dart';

import '../repository/home_respository.dart';
import '../repository/invitation/invitation_repository.dart';

class HomeProvider with ChangeNotifier {
  List<ComedyShow?> _comedyShow = [];
  InvitationBannerModel? _invitationBanner;
  bool _isLoading = true;

  List<ComedyShow?> get comedyShow => _comedyShow;
  InvitationBannerModel? get invitationBanner => _invitationBanner;
  bool get isLoading => _isLoading;

  Future<void> fetchData({bool refresh = false}) async {
    if (!_isLoading && !refresh) return;

    if (refresh) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final homeData = await HomeRespository.fetchHomeData();
      _comedyShow = homeData.data.comedyShows;
      _invitationBanner = homeData.data.invitationBanner;

      // If home-page did not have invitationBanner or was empty, fetch via dedicated banner API
      if (_invitationBanner == null) {
        _invitationBanner = await InvitationRepository.fetchBanner();
      }
    } catch (e) {
      debugPrint('Error fetching home data: $e');
      try {
        _invitationBanner = await InvitationRepository.fetchBanner();
      } catch (_) {}
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
