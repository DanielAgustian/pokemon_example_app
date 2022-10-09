import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget aboutLineWidget(String title, String stat) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              title,
              style:
                  TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.4)),
            ),
          ),
          Flexible(
              child: Text(
            stat,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ))
        ],
      ));
}

Widget statWidget(String title, int stat) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              statusName(title),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              stat.toString(),
              // textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          Expanded(
              child: LinearProgressIndicator(
            value: stat / 130,
            color: barStatus(stat),
            backgroundColor: barStatus(stat).withOpacity(0.3),
            minHeight: 2,
          ))
        ],
      ));
}

Widget formsData(String url, String name, double width, Color color) {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: Container(
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.08))
          ]),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: url,
            imageBuilder: (context, imageProvider) => Container(
              width: 0.8 * width,
              height: 0.8 * width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            name,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w700, fontSize: 13),
          )
        ],
      ),
    ),
  );
}

Widget childMoves(String? name, Color color) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      padding: EdgeInsets.all(8),
      child: Text(
        StringUtils.capitalize(name ?? ''),
        style: TextStyle(fontWeight: FontWeight.w600, color: color),
      ),
    ),
  );
}

// Misc Logic

Color barStatus(int? stat) {
  if (stat == null) {
    return Colors.blueGrey;
  }
  if (stat < 65) {
    return Colors.red;
  } else {
    return Colors.green;
  }
}

String statusName(String? status) {
  if (status == 'special-attack') {
    return 'Sp. Attack';
  } else if (status == 'special-defense') {
    return 'Sp. Defense';
  } else if (status == 'hp') {
    return 'HP';
  } else if (status == null) {
    return 'Anon';
  } else {
    return StringUtils.capitalize(status);
  }
}

Color bgPokemon(String? type) {
  if (type == 'normal') {
    return const Color(0xFFA8A77A);
  } else if (type == 'fire') {
    return const Color(0xFFEE8130);
  } else if (type == 'water') {
    return const Color(0xFF6390F0);
  } else if (type == 'electric') {
    return const Color(0xFFF7D02C);
  } else if (type == 'grass') {
    return const Color(0xFF7AC74C);
  } else if (type == 'ice') {
    return const Color(0xFF96D9D6);
  } else if (type == 'fighting') {
    return const Color(0xFFC22E28);
  } else if (type == 'poison') {
    return const Color(0xFFA33EA1);
  } else if (type == 'ground') {
    return const Color(0xFFE2BF65);
  } else if (type == 'flying') {
    return const Color(0xFFA98FF3);
  } else if (type == 'psychic') {
    return const Color(0xFFF95587);
  } else if (type == 'bug') {
    return const Color(0xFFA6b91a);
  } else if (type == 'rock') {
    return const Color(0xFFb6a136);
  } else if (type == 'ghost') {
    return const Color(0xFF735797);
  } else if (type == 'dragon') {
    return const Color(0xFF6f35fc);
  } else if (type == 'dark') {
    return const Color(0xFF705746);
  } else if (type == 'steel') {
    return const Color(0xFFb7b7ce);
  } else if (type == 'fairy') {
    return const Color(0xFFD685AD);
  }
  return Colors.blueGrey;
}
