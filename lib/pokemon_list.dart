import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jsonapi/models/pokedex.dart';
import 'package:flutter_jsonapi/pokemon_detail.dart';
import 'package:http/http.dart' as http;

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  Pokedex pokedex;
  var url = Uri.https("raw.githubusercontent.com",
      "/Biuni/PokemonGO-Pokedex/master/pokedex.json");
  Future<Pokedex> veri;

  Future<Pokedex> pokemonlariGetir() async {
    var response = await http.get(url); // http'den veriyi çektik
    var decodedJson = jsonDecode(
        response.body); // string olan veriyi json objelere dönüştürdük
    pokedex = Pokedex.fromJson(
        decodedJson); //json nesneleri Pokedex nesnesine döndürdük.
    return pokedex;
  }

  @override
  void initState() {
    super.initState();
    veri = pokemonlariGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pokedex Uygulaması")),
      body: FutureBuilder(
        future: veri,
        builder: (context, AsyncSnapshot<Pokedex> gelenPokedex) {
          if (gelenPokedex.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (gelenPokedex.connectionState == ConnectionState.done) {
            /* return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Text(gelenPokedex.data.pokemon[index].name);
                });*/
            return GridView.count(
              crossAxisCount: 2,
              children: gelenPokedex.data.pokemon.map((poke) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PokemonDetail(
                          pokemon: poke,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: poke.id,
                    child: Card(
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 200,
                            height: 127,
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/images/loading.gif",
                              image: poke.img.replaceAll('http', 'https'),
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(
                            poke.name,
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }
          return Text("Bir şeyler ters gitti.");
        },
      ),
    );
  }
}
