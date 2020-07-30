import 'dart:convert' show json;
import 'dart:io';
import 'package:chat/exception/exception.dart';
import 'package:chat/models/request_body_parameters.dart';
import 'package:http/http.dart' as http;

class OTPService {
  final _host = 'us-central1-chat-ae407.cloudfunctions.net';

  Future<dynamic> post(String path,
      {RequestBodyParameters data, bool withAccessToken = false}) async {
    final uri = Uri.http(_host, '/$path');

    var responseJson;
    final headers = await _buildHeaders(
        withAccessToken: withAccessToken, withContentType: true);

    try {
      final response = await http.post(uri,
          headers: headers,
          body: data != null ? json.encode(data.toJson()) : null);
      // print('response :: $response');

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(null, 'No Internet connection.');
    }
    return responseJson;
  }

  Future<Map<String, String>> _buildHeaders(
      {bool withAccessToken = false, bool withContentType = false}) async {
    final Map<String, String> headers = {'Accept': 'application/json'};
    if (withContentType) {
      headers.putIfAbsent('Content-Type', () => 'application/json');
    }
    return headers;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 401:
      case 404:
      case 409:
        if (response.body != null) {
          var responseJson = json.decode(response.body);
          print(responseJson);
          return responseJson;
        }
        return '';
      case 400:
        throw BadRequestException(400, _getErrorMessage(response.body));
      case 403:
        throw UnauthorisedException(401, _getErrorMessage(response.body));
      case 500:
      default:
        throw FetchDataException(null,
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  String _getErrorMessage(String jsonString) {
    final obj = json.decode(jsonString);
    final message = obj['message'];
    return message != null ? message : 'An error occurred.';
  }
}
