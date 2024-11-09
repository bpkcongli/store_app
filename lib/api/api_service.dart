import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import './api_constants.dart';
import '../exceptions/app_exception.dart';

class ApiService {
  Future<dynamic> get(String endpoint, [Map<String, String> headers = const {}]) async {
    final url = Uri.parse(ApiConstants.baseUrl + endpoint);

    try {
      final response = await http.get(url, headers: {...ApiConstants.headers, ...headers});
      return _checkIsResponseSucceed(response);
    } on SocketException {
      throw ConnectionFailedException();
    }
  }

  Future<dynamic> post(String endpoint, Map<String, String> payload, [Map<String, String> headers = const {}]) async {
    final url = Uri.parse(ApiConstants.baseUrl + endpoint);

    try {
      final response = await http.post(url, headers: {...ApiConstants.headers, ...headers}, body: json.encode(payload));
      return _checkIsResponseSucceed(response);
    } on SocketException {
      throw ConnectionFailedException();
    }
  }

  Future<dynamic> put(String endpoint, Map<String, String> payload, [Map<String, String> headers = const {}]) async {
    final url = Uri.parse(ApiConstants.baseUrl + endpoint);

    try {
      final response = await http.put(url, headers: {...ApiConstants.headers, ...headers}, body: json.encode(payload));
      return _checkIsResponseSucceed(response);
    } on SocketException {
      throw ConnectionFailedException();
    }
  }

  Future<dynamic> delete(String endpoint, [Map<String, String> headers = const {}]) async {
    final url = Uri.parse(ApiConstants.baseUrl + endpoint);

    try {
      final response = await http.delete(url, headers: {...ApiConstants.headers, ...headers});
      return _checkIsResponseSucceed(response);
    } on SocketException {
      throw ConnectionFailedException();
    }
  }

  dynamic _checkIsResponseSucceed(http.Response response) {
    final responseJson = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseJson;
    }

    switch (response.statusCode) {
      case 400:
        throw BadRequestException(message: responseJson['message']);
      case 401:
        throw UnauthenticatedException(message: responseJson['message']);
      case 403:
        throw ForbiddenException(message: responseJson['message']);
      case 404:
        throw NotFoundException(message: responseJson['message']);
      case 409:
        throw ConflictException(message: responseJson['message']);
      case 422:
        throw UnprocessableEntityException(message: responseJson['message']);
      case 429:
        throw TooManyRequestException(message: responseJson['message']);
      case 500:
      default:
        throw ServerErrorException(message: responseJson['message']);
    }
  }
}
