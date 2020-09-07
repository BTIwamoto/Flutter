import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_checker/Domain/Entities/Filme.dart';

Widget filmeCard(BuildContext context, List<Filme> filmes, int index,
    Function _showFilmePage, Function _showOptions) {
  return GestureDetector(
    child: Card(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                    width: 90.0,
                    height: 90.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: filmes[index].imagem != null
                                ? FileImage(File(filmes[index].imagem))
                                : AssetImage("images/filme.png")))),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          filmes[index].nome,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          filmes[index].status ? "Assistido" : "Não assistido",
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
        color: Color(0xff343138)),
    onTap: () {
      _showOptions(context, index, filmes, _showFilmePage);
    },
  );
}

void showErrorMessageImagem(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff343138),
          title: Text(
            "Nenhuma imagem foi selecionada",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          content: Text("É necessário informar uma imagem",
              style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok", style: TextStyle(color: Color(0xff806fa6))),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      });
}

Future<bool> requestAlertDialog(
    bool paginaEditada, BuildContext context) async {
  if (paginaEditada) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xff343138),
            title: Text("Descartar alterações?",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            content: Text("As alterações serão perdidas.",
                style: TextStyle(color: Colors.white)),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar",
                    style: TextStyle(color: Color(0xff806fa6))),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim", style: TextStyle(color: Color(0xff806fa6))),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });

    return Future.value(false);
  } else {
    return Future.value(true);
  }
}

Widget criarAppBar(String labelText) {
  return AppBar(
    title: Text(
      labelText,
      style: TextStyle(fontSize: 20, color: Colors.white),
    ),
    backgroundColor: Color(0xff343138),
    toolbarHeight: 50,
  );
}
