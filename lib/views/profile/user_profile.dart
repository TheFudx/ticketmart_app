import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketmart/views/show/widget/show_widget.dart';

import '../../model/login/login_response.dart';
import '../../model/profile/profile_res_model.dart';
import '../../providers/user_provider.dart';
import '../../repository/profile/user_profile.dart';
import '../../utils/date_utils.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User? user;
  List<ComedyShowBooking> shows = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final data = await UserProfileRespository.fetchProfile();
      setState(() {
        shows = data.data.comedyShowsBooking;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = context.watch<UserProvider>().user;
  }

  @override
  Widget build(BuildContext context) {
    final allSeats = shows
        .expand((shows) => shows.bookings as List)
        .expand((booking) => booking.seats as List)
        .expand((seatGroup) => seatGroup.seats as List)
        .cast<String>()
        .toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email: ${user!.email}"),
              gap5,
              Text("Mobile Number: ${user!.mobile}"),
              gap10,
              const Center(
                child: Text(
                  "Booking History",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              gap10,
              ...shows.map((show) => SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gap5,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
