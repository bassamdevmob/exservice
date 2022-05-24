import 'package:exservice/renovation/models/response/auth_response.dart';
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

  // Future<VerificationResponse> verify(VerificationRequest request) async {
  //   final response = await client.post(
  //     Links.VERIFY_URL,
  //     data: request.toJson(),
  //   );
  //   return VerificationResponse.fromJson(response.data);
  // }
  //
  // Future<SimpleResponse> logout() async {
  //   final response = await client.get(Links.LOGOUT_URL);
  //   return SimpleResponse.fromJson(response.data);
  // }
}
