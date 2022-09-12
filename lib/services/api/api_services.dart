import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

class ApiServices {
  late Logger _logger;
  late Dio _dio;
  ApiServices() {
    _dio = Dio();
    _logger = Logger("Api Services");
  }

  Future<Response?> get({required String endUrl}) async {
    try {
      final Response response = await _dio.get(dotenv.env['baseUrl']! + endUrl);
      switch (response.statusCode) {
        case 200:
          return response;
        default:
          return null;
      }
    } on TimeoutException catch (error) {
      print(error.message);
    } on DioError catch (error) {
      print(error.message);
    }
    return null;
  }

  Future<Response?> post(
      {required String endUrl, required Map<String, dynamic> data}) async {
    try {
      final Response response =
          await _dio.post(dotenv.env['baseUrl']! + endUrl, data: data);
      switch (response.statusCode) {
        case 200:
          return response;
        default:
          return null;
      }
    } on TimeoutException catch (error) {
      print(error.message);
    } on DioError catch (error) {
      print(error.message);
    }
    return null;
  }

  Future<Response?> update(
      {required String endUrl, required Map<String, dynamic> data}) async {
    try {
      final Response response =
      await _dio.patch(dotenv.env['baseUrl']! + endUrl, data: data);
      switch (response.statusCode) {
        case 200:
          return response;
        default:
          return null;
      }
    } on TimeoutException catch (error) {
      print(error.message);
    } on DioError catch (error) {
      print(error.message);
    }
    return null;
  }


  Future<Response?> put(
      {required String endUrl, required Map<String, dynamic> data}) async {
    try {
      final Response response =
          await _dio.put(dotenv.env['baseUrl']! + endUrl, data: data);
      switch (response.statusCode) {
        case 200:
          return response;
        default:
          return null;
      }
    } on TimeoutException catch (error) {
      print(error.message);
    } on DioError catch (error) {
      print(error.message);
    }
    return null;
  }

  Future<Response?> delete(
      {required String endUrl, required Map<String, dynamic> data}) async {
    try {
      final Response response =
          await _dio.delete(dotenv.env['baseUrl']! + endUrl);
      switch (response.statusCode) {
        case 200:
          return response;
        default:
          return null;
      }
    } on TimeoutException catch (error) {
      print(error.message);
    } on DioError catch (error) {
      print(error.message);
    }
    return null;
  }
}
