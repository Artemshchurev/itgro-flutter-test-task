import 'package:flutter/material.dart';
import 'package:itgro_test/src/providers/people.dart';
import 'package:provider/provider.dart';

class PeopleList extends StatefulWidget {

  @override
  _PeopleListState createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  ScrollController _controller;
  Future _peopleFuture;
  bool _isLoadingMorePersons = false;

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent && !_controller.position.outOfRange && !_isLoadingMorePersons) {
      setState(() {
        _isLoadingMorePersons = true;
      });
      Provider.of<People>(context, listen: false)
          .loadMorePersons()
          .then((_) {
        setState(() {
          _isLoadingMorePersons = false;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = new ScrollController()..addListener(_scrollListener);
    _peopleFuture = Provider.of<People>(context, listen: false).fetchPersons();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _peopleFuture,
      builder: (context, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshot.error != null) {
            return Center(
              child: Container(
                height: 100,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Произошла ошибка',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () => Provider.of<People>(context, listen: false).fetchPersons(),
                      child: Text(
                        'Повторить',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Column(
              children: <Widget>[
                Expanded(
                  child: Consumer<People>(
                    builder: (context, peopleData, child) => ListView.builder(
                        controller: _controller,
                        itemCount: peopleData.people.length,
                        itemBuilder: (context, i) {
                          var person = peopleData.people[i];
                          return Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => Provider.of<People>(context, listen: false).setSelectedPersonIndex(i),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  leading: Image.network(
                                    person.picture,
                                  ),
                                  title: Text(person.name),
                                  subtitle: Text(person.address),
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        }
                    ),
                  ),
                ),
                if (_isLoadingMorePersons)
                  Container(
                    child: Center(child: CircularProgressIndicator()),
                    height: 50,
                  )
              ],
            );
          }
        }
      },
    );
  }
}
