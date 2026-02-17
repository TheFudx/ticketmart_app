// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/razorpay_service.dart';
import '../../model/login/login_response.dart';
import '../../model/seat/seat_layout_res.dart';
import '../../model/ticket/ticket_request.dart';
import '../../model/ticket/ticket_response.dart';
import '../../providers/user_provider.dart';
import '../../utils/api_string.dart';
import '../../utils/app_colors.dart';
import '../home/drawer/home_screen.dart';
import 'widget/book_summary.dart';
import 'widget/show_widget.dart';

class BookedSeatDetail extends StatelessWidget {
  final List<Cseat> selectedSeats;
  final Showtimes showTime;

  BookedSeatDetail(
      {super.key, required this.selectedSeats, required this.showTime});
  final RazorpayService razorpayService = RazorpayService();

  double calculateTax(double amount) => amount * 0.09;

  void startPayment(BuildContext context, double grandTotal, User userData,
      String seatNumber) async {
    final razorpay = razorpayService.razorpay;

    razorpayService.openCheckout(
      amount: grandTotal,
      name: "Ticket Booking",
      contact: userData.mobile,
      email: userData.email,
    );

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse response) async {
      TicketRequest request = TicketRequest(
          email: userData.email,
          mobile: userData.mobile,
          showtimeId: showTime.id!,
          seats: seatNumber,
          amount: grandTotal,
          razorpayPaymentId: response.paymentId,
          razorpayOrderId: response.orderId,
          razorpaySignature: response.signature);

      final resp = await http.post(
        Uri.parse(ApiString.paymentSucces),
        headers: ApiString.header,
        body: jsonEncode(request.toJson()),
      );

      razorpay.clear();
      if (resp.statusCode != 200) {
        showErrorDialog(context, "Ticket Booking", "Unable book ticket");
        return;
      }
      final ticketResponse = TicketResponse.fromJson(jsonDecode(resp.body));
      if (!ticketResponse.status) {
        showErrorDialog(
            context, "Ticket Booking", "Unable to fetch ticket from server");
        return;
      }

      showSuccessDialog(
          context, "Payment Successful", "Payment ID: ${response.paymentId}",
          () {
        downloadTicket(ticketResponse.data.ticketPdfUrl);
        Get.offAll(() => const HomeScreen());
      });
    });

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse response) {
      showErrorDialog(context, "Payment Failed",
          "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");

      razorpay.clear();
    });

    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
        (ExternalWalletResponse response) {
      showErrorDialog(
          context, "External Wallet Selected", "${response.walletName}");
      razorpay.clear();
    });
  }

  void showSuccessDialog(BuildContext context, String title, String message,
      VoidCallback onDownload) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              onDownload();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.confirmBtn,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10))),
            child: const Text(
              "⬇️ Download Ticket",
              style: TextStyle(color: AppColors.colorWhite),
            ),
          ),
        ],
      ),
    );
  }

  void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Future<void> downloadTicket(String bookUrl) async {
    final url = Uri.parse(bookUrl);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch ticket URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    const double convenienceFee = 0;

    final groupSeats = groupSeatsPrice(selectedSeats);

    final ticketTotal =
        selectedSeats.fold(0.0, (sum, seat) => sum + int.parse(seat.price));
    final cgst = calculateTax(ticketTotal);
    final sgst = calculateTax(ticketTotal);

    final grandTotal = ticketTotal + cgst + sgst + convenienceFee;
    final user = context.watch<UserProvider>().user;
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
                        startPayment(context, grandTotal, user!, seatNumber);
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
