import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planetas',
      theme: ThemeData(
        primaryColor: Colors.purple,
        primarySwatch: Colors.deepPurple,
      ),
      home: Home(),
    );
  }
}