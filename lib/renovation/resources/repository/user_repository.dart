// import 'package:kiosk/model/response/profile_response.dart';
// import 'package:kiosk/resource/api_client.dart';
// import 'package:kiosk/resource/links.dart';
//
// class UserRepository extends BaseClient {
//   Future<ProfileResponse> getProfile() async {
//     final response = await client.get(Links.SUBSCRIBER_URL);
//     return ProfileResponse.fromJson(response.data);
//   }
//
//   Future<ProfileResponse> updateProfile({String? name, String? email}) async {
//     final response = await client.put(
//       Links.SUBSCRIBER_URL,
//       data: {
//         "name": name,
//         "email": email,
//       },
//     );
//     return ProfileResponse.fromJson(response.data);
//   }
//
//   Future contactUs(String title, String content) async {}
// }
