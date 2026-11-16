import 'package:flutter_test/flutter_test.dart';
import 'package:ticketmart/model/invitation/invitation_model.dart';

void main() {
  group('VIP Invitation Models', () {
    test('InvitationBannerModel parses from JSON correctly', () {
      final json = {
        "has_active_invitation": true,
        "event_id": 1,
        "event_slug": "alphaneon-studioz-slate-revel-CnXina",
        "title": "Alphaneon Studioz Slate Revel",
        "subtitle": "Exclusive Grand Unveiling Event",
        "banner_image_url": "https://ticketmart.co/uploads/invitations/templates/poster.jpg",
        "web_redirect_url": "https://ticketmart.co/invite/alphaneon-studioz-slate-revel-CnXina",
        "event_date": "2026-10-26 19:00:00",
        "event_date_formatted": "26 Oct 2026, 07:00 PM",
        "venue_name": "Taj Lands End, Bandra",
        "venue_address": "Bandstand, BJ Road, Bandra West, Mumbai",
        "organiser_name": "Alphaneon Studioz Private Limited"
      };

      final banner = InvitationBannerModel.fromJson(json);

      expect(banner.hasActiveInvitation, true);
      expect(banner.eventId, 1);
      expect(banner.eventSlug, "alphaneon-studioz-slate-revel-CnXina");
      expect(banner.title, "Alphaneon Studioz Slate Revel");
      expect(banner.eventDateFormatted, "26 Oct 2026, 07:00 PM");
      expect(banner.venueName, "Taj Lands End, Bandra");
    });

    test('InvitationVerifyResponse parses invited guest response', () {
      final json = {
        "status": true,
        "is_invited": true,
        "message": "Welcome! You are on the VIP guest list.",
        "guest": {
          "id": 6,
          "name": "Dr. Amit Upadhyay",
          "phone": "9820011223",
          "email": "amit.upadhyay@alphaneon.com",
          "category": "VVIP",
          "category_badge_class": "bg-danger",
          "table_section": "Royal Lounge A",
          "accompanying_guests": 1,
          "total_heads": 2,
          "companions": [
            {
              "name": "Sagar Panchmatiya",
              "phone": ""
            }
          ],
          "check_in_status": "pending",
          "is_checked_in": false
        },
        "card": {
          "card_image_url": "https://ticketmart.co/uploads/invitations/cards/card.jpg",
          "pdf_download_url": "https://ticketmart.co/api/v1/invitations/events/slug/card/download?token=abc",
          "qr_token": "WrXZxGWqQMQLGZxvoPVFLbQa2xnWse1s",
          "qr_image_url": "https://ticketmart.co/api/v1/invitations/qr/abc",
          "qr_scan_verification_url": "https://ticketmart.co/invitation/scan/abc"
        },
        "event": {
          "id": 1,
          "name": "Alphaneon Studioz Slate Revel",
          "slug": "alphaneon-studioz-slate-revel-CnXina",
          "event_date": "2026-10-26 19:00:00",
          "event_date_formatted": "26 Oct 2026, 07:00 PM",
          "venue_name": "Taj Lands End, Bandra",
          "venue_address": "Bandstand, BJ Road, Bandra West, Mumbai",
          "organiser_name": "Alphaneon Studioz Private Limited",
          "personal_message": "Join us as we unveil our next big story."
        },
        "auth": {
          "token": "781|vUPWKlQc9JSwYJnUhltqcFaz",
          "token_type": "Bearer",
          "user_id": 1015
        }
      };

      final response = InvitationVerifyResponse.fromJson(json);

      expect(response.status, true);
      expect(response.isInvited, true);
      expect(response.guest?.name, "Dr. Amit Upadhyay");
      expect(response.guest?.category, "VVIP");
      expect(response.guest?.companions.length, 1);
      expect(response.guest?.companions.first.name, "Sagar Panchmatiya");
      expect(response.card?.qrToken, "WrXZxGWqQMQLGZxvoPVFLbQa2xnWse1s");
      expect(response.auth?.token, "781|vUPWKlQc9JSwYJnUhltqcFaz");
    });

    test('InvitationVerifyResponse parses uninvited response correctly', () {
      final json = {
        "status": false,
        "is_invited": false,
        "error_code": "NOT_INVITED",
        "phone": "+919999999999",
        "message": "Your mobile number (+919999999999) was verified successfully, but is not on the guest list for this private event. Please contact the event host."
      };

      final response = InvitationVerifyResponse.fromJson(json);

      expect(response.status, false);
      expect(response.isInvited, false);
      expect(response.errorCode, "NOT_INVITED");
      expect(response.message, contains("not on the guest list"));
    });

    test('InvitationSendOtpResponse parses successfully for invited guest', () {
      final json = {
        "status": true,
        "is_invited": true,
        "message": "Verification pass-code sent for Dr. Amit Upadhyay.",
        "guest_name": "Dr. Amit Upadhyay",
        "phone": "+919820011223",
        "otp_sent": true,
        "expires_in_minutes": 10,
        "debug_otp": "675518"
      };

      final response = InvitationSendOtpResponse.fromJson(json);

      expect(response.status, true);
      expect(response.isInvited, true);
      expect(response.otpSent, true);
      expect(response.guestName, "Dr. Amit Upadhyay");
      expect(response.phone, "+919820011223");
      expect(response.expiresInMinutes, 10);
      expect(response.debugOtp, "675518");
    });

    test('Phone.email auth URL and token parsing works properly', () {
      const clientId = '13889200858715854466';
      const slug = 'alphaneon-studioz-slate-revel-CnXina';
      final redirect = Uri.encodeComponent('https://ticketmart.co/invite/$slug');

      final authUrl = 'https://auth.phone.email/log-in'
          '?client_id=$clientId'
          '&auth_type=1'
          '&redirect_url=$redirect';

      final uri = Uri.parse(authUrl);
      expect(uri.host, 'auth.phone.email');
      expect(uri.queryParameters['client_id'], clientId);
      expect(uri.queryParameters['auth_type'], '1');
      expect(uri.queryParameters['redirect_url'], contains(slug));

      // Test token extraction
      final redirectWithToken = 'https://ticketmart.co/invite/$slug?access_token=sample_token_123';
      final parsed = Uri.parse(redirectWithToken);
      expect(parsed.queryParameters['access_token'], 'sample_token_123');

      final userJsonUrl = 'https://user.phone.email/user_${parsed.queryParameters['access_token']}.json';
      expect(userJsonUrl, 'https://user.phone.email/user_sample_token_123.json');
    });
  });
}
