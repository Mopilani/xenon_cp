import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';

class SpiderSystem {
  SpiderSystem();

  static Future<KResponse> lookup(
    String url, {
    String? token,
    String? path,
    String? method,
    Object? body,
    Map<String, String> headers = const {},
  }) async {
    var uri = Uri.parse(url);
    http.Response response;
    switch (method) {
      case 'GET':
        response = await http.get(
          uri,
          headers: headers,
        );
        break;
      case 'POST':
        print(body);
        response = await http.post(
          uri,
          headers: headers,
          body: body,
        );
        break;
      case 'PUT':
        response = await http.put(
          uri,
          headers: headers,
          body: body,
        );
        break;
      case 'DELETE':
        response = await http.delete(
          uri,
          headers: headers,
          body: body,
        );
        break;
      case 'HEAD':
        response = await http.head(
          uri,
          headers: headers,
        );
        break;
      case 'PATCH':
        response = await http.patch(
          uri,
          headers: headers,
          body: body,
        );
        break;
      default:
        toast('Not Allowd Method: $method');
        throw 'Not Allowd Method: $method';
      // return [];
    }

    // var response =
    //     await http.post(uri, body: {'name': 'doodle', 'color': 'blue'});
    // debugPrint('Response status: ${response.statusCode}');
    // debugPrint('Response body: ${response.body}');
    return KResponse(
      headers: response.headers,
      statusCode: response.statusCode,
      body: response.body,
    );
    // return [
    //   response.statusCode,
    //   response.body,
    //   response.headers,
    //   response,
    // ];
  }
}

class KResponse {
  KResponse({
    required this.statusCode,
    required this.headers,
    this.body,
    this.error,
  });
  int statusCode;
  dynamic body;
  dynamic error;
  Map<String, String> headers;

  static KResponse fromJson(String jsonStr) {
    var data = json.decode(jsonStr);
    // print(data['headers']);
    return KResponse(
      statusCode: data['statusCode'],
      body: data['body'],
      headers: () {
        try {
          return Map.from(data['headers'])
              .map<String, String>((k, v) => MapEntry(k, v));
        } catch (e) {
          return <String, String>{};
        }
      }.call(),
      error: data['error'],
    );
  }

  static KResponse fromMap(Map<String, dynamic> data) {
    return KResponse(
      statusCode: data['statusCode'],
      body: data['body'],
      headers: data['headers'],
      error: data['error'],  
    );
  }

  String asJson() {
    return json.encode({
      'statusCode': statusCode,
      'body': body,
      'headers': headers,
      'error': error,
    });
  }

  Map<String, dynamic> asMap() {
    return {
      'statusCode': statusCode,
      'body': body,
      'headers': headers,
      'error': error,
    };
  }
}
