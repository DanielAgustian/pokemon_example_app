import 'dart:async';

import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pokemon_sprout/component/detail__component.dart';
import 'package:pokemon_sprout/controller/pokemon_details_controller.dart';
import 'package:flutter/material.dart';

import '../model/pokemon_class.dart';

class DetailPokemonScreen extends StatefulWidget {
  const DetailPokemonScreen({Key? key, required this.name}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String name;

  @override
  State<DetailPokemonScreen> createState() => _DetailPokemonScreenState();
}

class _DetailPokemonScreenState extends State<DetailPokemonScreen>
    with TickerProviderStateMixin {
  final PokemonController _pokemonController = Get.put(PokemonController());
  PokemonClass? pokemon = PokemonClass();
  Color bgColor = Colors.white;
  Color colorIndicator = Colors.black;
  late TabController _tabController;
  int currIndex = 0;
  @override
  void initState() {
    initData();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(tabSelect);
    super.initState();
  }

  void tabSelect() {
    setState(() {
      currIndex = _tabController.index;
    });
  }

  initData() async {
    pokemon = await _pokemonController.getData(widget.name);

    int length = pokemon!.types!.length;
    if (length >= 1) {
      bgColor = bgPokemon(pokemon!.types![0].type!.name);
      setState(() {
        colorIndicator = bgColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Obx(() => _pokemonController.loading.value
        ? Container(
            color: Colors.white,
            width: size.width,
            height: size.height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton(
                backgroundColor: bgColor,
                onPressed: () {
                  initData();
                },
                tooltip: "Refresh Data",
                child: FaIcon(FontAwesomeIcons.arrowsRotate)),
            backgroundColor: bgColor,
            body: Stack(
              children: [
                Positioned(
                    top: 0.35 * size.height,
                    right: -60,
                    child: Opacity(
                      opacity: 0.1,
                      child: Image.asset(
                        'asset/image/pokeball.png',
                        width: size.width > 550 ? 350 : 200,
                        height: size.width > 550 ? 350 : 200,
                        fit: BoxFit.contain,
                      ),
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 45,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: Text(
                                  StringUtils.capitalize(pokemon!.name ?? ''),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.width > 550 ? 35 : 28,
                                      fontWeight: FontWeight.w700),
                                )),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '#${pokemon!.id}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.width > 550 ? 24 : 20),
                                )
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 20, top: 10),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: [
                                    ...pokemon!.types!
                                        .map((e) => childType(e.type!.name)),
                                  ],
                                ),
                              ),
                            ),
                            CachedNetworkImage(
                              imageUrl:
                                  pokemon?.sprites!.other!.home!.frontDefault ??
                                      "",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width:
                                    size.width > 550 ? 450 : size.width * 0.95,
                                height: size.width > 550 ? 450 : 260,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 0.45 * size.height,
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Column(
                        children: [
                          TabBar(
                            indicatorColor: Colors.white,
                            isScrollable: true,
                            labelPadding: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            unselectedLabelColor:
                                const Color.fromARGB(204, 117, 117, 117),
                            labelColor: bgColor,
                            controller: _tabController,
                            tabs: [
                              Tab(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 15),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: currIndex == 0 ? 2.0 : 1.0,
                                              color: currIndex == 0
                                                  ? bgColor
                                                  : Colors.grey
                                                      .withOpacity(0.6)))),
                                  child: Text(
                                    'About',
                                    style: TextStyle(
                                        fontWeight: currIndex == 0
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 15),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: currIndex == 1 ? 2.0 : 1.0,
                                              color: currIndex == 1
                                                  ? bgColor
                                                  : Colors.grey
                                                      .withOpacity(0.6)))),
                                  child: Text(
                                    'Base Stats',
                                    style: TextStyle(
                                        fontWeight: currIndex == 1
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 15),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: currIndex == 2 ? 2.0 : 1.0,
                                              color: currIndex == 2
                                                  ? bgColor
                                                  : Colors.grey
                                                      .withOpacity(0.6)))),
                                  child: Text(
                                    'Evolutions',
                                    style: TextStyle(
                                        fontWeight: currIndex == 2
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 15),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: currIndex == 3 ? 2.0 : 1.0,
                                              color: currIndex == 3
                                                  ? bgColor
                                                  : Colors.grey
                                                      .withOpacity(0.6)))),
                                  child: Text(
                                    'Moves',
                                    style: TextStyle(
                                        fontWeight: currIndex == 3
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              // Tab(
                              //   height: 35,
                              //   text: "Riwayat Log",
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                              child: TabBarView(
                            controller: _tabController,
                            children: [
                              aboutPokemonPage(),
                              statPokemon(),
                              evolutionPage(),
                              movePage()
                            ],
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )));
  }

  Widget statPokemon() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...pokemon!.stats!
              .map((ele) => statWidget(ele.stat!.name!, ele.baseStat!))
        ],
      ),
    );
  }

  Widget aboutPokemonPage() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        aboutLineWidget(
            'Species', StringUtils.capitalize(pokemon!.species!.name!)),
        aboutLineWidget(
          'Height',
          pokemon!.height.toString(),
        ),
        aboutLineWidget('Weight', pokemon!.weight.toString()),
        aboutLineWidget('Abilities', getAbilities(pokemon!.abilities!))
      ],
    ));
  }

  Widget evolutionPage() {
    return SingleChildScrollView(
      child: Wrap(alignment: WrapAlignment.center, children: [
        ...pokemon!.forms!.map((e) => formsData(
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon!.id?.toString()}.png',
            e.name!,
            160,
            bgColor))
      ]),
    );
  }

  Widget movePage() {
    return SingleChildScrollView(
        child: Column(
      children: [
        ...pokemon!.moves!.map((e) => childMoves(e.move!.name, bgColor))
      ],
    ));
  }

  String getAbilities(List<Abilities> abilities) {
    String temp = '';
    for (var i = 0; i < abilities.length; i++) {
      if (i == abilities.length - 1) {
        temp += StringUtils.capitalize(abilities[i].ability!.name!);
      } else {
        temp += '${StringUtils.capitalize(abilities[i].ability!.name!)}, ';
      }
    }
    return temp;
  }

  Widget childType(String? name) {
    return Container(
      margin: const EdgeInsets.only(right: 5, bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.2)),
      child: Text(
        StringUtils.capitalize(name ?? 'Unknown'),
        style: const TextStyle(
            fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
