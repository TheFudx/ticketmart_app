class InvitationBannerModel {
  final bool hasActiveInvitation;
  final int eventId;
  final String eventSlug;
  final String title;
  final String subtitle;
  final String bannerImageUrl;
  final String webRedirectUrl;
  final String eventDate;
  final String? eventDateFormatted;
  final String venueName;
  final String? venueAddress;
  final String? organiserName;

  InvitationBannerModel({
    required this.hasActiveInvitation,
    required this.eventId,
    required this.eventSlug,
    required this.title,
    required this.subtitle,
    required this.bannerImageUrl,
    required this.webRedirectUrl,
    required this.eventDate,
    this.eventDateFormatted,
    required this.venueName,
    this.venueAddress,
    this.organiserName,
  });

  factory InvitationBannerModel.fromJson(Map<String, dynamic> json) {
    return InvitationBannerModel(
      hasActiveInvitation: json['has_active_invitation'] ?? false,
      eventId: json['event_id'] is int
          ? json['event_id']
          : int.tryParse(json['event_id']?.toString() ?? '0') ?? 0,
      eventSlug: json['event_slug']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      bannerImageUrl: json['banner_image_url']?.toString() ?? '',
      webRedirectUrl: json['web_redirect_url']?.toString() ?? '',
      eventDate: json['event_date']?.toString() ?? '',
      eventDateFormatted: json['event_date_formatted']?.toString(),
      venueName: json['venue_name']?.toString() ?? '',
      venueAddress: json['venue_address']?.toString(),
      organiserName: json['organiser_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'has_active_invitation': hasActiveInvitation,
      'event_id': eventId,
      'event_slug': eventSlug,
      'title': title,
      'subtitle': subtitle,
      'banner_image_url': bannerImageUrl,
      'web_redirect_url': webRedirectUrl,
      'event_date': eventDate,
      'event_date_formatted': eventDateFormatted,
      'venue_name': venueName,
      'venue_address': venueAddress,
      'organiser_name': organiserName,
    };
  }
}

class InvitationEventDetails {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String eventDate;
  final String eventDateFormatted;
  final String venueName;
  final String venueAddress;
  final String organiserName;
  final String? personalMessage;
  final String bannerImageUrl;
  final String? logoImageUrl;
  final String? webInviteUrl;

  InvitationEventDetails({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.eventDate,
    required this.eventDateFormatted,
    required this.venueName,
    required this.venueAddress,
    required this.organiserName,
    this.personalMessage,
    required this.bannerImageUrl,
    this.logoImageUrl,
    this.webInviteUrl,
  });

  factory InvitationEventDetails.fromJson(Map<String, dynamic> json) {
    return InvitationEventDetails(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      eventDate: json['event_date']?.toString() ?? '',
      eventDateFormatted: json['event_date_formatted']?.toString() ?? '',
      venueName: json['venue_name']?.toString() ?? '',
      venueAddress: json['venue_address']?.toString() ?? '',
      organiserName: json['organiser_name']?.toString() ?? '',
      personalMessage: json['personal_message']?.toString(),
      bannerImageUrl: json['banner_image_url']?.toString() ?? '',
      logoImageUrl: json['logo_image_url']?.toString(),
      webInviteUrl: json['web_invite_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'event_date': eventDate,
      'event_date_formatted': eventDateFormatted,
      'venue_name': venueName,
      'venue_address': venueAddress,
      'organiser_name': organiserName,
      'personal_message': personalMessage,
      'banner_image_url': bannerImageUrl,
      'logo_image_url': logoImageUrl,
      'web_invite_url': webInviteUrl,
    };
  }
}

class CompanionModel {
  final String name;
  final String phone;

  CompanionModel({
    required this.name,
    required this.phone,
  });

  factory CompanionModel.fromJson(Map<String, dynamic> json) {
    return CompanionModel(
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
    };
  }
}

class GuestModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String category;
  final String categoryBadgeClass;
  final String tableSection;
  final int accompanyingGuests;
  final int totalHeads;
  final List<CompanionModel> companions;
  final String checkInStatus;
  final bool isCheckedIn;
  final String? dietPreference;

  GuestModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.category,
    required this.categoryBadgeClass,
    required this.tableSection,
    required this.accompanyingGuests,
    required this.totalHeads,
    required this.companions,
    required this.checkInStatus,
    required this.isCheckedIn,
    this.dietPreference,
  });

  factory GuestModel.fromJson(Map<String, dynamic> json) {
    var rawCompanions = json['companions'] as List? ?? [];
    List<CompanionModel> parsedCompanions = rawCompanions
        .map((c) => CompanionModel.fromJson(c as Map<String, dynamic>))
        .toList();

    return GuestModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      category: json['category']?.toString() ?? 'VIP',
      categoryBadgeClass: json['category_badge_class']?.toString() ?? 'bg-danger',
      tableSection: json['table_section']?.toString() ?? '',
      accompanyingGuests: json['accompanying_guests'] is int
          ? json['accompanying_guests']
          : int.tryParse(json['accompanying_guests']?.toString() ?? '0') ?? 0,
      totalHeads: json['total_heads'] is int
          ? json['total_heads']
          : int.tryParse(json['total_heads']?.toString() ?? '1') ?? 1,
      companions: parsedCompanions,
      checkInStatus: json['check_in_status']?.toString() ?? 'pending',
      isCheckedIn: json['is_checked_in'] ?? false,
      dietPreference: json['diet_preference']?.toString() ??
          json['diet']?.toString() ??
          'Veg',
    );
  }
}

