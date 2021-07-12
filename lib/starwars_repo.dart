import 'package:dio/dio.dart';

class People {
  final String name;
  People(this.name);

  factory People.fromJson(dynamic data) {
    return People(data['name']);
  }
}

class StarwarsRepo {
  late String? next;
  late String? prev;
  Future<List<People>> fetchPeople({int page = 1}) async {
    var response = await Dio().get('https://swapi.dev/api/people/?page=$page');
    List<dynamic> results = response.data['results'];
    next = response.data['next'];
    prev = response.data['previous'];
    print('$next , $prev');
    return results.map((it) => People.fromJson(it)).toList();
  }
}
