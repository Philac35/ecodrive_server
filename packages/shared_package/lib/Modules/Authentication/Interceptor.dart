import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';

class CustomInterceptor implements InterceptorContract {


  @override
  FutureOr<bool> shouldInterceptRequest() {
    // TODO: implement shouldInterceptRequest
    throw UnimplementedError();
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    // TODO: implement shouldInterceptResponse
    throw UnimplementedError();
  }

  @override
  FutureOr<BaseRequest> interceptRequest({required BaseRequest request})  async {
    //check if Authorized is placed
    //If is connected place Bearer: authorized on requests

      print('----- Request -----');
      print(request.toString());
      print(request.headers.toString());
// Can change header here
      request.headers[HttpHeaders.contentTypeHeader] = "application/json";
      return request;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) async {
    log('----- Response -----');
    log('Code: ${response.statusCode}');
    if (response is Response) {
      log((response).body);
    }
    return response;
  }
  }
