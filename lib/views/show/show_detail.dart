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
  final ComedyShow? comedyShow;
  const ShowDetail(this.comedyShow, {super.key});

  @override
  State<ShowDetail> createState() => _ShowDetailState();
}

class _ShowDetailState extends State<ShowDetail> {
  late ComedyShow comedyShowModel;

  Showtime? selectedShow;

  @override
  void initState() {
    super.initState();
    comedyShowModel = widget.comedyShow!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: seatAppBar(comedyShowModel.title),
      body: SafeArea(
        child: Column(
          children: [
            Image.network(
              widget.comedyShow!.bannerImagePath,
              width: double.infinity,
              height: SizeBanner.comedyBannerHeg,
              fit: BoxFit.fill,
            ),
            gap10,
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
                  final dateDay = getFormatDayDate(selectedShow?.date);

                  return SingleChildScrollView(
                    child: Column(
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
                                  selectedColor: AppColors.unSelBGTxt,
                                  showCheckmark: false,
                                  disabledColor: AppColors.colorWhite,
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? AppColors.selDatTxt
                                        : AppColors.unSelDatTxt,
                                  ),
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),

                                gap10,
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
                                      dateDay,
                                      style: const TextStyle(fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                gap10,
                                intrinHeight(
                                    genre: comedyShowModel.genre,
                                    duration: formatMinuToHour(
                                        comedyShowModel.duration),
                                    language: comedyShowModel.language),

                                gap10,
                                const Text(
                                  AppString.mumbaiTxt,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                const Text(
                                  AppString.officeAddTxt,
                                  style: TextStyle(fontSize: 12),
                                ),

                                gap10,
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => Get.to(() => SeatLayout(
                                        selectedShow!.showId,
                                        selectedShow!.id,
                                        selectedShow!.stageId)),
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

                                gap5,
                                h1Txt(AppString.aboutShowtxt),

                                Html(
                                  data: widget.comedyShow!.description,
                                  shrinkWrap: true,
                                ),

                                h1Txt(AppString.whyToAttend),

                                gap5,
                                planTxt1(AppString.t1Txt),

                                gap5,
                                planTxt1(AppString.t2Txt),

                                gap5,
                                planTxt1(AppString.t3Txt),
                              ],
                            ),
                          )
                        else
                          const Center(child: Text(AppString.bookingOverTxt)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
