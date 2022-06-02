import 'package:exservice/models/request/change_password_request.dart';
import 'package:exservice/models/request/edit_profile_request.dart';
import 'package:exservice/models/response/ads_response.dart';
import 'package:exservice/models/response/chats_response.dart';
import 'package:exservice/models/response/notifications_response.dart';
import 'package:exservice/models/response/profile_response.dart';
import 'package:exservice/models/response/session_response.dart';
import 'package:exservice/models/response/simple_response.dart';
import 'package:exservice/resources/api_client.dart';
import 'package:exservice/resources/links.dart';

class UserRepository extends BaseClient {
  Future<SimpleResponse> contactUs(String title, String content) async {
    final response = await client.get(Links.CONTACT_US_URL);
    return SimpleResponse.fromJson(response.data);
  }

  Future<ProfileResponse> getProfile() async {
    final response = await client.get(Links.PROFILE_URL);
    return ProfileResponse.fromJson(response.data);
  }

  Future<ChatsResponse> chats() async {
    final response = await client.get(Links.CHATS_URL);
    return ChatsResponse.fromJson(response.data);
  }

  Future<AdsResponse> ads({
    String nextUrl,
    List<String> status,
  }) async {
    final response = await client.get(
      nextUrl ?? Links.AD_URL,
      queryParameters: {
        "status": status,
      },
    );
    return AdsResponse.fromJson(response.data);
  }

  Future<SimpleResponse> changePassword(ChangePasswordRequest request) async {
    final response = await client.put(
      Links.PASSWORD_URL,
      data: request.toJson(),
    );
    return SimpleResponse.fromJson(response.data);
  }

  Future<ProfileResponse> updateProfile(EditProfileRequest request) async {
    final response = await client.put(
      Links.PROFILE_URL,
      data: await request.toFormData(),
    );
    return ProfileResponse.fromJson(response.data);
  }

  Future<SessionResponse> updatePhoneNumber({
    String phoneNumber,
    String password,
  }) async {
    final response = await client.put(
      Links.PHONE_NUMBER_URL,
      data: {
        "phone_number": phoneNumber,
        "password": password,
      },
    );
    return SessionResponse.fromJson(response.data);
  }

  Future<SessionResponse> updateEmail({
    String email,
    String password,
  }) async {
    final response = await client.put(
      Links.EMAIL_URL,
      data: {
        "email": email,
        "password": password,
      },
    );
    return SessionResponse.fromJson(response.data);
  }

  Future<SessionResponse> resendVerificationCode(String session) async {
    final response = await client.post(
      Links.USER_RESEND_URL,
      data: {
        "session": session,
      },
    );
    return SessionResponse.fromJson(response.data);
  }

  Future<ProfileResponse> verify(String session, String code) async {
    final response = await client.post(
      Links.USER_VERIFY_URL,
      data: {
        "session": session,
        "code": code,
      },
    );
    return ProfileResponse.fromJson(response.data);
  }

  Future<NotificationsResponse> notifications() async {
    final response = await client.get(Links.NOTIFICATION_URL);
    return NotificationsResponse.fromJson(response.data);
  }
}
