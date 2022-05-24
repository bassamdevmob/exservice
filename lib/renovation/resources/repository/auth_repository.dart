import 'package:exservice/renovation/models/request/register_request.dart';
import 'package:exservice/renovation/models/response/auth_response.dart';
import 'package:exservice/renovation/models/response/check_account_response.dart';
import 'package:exservice/renovation/models/response/session_response.dart';
import 'package:exservice/renovation/resources/api_client.dart';
import 'package:exservice/renovation/resources/links.dart';

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
