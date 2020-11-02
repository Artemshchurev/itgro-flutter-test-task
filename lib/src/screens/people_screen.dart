import 'package:flutter/material.dart';
import 'package:itgro_test/src/providers/people.dart';
import 'package:itgro_test/src/widgets/people_detail.dart';
import 'package:itgro_test/src/widgets/people_list.dart';
import 'package:provider/provider.dart';

class PeopleScreen extends StatefulWidget {
  @override
  _PeopleScreenState createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {

  @override
  Widget build(BuildContext context) {
    final int selectedPersonIndex = Provider.of<People>(context).selectedPersonIndex;

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: const Text('People'),
          ),
          body: PeopleList(),
        ),
        if (selectedPersonIndex != null)
          PeopleDetail()
      ],
    );
  }
}
