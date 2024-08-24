import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'app/pages/home.dart';
import 'app/pages/cadastrar.dart';
import 'app/pages/UserListPage.dart';
import 'app/pages/login.dart';
import 'app/pages/telaCadastro.dart';
import 'app/pages/telaPrincipal.dart';

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
        '/login': (context) => Login(),
        '/userListPage':(context) => UserListPage(), 
        '/telaCadastro':(context) => TelaCadastro(), 
        '/telaPrincipal':(context) => TelaListas(),
      },
      initialRoute: '/login', // Primeira tela a ser carregada
    );
  }
}
