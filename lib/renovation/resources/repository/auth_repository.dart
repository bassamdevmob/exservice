// import 'package:kiosk/model/request/verification_request.dart';
// import 'package:kiosk/model/response/auth_response.dart';
// import 'package:kiosk/model/response/simple_response.dart';
// import 'package:kiosk/model/response/verification_response.dart';
// import 'package:kiosk/resource/api_client.dart';
// import 'package:kiosk/resource/links.dart';
//
// class AuthRepository extends BaseClient {
//   Future<AuthResponse> login(String mobileNumber, String countyCode) async {
//     final response = await client.post(
//       Links.LOGIN_URL,
//       data: {
//         "msisdn": mobileNumber,
//         "country_code": countyCode,
//       },
//     );
//     return AuthResponse.fromJson(response.data);
//   }
//
//   Future<VerificationResponse> verify(VerificationRequest request) async {
//     final response = await client.post(
//       Links.VERIFY_URL,
//       data: request.toJson(),
//     );
//     return VerificationResponse.fromJson(response.data);
//   }
//
//   Future<SimpleResponse> logout() async {
//     final response = await client.get(Links.LOGOUT_URL);
//     return SimpleResponse.fromJson(response.data);
//   }
//
//   Future subscribe(String mobileNumber) async {}
//
//   Future finishProfile(String fullName, String email) async {}
// }
