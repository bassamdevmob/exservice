import 'package:exservice/models/response/config_response.dart';
import 'package:exservice/models/response/payment_package_response.dart';
import 'package:exservice/resources/api_client.dart';
import 'package:exservice/resources/links.dart';

class ConfigRepository extends BaseClient {
  // Future<CategoriesResponse> categories() async {
  //   final response = await client.get(Links.CATEGORIES_URL);
  //   return CategoriesResponse.fromJson(response.data);
  // }

  Future<ConfigResponse> config() async {
    final response = await client.get(Links.CONFIG_URL);
    return ConfigResponse.fromJson(response.data);
  }

  Future<PaymentPackageResponse> paymentInfo() async {
    final response = await client.get(Links.CONFIG_PAYMENT_URL);
    return PaymentPackageResponse.fromJson(response.data);
  }
}
