import 'package:flutter/material.dart';

extension ScrollControllerExtension on ScrollController {
  /// 是否 scroll 到最底部
  bool get atBottom => position.pixels > 0 && position.atEdge;
}
