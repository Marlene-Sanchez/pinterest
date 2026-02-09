import 'package:flutter/material.dart';
import 'views/feed.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pinterest Clone',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Feed(),
    );
  }
}
