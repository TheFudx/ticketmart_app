import 'package:flutter/material.dart';
import '../../model/seat/seat_layout_res.dart';
import '../../utils/app_colors.dart';
import 'widget/book_summary.dart';
import 'widget/show_widget.dart';

class BookedSeatDetail extends StatelessWidget {
  final List<Cseat> selectedSeats;
  final Showtimes showTime;

  const BookedSeatDetail(
      {super.key, required this.selectedSeats, required this.showTime});

  double calculateTax(double amount) => amount * 0.09;

  @override
  Widget build(BuildContext context) {
    const double convenienceFee = 0;

    final groupSeats = groupSeatsPrice(selectedSeats);

    final ticketTotal =
        selectedSeats.fold(0.0, (sum, seat) => sum + int.parse(seat.price));
    final cgst = calculateTax(ticketTotal);
    final sgst = calculateTax(ticketTotal);

    final grandTotal = ticketTotal + cgst + sgst + convenienceFee;
    final seatNumber = selectedSeats.map((e) => e.id).join(",");

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
                BookingSummaryCard(showTime: showTime, groupSeats: groupSeats),
                // Price Details
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.rowDetailsBroderColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      ...groupSeats.entries.map((entry) {
                        final total = calculateSeatTypeTotal(entry.value);

                        return priceRow(
                            "${entry.key} (${entry.value.length} Ticket)",
                            total,
                            isBold: true);
                      }),
                      priceRow("Central GST (CGST) @ 9%", cgst, amountFixed: 2),
                      priceRow("State GST (SGST) @ 9%", sgst, amountFixed: 2),
                      priceRow("Convenience Fee", convenienceFee),
                      priceRow(
                          "Total (${selectedSeats.length} Ticket)", ticketTotal,
                          isBold: true),
                      const Divider(
                          color: AppColors.dividerColor, thickness: 1.5),
                      priceRow("Grand Total", grandTotal,
                          isBold: true,
                          color: AppColors.colorBlack,
                          amountFixed: 2),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.rowDetailsBroderColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🎁 Offers Included',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      gap10,
                      ...groupSeats.entries.map(
                        (entry) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.dividerColor,
                              border: Border.all(
                                color: AppColors.rowDetailsBroderColor,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.unSelBGTxt,
                                  blurRadius: 1,
                                  offset: Offset(0, 2),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: TextStyle(
                                          color: getColorForType(entry.key)),
                                    ),
                                    Text(
                                        "${entry.value.length.toString()} Ticket"),
                                  ],
                                ),
                                gap10,
                                returnValue(entry.key),
                                gap10,
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.confirmBtn,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                      onPressed: () {
                        // Navigate to payment
                      },
                      child: const Text(
                        "Proceed to Pay",
                        style: TextStyle(color: AppColors.colorWhite),
                      ),
                    ),
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
