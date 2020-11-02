import 'package:flutter/material.dart';
import 'package:itgro_test/src/providers/people.dart';
import 'package:provider/provider.dart';

class PeopleDetail extends StatefulWidget {
  @override
  _PeopleDetailState createState() => _PeopleDetailState();
}

class _PeopleDetailState extends State<PeopleDetail> {
  PageController _controller;

  _scrollListener() {
    if (_controller.page.toInt() == Provider.of<People>(context, listen: false).people.length) {
      Provider.of<People>(context, listen: false).loadMorePersons();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = new PageController(
      viewportFraction: 0.7,
      initialPage: Provider.of<People>(context, listen: false).selectedPersonIndex,
    )..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final people = Provider.of<People>(context).people;
    return Positioned(
      child: SizedBox.expand(
        child: Column(
          children: <Widget>[
            Container(
              height: 90,
              color: Colors.blueAccent,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        '${Provider.of<People>(context).selectedPersonIndex + 1} из ${Provider.of<People>(context).people.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 20,
                    child: GestureDetector(
                      onTap: () => Provider.of<People>(context, listen: false)
                          .resetSelectedPersonIndex(),
                      child: Icon(
                        Icons.cancel,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white.withOpacity(0.7),
                child: Center(
                  child: SizedBox(
                    height: 400, // card height
                    child: PageView.builder(
                      itemCount: people.length + 1,
                      controller: _controller,
                      onPageChanged: (int i) => Provider.of<People>(context, listen: false).setSelectedPersonIndex(i),
                      itemBuilder: (_, i) {
                        return Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: i == people.length
                            ? Center(
                              child: CircularProgressIndicator(),
                            )
                            : Column(
                                children: <Widget>[
                                  Image.network(people[i].bigPicture),
                                  Text(
                                    people[i].name,
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5),
                                    child: Text(
                                      'Address:',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(people[i].address),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      'Email:',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(people[i].email)
                                ],
                              ),
                        );
                      },
                    )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
