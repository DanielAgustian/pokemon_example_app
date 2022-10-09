import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pokemon_sprout/API/api.dart';
import 'package:pokemon_sprout/model/pokemon_class.dart';

class PokemonController extends GetxController {
  APIData apiData = APIData();
  RxBool loading = true.obs;
  Future<PokemonClass?> getData(String? name) async {
    loading(true);
    var response = await apiData.pokemonDetails(name ?? "");
    loading(false);
    if (response == null) {
      return null;
    } else {
      return response;
    }
  }
}
