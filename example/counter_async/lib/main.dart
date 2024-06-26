import 'package:counter_async/counter_async_page/counter_async_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter Async PageBloc demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: mainNavKey,
      home: const CounterAsyncPage(),
    );
  }
}

final mainNavKey = GlobalKey<NavigatorState>();
