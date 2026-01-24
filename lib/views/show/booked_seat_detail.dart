import 'package:flutter/material.dart';
import '../../model/seat/seat_layout_res.dart';
import '../../utils/app_assets.dart';
import '../../utils/date_utils.dart';

class BookedSeatDetail extends StatelessWidget {
  final List<Cseat> seatDeatil;
  final Showtimes showTime;

  const BookedSeatDetail(
      {super.key, required this.seatDeatil, required this.showTime});

  @override
  Widget build(BuildContext context) {
    final String date = getFormattedDate(showTime.date);
    final String time = convert12Format(showTime.startTime);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details '),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Image.asset(
                        AppAssets.comedyBannerImg,
                        height: 220,
                        width: 110,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text("Alpha Comedy Unplugged Season 2"),
                          SizedBox(height: 10),
                          Text("$date, $time"),
                          SizedBox(height: 10),
                          Text("Seats wish to Book",style: TextStyle(color: ),),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
