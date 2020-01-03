import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transferencia_picking/screens/endereco_origem_page.dart';
import 'package:transferencia_picking/screens/produto_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WMS Coletor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: EnderecoOrigemPage(),
    );
  }
}
