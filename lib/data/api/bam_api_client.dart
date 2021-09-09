/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:energielabel_app/data/api/api_exception.dart';
import 'package:energielabel_app/model/home/news.dart';
import 'package:energielabel_app/model/quiz/quiz.dart';
import 'package:flutter/foundation.dart';
import 'package:system_proxy/system_proxy.dart';

class BamApiClient {
  BamApiClient({
    required String baseUrl,
    required String apiKey,
  })   : _baseUrl = baseUrl,
        _apiKey = apiKey {
    _configureDioClient();
  }

  static const String _apiKeyHeader = 'APP-API-KEY';
  static const String _newsApiPath = '/news/top';
  static const String _quizApiPath = '/quiz/energielabel';

  final String _baseUrl;
  final String _apiKey;
  final Dio _dio = Dio();

  Dio get dio => _dio;

  Future<News?> fetchNews(String languageCode) async {
    try {
      // When news are available, the response body will be JSON represented as a Map<String, dynamic>.
      // When no news are available, the response body will represented as an empty String.
      // To simplify handling both cases we always work with the string response.
      final response = await _dio.get<String>(_newsApiPath, queryParameters: {'language': languageCode});

      News? news;
      if (response.data!.isNotEmpty) {
        news = News.fromJson(jsonDecode(response.data!));
      }
      return news;
    } catch (e) {
      throw ApiException.from(message: 'Failed to fetch news.', cause: e);
    }
  }

  Future<String> fetchQuizUpdatableInfo(String languageCode) async {
    try {
      final response = await dio.head(_quizApiPath, queryParameters: {'language': languageCode});
      return response.headers['etag']!.first;
    } catch (e) {
      throw ApiException.from(message: 'Failed to fetch the quiz.', cause: e);
    }
  }

  Future<Quiz> fetchQuiz(String languageCode, Function(String etag) onResponse) async {
    try {
      final response = await dio.get(_quizApiPath, queryParameters: {'language': languageCode});
      await onResponse(response.headers['etag']!.first);
      return Quiz.fromJson(response.data);
    } catch (e) {
      throw ApiException.from(message: 'Failed to fetch the quiz.', cause: e);
    }
  }

  Future<void> _configureDioClient() async {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers[_apiKeyHeader] = _apiKey;
    _dio.options.connectTimeout = 15000;
    _dio.options.receiveTimeout = 15000;

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }

    final proxySettings = await _getDeviceProxySetting();
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.findProxy = (uri) => proxySettings;
      return client;
    };
  }

  Future<String> _getDeviceProxySetting() async {
    final Map<String, String>? proxy = await SystemProxy.getProxySettings();
    if (proxy != null) {
      final proxyHost = proxy['host'];
      final proxyPort = proxy['port'];
      return 'PROXY $proxyHost:$proxyPort';
    }
    return 'DIRECT';
  }
}
