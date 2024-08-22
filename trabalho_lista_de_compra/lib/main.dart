import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'app/pages/home.dart';
import 'app/pages/cadastrar.dart';
import 'app/pages/UserListPage.dart';

void main() {
  runApp(TrabalhoFinal());
}

class TrabalhoFinal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        scaffoldBackgroundColor: Color.fromARGB(255, 230, 228, 223),
      ),
      routes: {
        '/trabalhoFinal': (context) => TrabalhoFinal(),
        '/home': (context) => HomePage(),
        '/cadastrar':(context) => Cadastrar(),
        '/userListPage':(context) => UserListPage(), 
      },
      initialRoute: '/cadastrar', // Primeira tela a ser carregada
    );
  }
}
