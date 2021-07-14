import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scrolling/starwars_repo.dart';

class StarwarsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StarwarsListState();
}

class _StarwarsListState extends State<StarwarsList> {
  ScrollController _controller = new ScrollController();
  final int _nextPageThreshold = 3000;
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
    // print(_controller.offset + _nextPageThreshold);
    // print('>> ${_controller.position.maxScrollExtent}');
    if ((_controller.offset + _nextPageThreshold) >=
            _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (_repo.next != null && _loading == false) {
        setState(() {
          _page += 1;
          _loading = true;
        });
        fetchPeople();
        print("page $_page, next ${_repo.next}");
      }
    }
  }

  Future<void> fetchPeople() async {
    var people = await _repo.fetchPeople(page: _page);
    setState(() {
      _people.addAll(List<People>.from(people));
      _loading = false;
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
                  Image.network(
                    "https://starwars-visualguide.com/assets/img/characters/${imageNumber}.jpg",
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return const Text(
                          'Image not found || Something wrong with image');
                    },
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        textDetail(title: "name", text: people.name),
                        textDetail(title: "gender", text: people.gender),
                        textDetail(title: "height", text: people.height),
                        textDetail(title: "bith year", text: people.birth_year),
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

  Widget textDetail({String title = "", String text = ""}) {
    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: '$title : ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          TextSpan(text: text, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
