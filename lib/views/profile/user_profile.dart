import 'package:flutter/material.dart';
import 'package:ticketmart/views/show/widget/show_widget.dart';

import '../../model/profile/profile_res_model.dart';
import '../../repository/profile/user_profile.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_string.dart';
import '../../utils/date_utils.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List<ComedyShowBooking> shows = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final data = await UserProfileRespository.fetchProfile();

    setState(() {
      shows = data.data.comedyShowsBooking;
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Booking History",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              gap5,
              ...shows.map((show) {
                final eventStatus = isTodayOrFuture(show.showDate);
                final allSeats = show.bookings
                    .expand((booking) => booking.seats as List)
                    .expand((seatGroup) => seatGroup.seats as List)
                    .cast<String>()
                    .toList();

                return eventStatus
                    ? SizedBox(
                        width: double.infinity,
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 7.5),
                          elevation: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                gap5,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "Date: ${getFormattedDate(show.showDate.toString())}"),
                                    Text("Time: ${show.startTime}"),
                                  ],
                                ),
                                gap10,
                                Text('Show Name: ${show.showTitle}'),
                                gap10,
                                Text(
                                  "Seats: ${allSeats.join(", ")}",
                                ),
                                gap10,
                                Center(
                                  child: Text(
                                    eventStatus
                                        ? AppString.upcomingTxt
                                        : AppString.completedTxt,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: eventStatus
                                          ? AppColors.upcomingTxtColor
                                          : AppColors.colorRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox();
              })
            ],
          ),
        ),
      ),
    );
  }
}
