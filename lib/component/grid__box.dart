import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridListPokemon extends StatelessWidget {
  final String? url;
  final String? name;
  final Function onClick;
  const GridListPokemon({Key? key, this.url, this.name, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
      child: InkWell(
        onTap: () {
          onClick();
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.blueGrey),
          child: Stack(
            children: [
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset(
                    'asset/image/pokeball.png',
                    width: 100,
                    height: 100,
                    color: Colors.blueGrey.withOpacity(0.1),
                    fit: BoxFit.contain,
                    colorBlendMode: BlendMode.modulate,
                  )),
              Padding(
                padding: EdgeInsets.all(size.width > 550 ? 15 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringUtils.capitalize(name ?? ""),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: size.width > 550 ? 30 : 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: CachedNetworkImage(
                          imageUrl: getURL(url ?? ""),
                          imageBuilder: (context, imageProvider) => Container(
                            width: size.width > 550 ? 85 : 75,
                            height: size.width > 550 ? 85 : 75,
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
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getURL(String string) {
    String id = string
        .replaceAll('https://pokeapi.co/api/v2/pokemon/', '')
        .replaceAll('/', '');

    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$id.png';
  }
}
