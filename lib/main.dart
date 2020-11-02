import 'package:flutter/material.dart';
import 'package:itgro_test/src/screens/people_screen.dart';
import 'package:itgro_test/src/providers/people.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => People(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: PeopleScreen(),
      ),
    );
  }
}
