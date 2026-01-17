import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticketmart/model/home/home_model.dart';
import 'package:ticketmart/views/show/seat_layout.dart';
import '../../model/home/show_model.dart';
import '../../repository/home_respository.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_string.dart';
import '../../utils/date_utils.dart';
import 'widget/show_widget.dart';
import 'package:flutter_html/flutter_html.dart';

class ShowDetail extends StatefulWidget {
  final ComedyShow? comedyShowModel;
  const ShowDetail(this.comedyShowModel, {super.key});

  @override
  State<ShowDetail> createState() => _ShowDetailState();
}

class _ShowDetailState extends State<ShowDetail> {
  late ComedyShow comedyShowModel;
  late List<Showtime?> showtimeModel = [];
  Showtime? selectedShow;

  @override
  void initState() {
    super.initState();
    comedyShowModel = widget.comedyShowModel!;
    fetchShowtimes(comedyShowModel.id);
  }

  void fetchShowtimes(int showId) async {
    final data = await HomeRespository.fetchShowtimes(showId);

    setState(() {
      showtimeModel = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: seatAppBar(comedyShowModel.title),
      body: Column(
        children: [
          Image.network(
            widget.comedyShowModel!.bannerImagePath,
            width: double.infinity,
            height: SizeBanner.comedyBannerHeg,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
              future: HomeRespository.fetchShowtimes(comedyShowModel.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }
                final showtimes = snapshot.data!;

                return Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: showtimes.length,
                        itemBuilder: (context, index) {
                          final show = showtimes[index];
                          final isSelected = selectedShow?.id == show!.id;
                          final date = getFormattedDate(show.date);

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ChoiceChip(
                              label: Text(date),
                              selected: isSelected,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onSelected: (_) {
                                setState(() {
                                  selectedShow = show;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    if (selectedShow != null && !selectedShow!.isDone)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comedyShowModel.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            const SizedBox(
                              height: 10,
                            ),

                            // Location Name and Date
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: AppColors.locationColor),
                                const Text(
                                  AppString.locationNameTxt,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.locationColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                const Icon(Icons.calendar_month_rounded),
                                Text(
                                  getFormattedDate(selectedShow?.date),
                                  style: const TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        showTimeDuration(
                                          icon: Icons.category,
                                          t1: AppString.categoryTxt,
                                          t2: comedyShowModel.genre,
                                        ),
                                        showTimeDuration(
                                          icon: Icons.timer,
                                          t1: AppString.durationTxt,
                                          t2: comedyShowModel.duration
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Flexible(
                                    child: VerticalDivider(
                                      thickness: 2,
                                      width: 10,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        showTimeDuration(
                                          icon: Icons.language,
                                          t1: AppString.langTxt,
                                          t2: comedyShowModel.language,
                                        ),
                                        showTimeDuration(
                                          icon: Icons.people_alt,
                                          t1: AppString.ageLimitTxt,
                                          t2: AppString.age18addTxt,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            const Text(
                              AppString.mumbaiTxt,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              AppString.officeAddTxt,
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 10),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(() => const SeatLayout(3, 7, 2));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.confirmBtn,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  AppString.bookNowTxt,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),

                            Html(
                              data: widget.comedyShowModel!.description,
                              shrinkWrap: true,
                            ),
                          ],
                        ),
                      )
                    else
                      const Center(child: Text(AppString.bookingOverTxt)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
