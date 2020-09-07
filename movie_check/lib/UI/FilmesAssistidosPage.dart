import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_checker/Domain/Entities/Filme.dart';
import 'package:movie_checker/Services/Model/Filme_Helper.dart';
import 'package:movie_checker/UI/FilmePage.dart';

import 'Utils/Utils.dart';

class FilmesAssistidosPage extends StatefulWidget {
  @override
  _FilmesAssistidosPageState createState() => _FilmesAssistidosPageState();
}

class _FilmesAssistidosPageState extends State<FilmesAssistidosPage> {
  FilmeHelper filmeHelper = FilmeHelper();

  List<Filme> filmesAssistidos = List();

  @override
  void initState() {
    super.initState();

    atualizaLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: criarAppBar("Filmes assistidos"),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: filmesAssistidos.length,
          itemBuilder: (context, index) {
            return filmeCard(
                context, filmesAssistidos, index, _showFilmePage, _showOptions);
          }),
      backgroundColor: Color(0xaa211d26),
    );
  }

  void _showFilmePage(Filme filme, BuildContext context) async {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => FilmePage(filme: filme)))
        .whenComplete(() {
      atualizaLista();
    });
  }

  void atualizaLista() {
    filmeHelper.getAllFilmes(true).then((list) {
      setState(() {
        filmesAssistidos = list;
        filmesAssistidos.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
      });
    });
  }

  void _showOptions(BuildContext context, int index, List<Filme> filmes,
      Function _showFilmePage) {
    showModalBottomSheet(
        backgroundColor: Color(0xff343138),
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.edit, color: Colors.white),
                      title:
                          Text('Editar', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pop(context);
                        _showFilmePage(filmes[index], context);
                      }),
                  ListTile(
                    leading: Icon(Icons.delete, color: Colors.white),
                    title:
                        Text('Excluir', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      filmeHelper.delete(filmes[index].id);
                      filmes.removeAt(index);
                      atualizaLista();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
