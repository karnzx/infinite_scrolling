import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scrolling/starwars_repo.dart';

class StarwarsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StarwarsListState();
}

class _StarwarsListState extends State<StarwarsList> {
  ScrollController _controller = new ScrollController(initialScrollOffset: 5.0);
  final StarwarsRepo _repo;
  late List<People> _people;
  late int _page;
  bool _loading = true;

  _StarwarsListState() : _repo = new StarwarsRepo();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
    _page = 1;
    _people = [];
    fetchPeople();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (_repo.next != null && _loading == false) {
        _loading = true;
        setState(() {
          _page += 1;
        });
        fetchPeople();
        print("reach the bottom");
      }
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      // if (_repo.prev != null) {
      //   setState(() {
      //     _page -= 1;
      //   });
      //   fetchPeople();
      //   print("reach the top");
      // }
    }
  }

  Future<void> fetchPeople() async {
    var people = await _repo.fetchPeople(page: _page);
    setState(() {
      _people.addAll(List<People>.from(people));
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
    if (_people.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      }
    } else {
      return ListView.builder(
          controller: _controller,
          itemCount: _people.length,
          itemBuilder: (context, index) {
            final People people = _people[index];
            final int imageNumber = (index + 1);
            return Card(
              child: Column(
                children: <Widget>[
                  // Image.network(
                  //   "https://starwars-visualguide.com/assets/img/characters/${imageNumber}.jpg",
                  //   errorBuilder: (BuildContext context, Object exception,
                  //       StackTrace? stackTrace) {
                  //     return const Text('Your error widget...');
                  //   },
                  //   fit: BoxFit.fitWidth,
                  //   width: double.infinity,
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'name : ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              TextSpan(
                                  text: '${people.name}',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'gender : ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              TextSpan(
                                  text: '${people.gender}',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'height : ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              TextSpan(
                                  text: '${people.height}',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'bith year : ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              TextSpan(
                                  text: '${people.birth_year}',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          });
    }
    return Container();
  }
}
