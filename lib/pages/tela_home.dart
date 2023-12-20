import 'package:flutter/material.dart';
import 'package:prova3/pages/telasobre.dart';

class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('poke'),
        actions: [
          IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Telasobre()));
              })
        ],
      ),
      body: const Center(
        child: Text('Aplicativo de pegar pokemon'),
      ),
    );
  }
}
