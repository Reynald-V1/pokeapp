import 'package:flutter/material.dart';

class Telasobre extends StatelessWidget {
  const Telasobre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('sobre'),
        ),
        body: Center(
          child: Container(
            color: const Color.fromARGB(255, 197, 154, 23),
            child: const Text('https://github.com/reynald-v1'),
          ),
        ));
  }
}
