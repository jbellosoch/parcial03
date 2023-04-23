import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_parcial03/modelo/gifgiphy.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AppiParcial03());
}

class AppiParcial03 extends StatefulWidget {
  const AppiParcial03({super.key});

  @override
  State<AppiParcial03> createState() => _AppiParcial03State();
}

class _AppiParcial03State extends State<AppiParcial03> {
  late Future<List<Gifigphy>> _listado;

  Future<List<Gifigphy>> _getgiphy() async {
    final response = await http
        .get(Uri.parse("https://www.freetogame.com/api/games?platform=pc"));
    List<Gifigphy> gif = [];
    if (response.statusCode == 200) {
      String bodys = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(bodys);
      for (var item in jsonData) {
        gif.add(Gifigphy(
            item["title"], item["thumbnail"], Text(item["short_description"])));
      }
      return gif;
    } else {
      throw Exception("Falla en conectarse");
    }
  }

  @override
  void initState() {
    super.initState();
    _listado = _getgiphy();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Api parcial3",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Parcial 03"),
          actions: [
            IconButton(
              icon: Icon(Icons.gamepad),
              onPressed: null,
            )
          ],
        ),
        body: FutureBuilder(
          future: _listado,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 2,
                children: _listados(snapshot.requireData),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text("Error");
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _listados(List<Gifigphy> data) {
    List<Widget> gifs = [];
    for (var gif in data) {
      gifs.add(Card(
        child: Column(children: [
          Expanded(
              child: Image.network(
            gif.url,
            fit: BoxFit.fill,
          ))
        ]),
      ));
    }
    return gifs;
  }
}
