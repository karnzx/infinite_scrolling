import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scrolling/starwars_repo.dart';

class StarwarsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StarwarsListState();
}

class _StarwarsListState extends State<StarwarsList> {
  final StarwarsRepo _repo;
  late List<People> _people;
  late int _page;

  _StarwarsListState() : _repo = new StarwarsRepo();

  @override
  void initState() {
    super.initState();
    _page = 1;
    _people = [];
    fetchPeople();
  }

  Future<void> fetchPeople() async {
    var people = await _repo.fetchPeople(page: _page);
    setState(() {
      _people = List<People>.from(people);
      for (var p in _people) {
        print(p.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Infinite Scrolling List App'),
        ),
        body: Center(
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'this is text',
              ),
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
