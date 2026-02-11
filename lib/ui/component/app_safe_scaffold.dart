import 'package:flutter/material.dart';

class AppSafeScaffold extends GestureDetector {
  AppSafeScaffold({
    super.key,
    Color? backgroundColor,
    PreferredSizeWidget? appBar,
    required Widget child,
    Widget? bottomNavigationBar,
    Widget? drawer,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
  }) : super(
         behavior: HitTestBehavior.opaque,
         onTap: () {
           /// 點擊任何地方, 關閉 Keypad
           FocusManager.instance.primaryFocus?.unfocus();
         },
         child: Scaffold(
           resizeToAvoidBottomInset: true,
           backgroundColor: backgroundColor ?? Colors.white,
           appBar: appBar ?? AppBar(
             backgroundColor: Colors.white,
             title: const Text('Funday'),
             bottom: PreferredSize(
               preferredSize: const Size.fromHeight(2),
               child: Container(
                 color: Colors.grey[300], // 灰色分隔線
                 height: 2,
               ),
             ),
           ),
           drawer: drawer,
           bottomNavigationBar: bottomNavigationBar,
           floatingActionButton: floatingActionButton,
           floatingActionButtonLocation: floatingActionButtonLocation,
           body: SafeArea(
             child: child,
           ),
         ),
       );
}
