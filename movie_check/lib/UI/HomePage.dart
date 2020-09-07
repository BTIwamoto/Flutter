import 'package:flutter/material.dart';
import 'package:movie_checker/UI/FilmePage.dart';
import 'package:movie_checker/UI/FilmesAssistidosPage.dart';
import 'package:movie_checker/UI/FilmesNaoAssistidosPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    FilmesAssistidosPage(),
    FilmesNaoAssistidosPage(),
    FilmePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: _criarBottomNavigationBar(),
      backgroundColor: Color(0xaa211d26),
    );
  }

  BottomNavigationBar _criarBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        _criarBottomNavigationBarItem(Icons.done_all, "Assistidos"),
        _criarBottomNavigationBarItem(Icons.done, "Não assistidos"),
        _criarBottomNavigationBarItem(Icons.playlist_add, "Adicionar"),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Color(0xff806fa6),
      unselectedItemColor: Colors.white,
      backgroundColor: Color(0xff343138),
      onTap: _onItemTapped,
    );
  }

  BottomNavigationBarItem _criarBottomNavigationBarItem(
      IconData icon, String labelTextMenu) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      title: Text(labelTextMenu),
    );
  }
}