class CardModel {
  final String cardImageUrl;
  final String pdfDownloadUrl;
  final String qrToken;
  final String qrImageUrl;
  final String qrScanVerificationUrl;
  final String? shareLink;

  CardModel({
    required this.cardImageUrl,
    required this.pdfDownloadUrl,
    required this.qrToken,
    required this.qrImageUrl,
    required this.qrScanVerificationUrl,
    this.shareLink,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      cardImageUrl: json['card_image_url']?.toString() ?? '',
      pdfDownloadUrl: json['pdf_download_url']?.toString() ?? '',
      qrToken: json['qr_token']?.toString() ?? '',
      qrImageUrl: json['qr_image_url']?.toString() ?? '',
      qrScanVerificationUrl: json['qr_scan_verification_url']?.toString() ?? '',
      shareLink: json['share_link']?.toString(),
    );
  }
}

class InvitationSendOtpResponse {
  final bool status;
  final bool isInvited;
  final String message;
  final String? guestName;
  final String? phone;
  final bool otpSent;
  final int? expiresInMinutes;
  final String? debugOtp;
  final String? errorCode;

  InvitationSendOtpResponse({
    required this.status,
    required this.isInvited,
    required this.message,
    this.guestName,
    this.phone,
    this.otpSent = false,
    this.expiresInMinutes,
    this.debugOtp,
    this.errorCode,
  });

  factory InvitationSendOtpResponse.fromJson(Map<String, dynamic> json) {
    return InvitationSendOtpResponse(
      status: json['status'] ?? false,
      isInvited: json['is_invited'] ?? false,
      message: json['message']?.toString() ?? '',
      guestName: json['guest_name']?.toString(),
      phone: json['phone']?.toString(),
      otpSent: json['otp_sent'] ?? false,
      expiresInMinutes: json['expires_in_minutes'] is int
          ? json['expires_in_minutes']
          : int.tryParse(json['expires_in_minutes']?.toString() ?? ''),
      debugOtp: json['debug_otp']?.toString(),
      errorCode: json['error_code']?.toString(),
    );
  }
}

class AuthInfo {
  final String token;
  final String tokenType;
  final int userId;

  AuthInfo({
    required this.token,
    required this.tokenType,
    required this.userId,
  });

  factory AuthInfo.fromJson(Map<String, dynamic> json) {
    return AuthInfo(
      token: json['token']?.toString() ?? '',
      tokenType: json['token_type']?.toString() ?? 'Bearer',
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
    );
  }
}

class InvitationVerifyResponse {
  final bool status;
  final bool isInvited;
  final String message;
  final String? errorCode;
  final String? phone;
  final GuestModel? guest;
  final CardModel? card;
  final InvitationEventDetails? event;
  final AuthInfo? auth;

  InvitationVerifyResponse({
    required this.status,
    required this.isInvited,
    required this.message,
    this.errorCode,
    this.phone,
    this.guest,
    this.card,
    this.event,
    this.auth,
  });

  factory InvitationVerifyResponse.fromJson(Map<String, dynamic> json) {
    return InvitationVerifyResponse(
      status: json['status'] ?? false,
      isInvited: json['is_invited'] ?? false,
      message: json['message']?.toString() ?? '',
      errorCode: json['error_code']?.toString(),
      phone: json['phone']?.toString(),
      guest: json['guest'] != null
          ? GuestModel.fromJson(json['guest'] as Map<String, dynamic>)
          : null,
      card: json['card'] != null
          ? CardModel.fromJson(json['card'] as Map<String, dynamic>)
          : null,
      event: json['event'] != null
          ? InvitationEventDetails.fromJson(json['event'] as Map<String, dynamic>)
          : null,
      auth: json['auth'] != null
          ? AuthInfo.fromJson(json['auth'] as Map<String, dynamic>)
          : null,
    );
  }
}
