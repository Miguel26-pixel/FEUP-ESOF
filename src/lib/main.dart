import 'package:flutter/material.dart';
import 'package:src/view/page/main_page.dart';
import 'package:src/view/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: applicationLightTheme,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
