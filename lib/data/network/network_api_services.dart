import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:my_spend/data/exceptions/appExceptions.dart';
import 'package:my_spend/data/network/base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  @override
  Future<dynamic> getApi(String url) async {
    dynamic responseJson;
    try {
      final response = await _dio.get(url);
      responseJson = returnResponse(response);
    } on DioException catch (e) {
      handleDioException(e);
    } on SocketException {
      throw InternetException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future<dynamic> postApi(dynamic data, String url) async {
    dynamic responseJson;
    try {
      final response = await _dio.post(url, data: data);
      responseJson = returnResponse(response);
    } on DioException catch (e) {
      handleDioException(e);
    } on SocketException {
      throw InternetException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.data.toString());
      case 404:
        throw NotFoundException(response.data.toString());
      case 500:
      default:
        throw FetchDataException(
          'Error occurred while communicating with server with status code: ${response.statusCode}',
        );
    }
  }

  void handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw RequestTimeOutException('Request timed out');
      case DioExceptionType.connectionError:
        throw InternetException('No Internet Connection');
      case DioExceptionType.badResponse:
        if (e.response != null) {
          returnResponse(e.response!);
        } else {
          throw FetchDataException('Bad response from server');
        }
        break;
      case DioExceptionType.cancel:
        throw FetchDataException('Request cancelled');
      default:
        throw FetchDataException(e.message ?? 'Unexpected network error occurred');
    }
  }
}
