import 'package:dio/dio.dart';

class People {
  final String name;
  final String height;
  final String birthYear;
  final String gender;
  final String homeWorld;

  People(this.name, this.height, this.birthYear, this.gender, this.homeWorld);

  factory People.fromJson(dynamic data) {
    return People(data['name'], data['height'], data['birth_year'],
        data['gender'], data['homeworld']);
  }
}

class Planet {
  final String name;
  final String rotationPeriod;
  final List<String> terrain;
  final String surfaceWater;
  final String population;

  Planet(this.name, this.rotationPeriod, this.terrain, this.surfaceWater,
      this.population);

  factory Planet.fromJson(dynamic data) {
    return Planet(data['name'], data['rotation_period'], data['terrain'],
        data['surface_water'], data['population']);
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

  Future<List<Planet>> fetchPlanet(
      {String url = 'https://swapi.dev/api/planets/1/'}) async {
    var response = await Dio().get(url);
    List<dynamic> results = response.data;
    return results.map((it) => Planet.fromJson(it)).toList();
  }
}
