import 'package:exservice/models/response/categories_response.dart';
import 'package:exservice/resources/api_client.dart';
import 'package:exservice/resources/links.dart';

class ConfigRepository extends BaseClient {
  Future<CategoriesResponse> categories() async {
    final response = await client.get(Links.CATEGORIES_URL);
    return CategoriesResponse.fromJson(response.data);
  }
}
