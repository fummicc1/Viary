import 'dart:io';
import 'package:http/http.dart' as http;

abstract class TodoApiClient {
  Future<String> get(String endpoint);

  Future<String> post(String endpoint, {required String body});

  Future<String> put(String endpoint, {required String body});

  Future<String> delete(String endpoint);
}

class TodoApiClientImpl implements TodoApiClient {
  factory TodoApiClientImpl({required String baseUrl}) {
    return _instance ??= TodoApiClientImpl._internal(baseUrl);
  }

  // クラス生成時に instance を生成する class コンストラクタ
  TodoApiClientImpl._internal(this.baseUrl);

  // singleton にする為の instance キャッシュ
  static TodoApiClientImpl? _instance;

  // APIの基底Url
  final String baseUrl;

  static const headers = <String, String>{'content-type': 'application/json'};

  Future<String> _safeApiCall(Function callback) async {
    try {
      final response = await callback() as http.Response;
      return _parseResponse(response.statusCode, response.body);
    } on SocketException {
      throw Exception('No Internet Connection');
    }
  }

  @override
  Future<String> get(String endpoint) async {
    return _safeApiCall(
      () async => http.get(
        Uri.parse('$baseUrl$endpoint'),
      ),
    );
  }

  @override
  Future<String> post(String endpoint, {required String body}) async {
    return _safeApiCall(
      () async => http.post(Uri.parse('$baseUrl$endpoint'),
          headers: headers, body: body),
    );
  }

  @override
  Future<String> put(String endpoint, {required String body}) async {
    return _safeApiCall(
      () async => http.put(Uri.parse('$baseUrl$endpoint'),
          headers: headers, body: body),
    );
  }

  @override
  Future<String> delete(String endpoint) async {
    return _safeApiCall(
      () async => http.delete(
        Uri.parse('$baseUrl$endpoint'),
      ),
    );
  }

  String _parseResponse(int httpStatus, String responseBody) {
    switch (httpStatus) {
      case 200 | 201:
        return responseBody;
      case 400:
        throw Exception('400 Bad Request');
      case 401:
        throw Exception('401 Unauthorized');
      case 403:
        throw Exception('403 Forbidden');
      case 404:
        throw Exception('404 Not Found');
      case 405:
        throw Exception('405 Method Not Allowed');
      case 500:
        throw Exception('500 Internal Server Error');
      default:
        throw Exception('Http status $httpStatus unknown error.');
    }
  }
}
