class SeatLayoutRequest {
  final int id;
  final int showtimeId;
  final int stageId;

  SeatLayoutRequest({
    required this.id,
    required this.showtimeId,
    required this.stageId,
  });

  factory SeatLayoutRequest.fromJson(Map<String, dynamic> json) {
    return SeatLayoutRequest(
      id: json['id'] ?? 0,
      showtimeId: json['showtime_id'] ?? 0,
      stageId: json['stage_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'showtime_id': showtimeId,
        'stage_id': stageId,
      };
}
