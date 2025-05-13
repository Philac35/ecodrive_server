import 'dart:math';

import 'package:ecodrive_server/src/Services/HTMLService/Abstract/AbstractHTMLService.dart';

class HTMLFetchPhotoService extends AbstractHTMLService{


  HTMLFetchPhotoService(super.htmlRequest);

  @override
  Future fetch(htmlRequest) {
    // TODO: implement fetch
    throw UnimplementedError();
  }

  @override
  int getId() {
    var random = Random();
    int randomNumber = random.nextInt(10 ^ 15);
    return randomNumber;
  }

  @override
  parseResult() {
    // TODO: implement parseResult
    throw UnimplementedError();
  }

  @override
  Future<bool> send({htmlRequest,String? method,dynamic data}) {
    // TODO: implement send
    throw UnimplementedError();
  }




}

