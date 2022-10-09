import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pokemon_sprout/API/api.dart';

import '../model/list_pokemon_class.dart';

class ListPokemonController extends GetxController {
  APIData apiData = APIData();
  Future<List<Results>?> getData(int? page) async {
    page = page ?? 1;
    int offset = page * 20;
    int limit = 20;

    var response = await apiData.listPokemon(offset, limit);
    if (response == null) {
      return [];
    } else {
      return response.results;
    }
  }
}
