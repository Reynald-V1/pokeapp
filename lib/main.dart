import 'package:flutter/material.dart';
import 'package:prova3/pages/capturados.dart';
import 'package:prova3/pages/tela_captura.dart';
import 'package:prova3/pages/tela_home.dart';
import 'package:prova3/pages/telasobre.dart';

void main() {
  runApp(MainApp(
    routes: {
      '/telasobre': (context) => const Telasobre(),
    },
  ));
}

class MainApp extends StatefulWidget {
  const MainApp(
      {super.key, required Map<String, Function(dynamic context)> routes});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _pag = 0;

  final List _list = [
    const TelaHome(),
    const TelaCaptura(),
    const PokemonCapturados()
  ];

  void _updatePage(int index) {
    setState(() {
      _pag = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _list[_pag],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _pag,
            onTap: _updatePage,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_sharp), label: 'captura'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.abc), label: 'capturados')
            ]),
      ),
    );
  }
}
