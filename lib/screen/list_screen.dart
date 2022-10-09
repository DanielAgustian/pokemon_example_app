import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pokemon_sprout/controller/list_pokemon_controller.dart';
import 'package:pokemon_sprout/screen/detail_pokemon_screen.dart';
import 'package:pokemon_sprout/model/list_pokemon_class.dart';

import '../component/grid__box.dart';

class ListPokemonScreen extends StatefulWidget {
  const ListPokemonScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ListPokemonScreen> createState() => _ListPokemonScreenState();
}

class _ListPokemonScreenState extends State<ListPokemonScreen> {
  ListPokemonController listPokemonController =
      Get.put(ListPokemonController());
  DateTime? currentBackPressTime;
  final PagingController<int, Results> _pagingController =
      PagingController(firstPageKey: 0);

  final int _pageSize = 20;

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await listPokemonController.getData(pageKey);
      final isLastPage = newItems!.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime ?? DateTime.now()) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(msg: "Click back again to exit");
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned(
                  top: -45,
                  right: -45,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Opacity(
                      opacity: 0.3,
                      child: Image.asset(
                        'asset/image/pokeball.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                  )),
              SizedBox(
                height: size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, top: 10),
                        child: Text(
                          'Pokedex',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black54,
                              fontSize: 38),
                        ),
                      ),
                    ),
                    Expanded(
                        child: RefreshIndicator(
                      onRefresh: () =>
                          Future.sync(() => _pagingController.refresh()),
                      child: PagedGridView<int, Results>(
                        pagingController: _pagingController,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: size.width > 550 ? 3 : 2,
                            childAspectRatio:
                                size.width > 550 ? 2 / 1.4 : 2 / 1.6),
                        builderDelegate: PagedChildBuilderDelegate<Results>(
                            itemBuilder: (context, item, index) =>
                                GridListPokemon(
                                  onClick: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailPokemonScreen(
                                                    name: item.name ?? "")));
                                  },
                                  url: item.url,
                                  name: item.name,
                                )),
                      ),
                    ))
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
