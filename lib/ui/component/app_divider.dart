import 'package:flutter/material.dart';

class AppSpace extends SizedBox {
  const AppSpace({
    super.key,
  });

  AppSpace.spaceHDividerV({
    super.key,
    double? width,
    double? dividerWidth,
    Color? dividerColor,
    double? indent,
    double? endIndent,
  }) : super(
         width: width ?? 8,
         child: VerticalDivider(
           color: dividerColor ?? Colors.transparent,
           width: dividerWidth ?? 8,
           indent: indent,
           endIndent: endIndent,
         ),
       );

  AppSpace.spaceHDividerH({
    super.key,
    double? width,
    double? dividerHeight,
    Color? dividerColor,
    double? indent,
    double? endIndent,
  }) : super(
         width: width ?? 8,
         child: Divider(
           color: dividerColor ?? Colors.transparent,
           height: dividerHeight ?? 8,
           indent: indent,
           endIndent: endIndent,
         ),
       );

  AppSpace.spaceVDividerH({
    super.key,
    double? height,
    double? dividerHeight,
    Color? dividerColor,
    double? indent,
    double? endIndent,
  }) : super(
         height: height ?? 8,
         child: Divider(
           color: dividerColor ?? Colors.transparent,
           height: dividerHeight ?? 8,
           indent: indent,
           endIndent: endIndent,
         ),
       );

  AppSpace.spaceVDividerV({
    super.key,
    double? height,
    double? dividerWidth,
    Color? dividerColor,
    double? indent,
    double? endIndent,
  }) : super(
         height: height ?? 8,
         child: VerticalDivider(
           color: dividerColor ?? Colors.transparent,
           width: dividerWidth ?? 8,
           indent: indent,
           endIndent: endIndent,
         ),
       );
}
