import 'package:dio/dio.dart';

class People {
  final String name;
  People(this.name);

  factory People.fromJson(dynamic data) {
    return People(data['name']);
  }
}

class StarwarsRepo {
  Future<List<People>> fetchPeople({int page = 1}) async {
    var response = await Dio().get('https://swapi.dev/api/people/?page=$page');
    List<dynamic> results = response.data['results'];
    return results.map((it) => People.fromJson(it)).toList();
  }
}
