// import 'package:kiosk/model/entity/category.dart';
// import 'package:kiosk/model/response/articles_response.dart';
// import 'package:kiosk/model/response/home_response.dart';
// import 'package:kiosk/model/response/issues_response.dart';
// import 'package:kiosk/model/response/search_response.dart';
// import 'package:kiosk/model/response/simple_response.dart';
// import 'package:kiosk/resource/api_client.dart';
// import 'package:kiosk/resource/links.dart';
// import 'package:kiosk/utils/constant.dart';
// import 'package:kiosk/utils/enums.dart';
//
// class DocumentRepository extends BaseClient {
//   Future<HomeResponse> fetchHomeContent() async {
//     final response = await client.get(
//       Links.HOME_URL,
//       queryParameters: {
//         "categories_count": 10,
//         "articles_count": 10,
//         "issues_count": 10,
//       },
//     );
//     return HomeResponse.fromJson(response.data);
//   }
//
//   Future<ArticlesResponse> fetchArticles({
//     required String title,
//     required String tag,
//     required Category? category,
//     String? nextUrl,
//   }) async {
//     var queryParameters = {
//       "filter[title]": title,
//       "category_id": category?.id,
//       "per_page": PER_PAGE,
//     };
//     if (tag.isNotEmpty) queryParameters["filter[tag]"] = tag;
//
//     final response = await client.get(
//       nextUrl ?? Links.ARTICLES_URL,
//       queryParameters: queryParameters,
//     );
//     return ArticlesResponse.fromJson(response.data);
//   }
//
//   Future<IssuesResponse> fetchIssues({
//     required Category? category,
//     String? nextUrl,
//   }) async {
//     final response = await client.get(
//       nextUrl ?? Links.ISSUES_URL,
//       queryParameters: {
//         "category_id": category?.id,
//         "per_page": PER_PAGE,
//       },
//     );
//     return IssuesResponse.fromJson(response.data);
//   }
//
//   Future<SearchResponse> fetchSearch({
//     Category? category,
//     String? substring,
//     String? nextUrl,
//   }) async {
//     final response = await client.get(
//       nextUrl ?? Links.SEARCH_URL,
//       queryParameters: {
//         // "category_id": category?.id,
//         "search": substring,
//         "per_page": PER_PAGE,
//       },
//     );
//     return SearchResponse.fromJson(response.data);
//   }
//
//   Future<IssuesResponse> fetchSavedIssues({
//     String? next,
//   }) async {
//     final response = await client.get(
//       next ?? Links.ISSUES_BOOKMARKS_URL,
//       queryParameters: {
//         "per_page": PER_PAGE,
//       },
//     );
//     return IssuesResponse.fromJson(response.data);
//   }
//
//   Future<SimpleResponse> bookmarkIssue(int id, bool state) async {
//     final response = await client.post(
//       Links.SAVE_ISSUE_URL,
//       data: {
//         "issue_id": id,
//         "saved": state,
//       },
//     );
//     return SimpleResponse.fromJson(response.data);
//   }
//
//   Future<ArticlesResponse> fetchSavedArticles({String? next}) async {
//     final response = await client.get(
//       next ?? Links.ARTICLES_BOOKMARKS_URL,
//       queryParameters: {
//         "per_page": PER_PAGE,
//       },
//     );
//     var articlesResponse = ArticlesResponse.fromJson(response.data);
//     for (var element in articlesResponse.data) {
//       element.saved = true;
//     }
//     return articlesResponse;
//   }
//
//   Future<SimpleResponse> bookmarkArticles(int id, bool state) async {
//     final response = await client.post(
//       Links.SAVE_ARTICLES_URL,
//       data: {
//         "article_id": id,
//         "saved": state,
//       },
//     );
//     return SimpleResponse.fromJson(response.data);
//   }
//
//   Future<SimpleResponse> issuePage(int id, int pageId) async {
//     final response = await client.get(
//       Links.ISSUE_DOCUMENT_URL,
//       queryParameters: {
//         "issue_id": id,
//         "document_id": pageId,
//       },
//     );
//     return SimpleResponse.fromJson(response.data);
//   }
// }
