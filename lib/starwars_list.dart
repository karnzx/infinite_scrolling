import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scrolling/starwars_repo.dart';

class StarwarsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StarwarsListState();
}

class _StarwarsListState extends State<StarwarsList> {
  ScrollController _controller = new ScrollController();
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
    // print(_controller.offset);
    // print('>> ${_controller.position.maxScrollExtent}');
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (_repo.next != null) {
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          _controller.animateTo(_controller.position.maxScrollExtent,
              duration: Duration(seconds: 3), curve: Curves.easeInOut);
        },
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3),
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(248, 176, 144, 1.0),
                Color.fromRGBO(255, 128, 144, 1.0),
                Color.fromRGBO(255, 111, 96, 1.0),
              ],
            ),
          ),
          child: Icon(
            Icons.arrow_downward_sharp,
            size: 40.0,
          ),
        ),
      ),
    );
  }

  Widget getBody() {
    if (_people.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ));
      }
    } else {
      return ListView.builder(
          controller: _controller,
          itemCount: _people.length + (_repo.next != null ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _people.length) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ));
            }

            final People people = _people[index];
            final int imageNumber = (index + 1);

            return GestureDetector(
              onTap: () async {
                var planet = await _repo.fetchPlanet(url: people.homeWorld);
                print(planet);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlanetPage(planet)));
              },
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: textDetail(title: "name", text: people.name),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: getImage(imageNumber),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          textDetail(title: "gender", text: people.gender),
                          textDetail(title: "height", text: people.height),
                          textDetail(
                              title: "bith year", text: people.birthYear),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }
    return Container();
  }

  Widget getImage(int imageNumber) {
    return Image.network(
      "https://starwars-visualguide.com/assets/img/characters/${imageNumber}.jpg",
      fit: BoxFit.fitWidth,
      width: double.infinity,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
            child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  (loadingProgress.expectedTotalBytes as num)
              : null,
        ));
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Column(
          children: [
            Icon(Icons.error, color: Colors.blue, size: 36.0),
            Text('Image not found', style: TextStyle(fontSize: 20))
          ],
        );
      },
    );
  }
}

Widget textDetail({String title = "", String text = ""}) {
  final double textSize = 20;
  return Text.rich(
    TextSpan(
      children: <TextSpan>[
        TextSpan(
            text: '$title : ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
        TextSpan(text: text, style: TextStyle(fontSize: textSize)),
      ],
    ),
  );
}

class PlanetPage extends StatefulWidget {
  final Planet? _planet;

  PlanetPage(this._planet, {Key? key}) : super(key: key);

  @override
  _PlanetPageState createState() => _PlanetPageState(_planet);
}

class _PlanetPageState extends State<PlanetPage> {
  final Planet? _planet;

  _PlanetPageState(this._planet);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_planet?.name ?? 'NOT Found'),
        ),
        body: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: (_planet == null)
                ? Text('text')
                : Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          textDetail(title: 'Name', text: _planet!.name),
                          textDetail(
                              title: 'Rotation Period',
                              text: _planet!.rotationPeriod),
                          textDetail(
                              title: 'Terrain',
                              text: _planet!.terrain.replaceAll(',', '\n')),
                          textDetail(
                              title: 'Surface Water',
                              text: _planet!.surfaceWater),
                          textDetail(
                              title: 'Population', text: _planet!.population),
                        ]),
                  )));
  }
}
