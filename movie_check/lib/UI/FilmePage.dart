import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_checker/Domain/Entities/Filme.dart';
import 'package:movie_checker/Services/Model/Filme_Helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_checker/UI/Validations/Validacoes.dart';

import 'Utils/Utils.dart';

class FilmePage extends StatefulWidget {
  final Filme filme;
  FilmePage({this.filme});

  @override
  _FilmePageState createState() => _FilmePageState();
}

class _FilmePageState extends State<FilmePage> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validacao = false;

  FilmeHelper filmeHelper = FilmeHelper();

  final _nomeController = TextEditingController();
  final _autorController = TextEditingController();
  final _anoController = TextEditingController();

  ImagePicker _picker = ImagePicker();

  bool _paginaEditada = false;
  bool _filmeAssistido = false;

  Filme _filmeEditado;

  @override
  void initState() {
    super.initState();

    if (widget.filme == null)
      _filmeEditado = Filme();
    else {
      _filmeEditado = Filme.fromMap(widget.filme.toMap());
      _filmeEditado.id = widget.filme.id;

      _nomeController.text = _filmeEditado.nome;
      _autorController.text = _filmeEditado.autor;
      _anoController.text = _filmeEditado.ano;
      _filmeAssistido = _filmeEditado.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => requestAlertDialog(_paginaEditada, context),
        child: Scaffold(
            appBar: criarAppBar("Adicionar filme"),
            body: _criarSingleChildScrollViewAddFilme(context),
            backgroundColor: Color(0xaa211d26)));
  }

  SingleChildScrollView _criarSingleChildScrollViewAddFilme(
      BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Form(
            key: _key,
            autovalidate: _validacao,
            child: Column(
              children: <Widget>[
                _criarGestureDetectorImagem(context),
                Padding(padding: EdgeInsets.only(top: 40.0)),
                _criarTextFormField(_nomeController, "Nome", TextInputType.text,
                    Validacoes().nomeValidacao),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                _criarTextFormField(_autorController, "Autor",
                    TextInputType.text, Validacoes().autorValidacao),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                _criarTextFormField(_anoController, "Ano", TextInputType.number,
                    Validacoes().anoValidacao),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                _criarSwitchListTile(),
                FlatButton(
                  onPressed: () async {
                    _sendForm();

                    if (_filmeEditado.imagem == null ||
                        _filmeEditado.imagem.isEmpty) {
                      showErrorMessageImagem(context);
                    } else {
                      if (!_validacao) {
                        if (widget.filme == null) {
                          await filmeHelper.insert(_filmeEditado);
                          FocusScope.of(context).offset;
                          limparElementos();
                        } else {
                          await filmeHelper.update(_filmeEditado);
                          Navigator.pop(context);
                        }
                      }
                    }
                  },
                  color: Color(0xff806fa6),
                  textColor: Colors.white,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Text("Salvar"),
                    ),
                  ),
                ),
              ],
            )));
  }

  GestureDetector _criarGestureDetectorImagem(BuildContext context) {
    return GestureDetector(
      child: Container(
          width: 200.0,
          height: 200.0,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  image: _filmeEditado.imagem != null
                      ? FileImage(File(_filmeEditado.imagem))
                      : AssetImage("images/filme.png")))),
      onTap: () {
        _mostrarOpcoesGaleriaOuCamera(context);
      },
    );
  }

  SwitchListTile _criarSwitchListTile() {
    return SwitchListTile(
      title: Text(
        'Assistido',
        style: TextStyle(color: Color(0xff806fa6)),
      ),
      contentPadding: EdgeInsets.only(left: 10.0),
      activeColor: Color(0xff806fa6),
      inactiveThumbColor: Color(0xff343138),
      value: _filmeAssistido,
      onChanged: (bool value) {
        setState(() {
          _paginaEditada = true;
          _filmeAssistido = value;
          _filmeEditado.status = value;
        });
      },
    );
  }

  TextFormField _criarTextFormField(
      TextEditingController controller,
      String labelTextInputDecoration,
      TextInputType textInputType,
      Function validacao) {
    return TextFormField(
      controller: controller,
      decoration: _criarInputDecoration(labelTextInputDecoration),
      keyboardType: textInputType,
      validator: (value) => validacao(value),
      textCapitalization: TextCapitalization.sentences,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      onChanged: (text) {
        _paginaEditada = true;

        switch (labelTextInputDecoration) {
          case "Nome":
            setState(() {
              _filmeEditado.nome = text;
            });
            break;
          case "Autor":
            setState(() {
              _filmeEditado.autor = text;
            });
            break;
          case "Ano":
            setState(() {
              _filmeEditado.ano = text;
            });
            break;
        }
      },
    );
  }

  InputDecoration _criarInputDecoration(String labelText) {
    return InputDecoration(
        labelText: labelText,
        labelStyle:
            TextStyle(color: Color(0xff806fa6), fontWeight: FontWeight.bold),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        fillColor: Color(0xff343138),
        focusColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff806fa6)),
          borderRadius: BorderRadius.circular(25.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff806fa6)),
          borderRadius: BorderRadius.circular(25.0),
        ));
  }

  void _mostrarOpcoesGaleriaOuCamera(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Color(0xff343138),
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library, color: Colors.white),
                      title: Text('Galeria',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _getImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera, color: Colors.white),
                    title:
                        Text('Câmera', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      _getImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _sendForm() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      setState(() {
        _validacao = false;
      });
    } else {
      setState(() {
        _validacao = true;
      });
    }
  }

  void limparElementos() {
    setState(() {});

    _nomeController.text = "";
    _autorController.text = "";
    _anoController.text = "";

    _filmeAssistido = false;
    _paginaEditada = false;

    _filmeEditado.nome = null;
    _filmeEditado.imagem = null;
    _filmeEditado.autor = null;
    _filmeEditado.ano = null;
    _filmeEditado.status = null;
  }

  void _getImage(ImageSource source) {
    _picker.getImage(source: source).then((file) {
      if (file == null) {
        return;
      } else {
        setState(() {
          _filmeEditado.imagem = file.path;
        });
      }
    });
  }
}
