import 'package:flutter/material.dart';
import 'package:flutter_funday/ui/component/app_divider.dart';

class AppListView extends ListView {
  AppListView({
    super.key,
    required super.itemCount,
    required IndexedWidgetBuilder super.itemBuilder,
    required bool isRemoveTopPadding,
    EdgeInsetsGeometry? padding,
    super.controller,
    super.physics,
    super.shrinkWrap,
    IndexedWidgetBuilder? separatorBuilder,
  }) : super.separated(
         padding:
             padding ??
             (!isRemoveTopPadding
                 ? const EdgeInsets.all(0)
                 : const EdgeInsets.only(
                     left: 0,
                     right: 0,
                     bottom: 0,
                   )),
         separatorBuilder: separatorBuilder ?? (BuildContext context, int index) => AppSpace.spaceVDividerH(height: 0),
       );
}
