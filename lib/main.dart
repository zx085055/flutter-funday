import 'package:flutter/material.dart';
import 'package:flutter_funday/locator.dart';
import 'package:flutter_funday/ui/widget/audio_guide/audio_guide.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Funday',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AudioGuideWidget(),
    );
  }
}
