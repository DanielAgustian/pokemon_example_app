import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pokemon_sprout/model/list_pokemon_class.dart';

import '../model/pokemon_class.dart';

class APIData {
  Future listPokemon(int offset, int limit) async {
    Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    var params = {
      "offset": offset,
      "limit": limit,
    };
    try {
      var response = await dio.get('https://pokeapi.co/api/v2/pokemon',
          queryParameters: params);
      final user = ListPokemonClass.fromJson(response.data);
      return user;
    } on DioError catch (e) {
      print(e.response.toString());
      return null;
    }
  }

  Future pokemonDetails(String name) async {
    Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    try {
      var response = await dio.get(
        'https://pokeapi.co/api/v2/pokemon/$name',
      );
      final user = PokemonClass.fromJson(response.data);
      return user;
    } on DioError catch (e) {
      print(e.response.toString());
      return null;
    }
  }
}
