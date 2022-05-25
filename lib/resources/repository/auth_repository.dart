import 'package:exservice/models/request/register_request.dart';
import 'package:exservice/models/request/reset_password_request.dart';
import 'package:exservice/models/response/auth_response.dart';
import 'package:exservice/models/response/check_account_response.dart';
import 'package:exservice/models/response/session_response.dart';
import 'package:exservice/models/response/simple_response.dart';
import 'package:exservice/resources/api_client.dart';
import 'package:exservice/resources/links.dart';

class AuthRepository extends BaseClient {
  Future<AuthResponse> login(String account, String password) async {
    final response = await client.post(
      Links.LOGIN_URL,
      data: {
        "account": account,
        "password": password,
      },
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<SessionResponse> register(RegisterRequest request) async {
    final response = await client.post(
      Links.REGISTER_URL,
      data: request.toJson(),
    );
    return SessionResponse.fromJson(response.data);
  }

  Future<SessionResponse> forgetPassword(String account) async {
    final response = await client.post(
      Links.FORGET_PASSWORD_URL,
      data: {
        "account": account,
      },
    );
    return SessionResponse.fromJson(response.data);
  }

  Future<SimpleResponse> resetPassword(ResetPasswordRequest request) async {
    final response = await client.post(
      Links.RESET_PASSWORD_URL,
      data: request.toJson(),
    );
    return SimpleResponse.fromJson(response.data);
  }

  Future<AuthResponse> verify(String session, String code) async {
    final response = await client.post(
      Links.VERIFY_URL,
      data: {
        "session": session,
        "code": code,
      },
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<SessionResponse> resendVerificationCode(String session) async {
    final response = await client.post(
      Links.RESEND_URL,
      data: {
        "session": session,
      },
    );
    return SessionResponse.fromJson(response.data);
  }

  Future<CheckAccountResponse> checkAccount(String account) async {
    final response = await client.post(
      Links.CHECK_ACCOUNT_URL,
      data: {
        "account": account,
      },
    );
    return CheckAccountResponse.fromJson(response.data);
  }
}
