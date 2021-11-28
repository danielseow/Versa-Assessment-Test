import 'package:flutter/material.dart';
import 'package:versa_test/breweries.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => BreweriesListsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BreweriesPage(),
    );
  }
}
