import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../model/invitation/invitation_model.dart';
import '../../utils/api_string.dart';

class InvitationRepository {
  /// Fetch the active VIP invitation banner for the home screen
  static Future<InvitationBannerModel?> fetchBanner() async {
    try {
      final response = await http.get(
        Uri.parse(ApiString.invitationBannerUrl),
        headers: ApiString.header,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == true && body['data'] != null) {
          return InvitationBannerModel.fromJson(body['data']);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching invitation banner: $e');
      return null;
    }
  }

  /// Fetch full event details by slug
  static Future<InvitationEventDetails?> fetchEventDetails(String slug) async {
    try {
      final url = ApiString.invitationEventDetailsUrl(slug);
      final response = await http.get(
        Uri.parse(url),
        headers: ApiString.header,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == true && body['data'] != null) {
          return InvitationEventDetails.fromJson(body['data']);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching invitation event details: $e');
      return null;
    }
  }

  /// Step 2a: Request OTP for VIP invitation access
  static Future<InvitationSendOtpResponse> sendOtp({
    required String slug,
    required String phone,
  }) async {
    try {
      final url = ApiString.invitationSendOtpUrl(slug);
      final response = await http.post(
        Uri.parse(url),
        headers: ApiString.header,
        body: jsonEncode({'phone': phone}),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      return InvitationSendOtpResponse.fromJson(data);
    } catch (e) {
      debugPrint('Error sending invitation OTP: $e');
      return InvitationSendOtpResponse(
        status: false,
        isInvited: false,
        message: 'Network error occurred. Please check your internet connection.',
      );
    }
  }

  /// Step 2b: Verify OTP and fetch VIP invitation card & QR code
  static Future<InvitationVerifyResponse> verifyOtp({
    required String slug,
    required String phone,
    required String otp,
  }) async {
    try {
      final url = ApiString.invitationVerifyOtpUrl(slug);
      final response = await http.post(
        Uri.parse(url),
        headers: ApiString.header,
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      return InvitationVerifyResponse.fromJson(data);
    } catch (e) {
      debugPrint('Error verifying invitation OTP: $e');
      return InvitationVerifyResponse(
        status: false,
        isInvited: false,
        message: 'Network error occurred. Please check your internet connection.',
      );
    }
  }

  /// Verify user identity & guest list status for the event
  /// Supports:
  /// - mobileNo: Direct mobile number
  /// - accessToken: Phone.email SDK access token
  /// - userJsonUrl: Phone.email user_json_url
  /// - bearerToken: Logged-in user's Sanctum token
  static Future<InvitationVerifyResponse> verifyGuest({
    required String slug,
    String? mobileNo,
    String? accessToken,
    String? userJsonUrl,
    String? bearerToken,
  }) async {
    try {
      final url = ApiString.invitationVerifyUrl(slug);

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (bearerToken != null && bearerToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $bearerToken';
      }

      final Map<String, dynamic> body = {};
      if (accessToken != null && accessToken.isNotEmpty) {
        body['access_token'] = accessToken;
      }
      if (userJsonUrl != null && userJsonUrl.isNotEmpty) {
        body['user_json_url'] = userJsonUrl;
      }
      if (mobileNo != null && mobileNo.isNotEmpty) {
        body['mobile_no'] = mobileNo;
      }

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return InvitationVerifyResponse.fromJson(responseData);
      } else if (response.statusCode == 404) {
        // Expected "NOT_INVITED" response
        return InvitationVerifyResponse.fromJson(responseData);
      } else {
        return InvitationVerifyResponse(
          status: false,
          isInvited: false,
          message: responseData['message'] ??
              'Unable to verify invitation. Please try again.',
          errorCode: responseData['error_code'],
        );
      }
    } catch (e) {
      debugPrint('Error verifying guest invitation: $e');
      return InvitationVerifyResponse(
        status: false,
        isInvited: false,
        message: 'Network error occurred. Please check your internet connection.',
      );
    }
  }

  /// Fetch card for an already logged-in user with Bearer token
  static Future<InvitationVerifyResponse> fetchMyCard(
    String slug,
    String bearerToken,
  ) async {
    try {
      final url = ApiString.invitationMyCardUrl(slug);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return InvitationVerifyResponse.fromJson(responseData);
    } catch (e) {
      debugPrint('Error fetching my card: $e');
      return InvitationVerifyResponse(
        status: false,
        isInvited: false,
        message: 'Error fetching invitation card details.',
      );
    }
  }
}
