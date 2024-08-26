import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/bd.dart'; // Importa a função de inicialização do banco

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<Map<String, dynamic>> _userList = []; // Lista de registros de usuários

  // Função para obter os registros da tabela de usuários
  Future<void> getDevices() async {
    final db = await ListaDatabase();

    // Consulta todos os registros da tabela 'Usuarios'
    final List<Map<String, dynamic>> users = await db.query('Usuarios');

    setState(() {
      _userList = users; // Atualiza a lista de usuários
    });
  }

  // Função para limpar os registros da tabela
  Future<void> limparRegistros() async {
    final db = await ListaDatabase();
    // Exclui todos os registros da tabela 'Usuarios'
    await db.delete('Usuarios');

    setState(() {
      _userList =
          []; // Atualiza a lista de usuários para refletir os registros vazios
    });
  }

  @override
  void initState() {
    super.initState();
    getDevices(); // Carrega os registros ao iniciar a página
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuários'),
      ),
      body: _userList.isEmpty
          ? Center(child: Text('Nenhum usuário encontrado'))
          : ListView.builder(
              itemCount: _userList.length,
              itemBuilder: (context, index) {
                final user = _userList[index];
                return ListTile(
                  title: Text(user['nome_usu']),
                  subtitle: Text(user['email_usu']),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: limparRegistros,
        child: Icon(Icons.delete),
        tooltip: 'Limpar Registros',
      ),
    );
  }
}
