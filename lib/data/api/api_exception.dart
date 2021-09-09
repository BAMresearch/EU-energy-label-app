/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:io';

import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException._(this.message, this.cause);

  factory ApiException.from({required String message, required Object cause}) {
    if (cause is DioError) {
      if (cause.error is SocketException) {
        return NoConnectionException(message, cause);
      }
    }
    return ApiException._(message, cause);
  }

  final String message;
  final Object cause;

  @override
  String toString() {
    return 'ApiException{message: $message, cause: ${cause.toString()}';
  }
}

class NoConnectionException extends ApiException {
  NoConnectionException(String message, Object cause) : super._(message, cause);
}
