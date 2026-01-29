class TicketResponse {
  final bool status;
  final String message;
  final TicketData data;

  TicketResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TicketResponse.fromJson(Map<String, dynamic> json) {
    return TicketResponse(
      status: json['status'],
      message: json['message'],
      data: TicketData.fromJson(json['data']),
    );
  }
}

class TicketData {
  final int bookingId;
  final int userId;
  final int totalAmount;
  final int totalSeats;
  final String qrCodeUrl;
  final String ticketPdfUrl;

  TicketData({
    required this.bookingId,
    required this.userId,
    required this.totalAmount,
    required this.totalSeats,
    required this.qrCodeUrl,
    required this.ticketPdfUrl,
  });

  factory TicketData.fromJson(Map<String, dynamic> json) {
    return TicketData(
      bookingId: json['booking_id'],
      userId: json['user_id'],
      totalAmount: json['total_amount'],
      totalSeats: json['total_seats'],
      qrCodeUrl: json['qr_code_url'],
      ticketPdfUrl: json['ticket_pdf_url'],
    );
  }
}
