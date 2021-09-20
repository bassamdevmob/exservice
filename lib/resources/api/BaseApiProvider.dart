import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/resources/api/URL.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BaseApiProvider {
  final pageSize = 10;
  final dio = Dio();
  final url = URL();

  Map<String, String> buildHeaders() {
    return {
      "Content-Type": "application/json",
      "Accept-Language": DataStore.instance.lang,
      "Authorization": DataStore.instance.session,
    };
  }

  Future<dynamic> post(BuildContext context, String url, [String body]) {
    return send(context, "POST", url, body);
  }

  Future<dynamic> send(
    BuildContext context,
    String method,
    String url, [
    String body,
  ]) async {
    log('url: $url', name: "URL");

    try {
      final req = http.Request(method, Uri.parse(url));
      final headers = buildHeaders();
      log('header: $headers', name: "HEADER");
      req.headers.addAll(headers);
      if (body != null) {
        log('body: $body', name: "BODY");
        req.body = body;
      }
      final response = await http.Response.fromStream(await req.send());

      log("Response: ${response.body}", name: "RESPONSE");

      var _data = json.decode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (_data["code"] != 0) {
          throw _data["message"];
        } else {
          return _data;
        }
      } else {
        throw AppLocalization.of(context).trans('sorry');
      }
    } on SocketException {
      throw AppLocalization.of(context).trans('NoNet');
    } on TimeoutException {
      throw AppLocalization.of(context).trans('RTimeOut');
    }
  }
}
