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
      // for (var p in _people) {
      //   print(p.name);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinite Scrolling List App'),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView.builder(
        itemCount: _people.length,
        itemBuilder: (context, index) {
          if (index == _people.length) {
            if (_page + 1 <= 9) {
              _page += 1;
            }
            fetchPeople();
            print('hello');
          }
          final People people = _people[index];
          final int imageNumber = (index + 1) * _page;
          return Card(
            child: Column(
              children: <Widget>[
                Image.network(
                  "https://starwars-visualguide.com/assets/img/characters/${imageNumber}.jpg",
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(people.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          );
        });
  }
}
