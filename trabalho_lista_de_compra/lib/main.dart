import 'package:flutter/material.dart';
import 'app/pages/home.dart';
import 'app/pages/cadastrar.dart';
import 'app/pages/UserListPage.dart';
import 'app/pages/login.dart';
import 'app/pages/telaCadastro.dart';
import 'app/pages/telaPrincipal.dart';
import 'app/pages/editar.dart';
import 'app/pages/visualizar.dart';
import '../../database/bd.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await deleteAppDatabase(); // 
  await ListaDatabase(); 
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
        '/home': (context) => HomePage(),
        '/cadastrar': (context) => Cadastrar(),
        '/login': (context) => Login(),
        '/userListPage': (context) => UserListPage(),
        '/telaCadastro': (context) => TelaCadastro(),
        '/telaPrincipal': (context) => TelaListas(),
        // Define a rota para Editar passando o argumento
        '/editar': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          if (args != null) {
            return Editar(
              idLista: args['id'] as int,
              nomeLista: args['nome'] as String,
            );
          }
          return Scaffold(
            body: Center(child: Text('Dados não encontrados!')),
          );
        },
        // Define a rota para Visualizar passando o argumento
        '/visualizar': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          if (args != null) {
            return Visualizar(
              idLista: args['idLista'] as int,
              nomeLista: args['nomeLista'] as String,
            );
          }
          return Scaffold(
            body: Center(child: Text('Dados não encontrados!')),
          );
        },
      },
      initialRoute: '/home',
    );
  }
}

