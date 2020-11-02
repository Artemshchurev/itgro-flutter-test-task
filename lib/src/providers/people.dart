import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itgro_test/src/models/person.dart';
import 'package:http/http.dart' as http;

class People with ChangeNotifier {
  int _selectedPersonIndex;
  List<Person> _people = [];

  List<Person> get people {
    return [..._people];
  }

  int get selectedPersonIndex {
    return _selectedPersonIndex;
  }

  void setSelectedPersonIndex(int i) {
    _selectedPersonIndex = i;
    notifyListeners();
  }

  void resetSelectedPersonIndex() {
    _selectedPersonIndex = null;
    notifyListeners();
  }

  Future<void> fetchPersons() async {
    _people = await _fetchPersons();
    notifyListeners();
  }

  Future<void> loadMorePersons() async {
    final List<Person> loadedPeople = await _fetchPersons();
    _people.addAll(loadedPeople);
    notifyListeners();
  }

  Future<List<Person>> _fetchPersons() async {
    const url = 'https://randomuser.me/api?results=10';
    try {
      final response = await http.get(url);
      final extractedPersons = json.decode(response.body) as Map<String, dynamic>;
      if (extractedPersons == null) {
        return null;
      }

      final List<Person> loadedPeople = [];
      extractedPersons['results'].forEach((person) {
        var name = person['name'];
        var location = person['location'];
        var street = location['street'];

        loadedPeople.add(Person(
          name: '${name['first']} ${name['last']}',
          address: '${location['postcode']} ${location['country']} ${street['number']} ${street['name']}',
          picture: person['picture']['medium'],
          bigPicture: person['picture']['large'],
          email: person['email'],
        ));
      });
      return loadedPeople;
    } catch (error) {
      throw (error);
    }
  }
}