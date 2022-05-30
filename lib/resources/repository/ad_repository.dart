import 'package:exservice/models/request/edit_ad_request.dart';
import 'package:exservice/models/response/ad_details_response.dart';
import 'package:exservice/models/response/ads_response.dart';
import 'package:exservice/models/response/bit_response.dart';
import 'package:exservice/models/response/home_response.dart';
import 'package:exservice/models/response/profile_response.dart';
import 'package:exservice/models/response/simple_response.dart';
import 'package:exservice/resources/api_client.dart';
import 'package:exservice/resources/links.dart';
import 'package:exservice/utils/enums.dart';

class AdRepository extends BaseClient {

  Future<HomeResponse> home() async {
    final response = await client.get(
      Links.HOME_URL,
    );
    return HomeResponse.fromJson(response.data);
  }

  Future<SimpleResponse> delete(int id) async {
    final response = await client.delete(
      Links.AD_URL,
    );
    return SimpleResponse.fromJson(response.data);
  }

  Future<BitResponse> bookmark(int id, bool value) async {
    final response = await client.post(Links.BOOKMARK_AD_URL, data: {
      "value": value,
    });
    return BitResponse.fromJson(response.data);
  }

  Future<AdsResponse> ads({int categoryId}) async {
    final response = await client.get(
      Links.AD_URL,
      queryParameters: {
        "category_id": categoryId,
      },
    );
    return AdsResponse.fromJson(response.data);
  }

  Future<AdsResponse> bookmarkedAds({String nextUrl}) async {
    final response = await client.get(
      nextUrl ?? Links.AD_URL,
    );
    return AdsResponse.fromJson(response.data);
  }

  Future<AdsResponse> userAds(AdStatus status) async {
    final response = await client.get(
      Links.AD_URL,
    );
    return AdsResponse.fromJson(response.data);
  }

  Future<AdDetailsResponse> view(int id) async {
    final response = await client.get(
      "${Links.AD_URL}/$id",
    );
    return AdDetailsResponse.fromJson(response.data);
  }

  Future<AdDetailsResponse> editAd(int id, EditAdRequest request) async {
    final response = await client.put(
      "${Links.AD_URL}/$id",
      data: request.toJson(),
    );
    return AdDetailsResponse.fromJson(response.data);
  }

  Future<AdsResponse> changeAdStatus(int id, AdStatus status) async {
    final response = await client.put(
      Links.CHANGE_AD_URL,
      data: {
        "id": id,
        "status": status.name,
      },
    );
    return AdsResponse.fromJson(response.data);
  }

  Future<ProfileResponse> publisher(int id) async {
    final response = await client.get("${Links.PUBLISHER_URL}/$id");
    return ProfileResponse.fromJson(response.data);
  }
}
