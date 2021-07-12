import 'package:dio/dio.dart';

class People {
  final String name;
  final String height;
  final String birth_year;
  final String gender;

  People(this.name, this.height, this.birth_year, this.gender);

  factory People.fromJson(dynamic data) {
    return People(
        data['name'], data['height'], data['birth_year'], data['gender']);
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
    // print('$next , $prev');
    return results.map((it) => People.fromJson(it)).toList();
  }
}
