import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_funday/locator.dart';
import 'package:flutter_funday/service/api_service.dart';

abstract class BaseModel extends ChangeNotifier {
  var _busy = false;

  APIService get apiService => locator<APIService>();

  bool get busy => _busy;

  void setBusy<T>(bool value) {
    _busy = value;
    notifyListeners();
  }

  Future<void> initData() async {}

  Future<void> refresh() async {}
}
