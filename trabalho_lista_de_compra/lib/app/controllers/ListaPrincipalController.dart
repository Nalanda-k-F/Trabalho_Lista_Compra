import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/bd.dart';

class ListaPrincipalController extends ChangeNotifier {
  final BuildContext context;
  Database? _db;
  List<Map<String, dynamic>> _listas = [];
  final int _userId;

  ListaPrincipalController(this.context, this._userId);

  Future<void> initDatabase() async {
    try {
      _db = await ListaDatabase();
      await _fetchListas();
    } catch (e) {
      _mostrarMensagem('Erro ao inicializar o banco de dados: $e', Colors.red);
    }
  }
  

  Future<void> _fetchListas() async {
    try {
      final listas = await _db?.query(
        'Listas',
        where: 'id_usu_fk = ?',
        whereArgs: [_userId],
      );
      _listas = listas ?? [];
      notifyListeners(); // Notifica que a lista foi atualizada
    } catch (e) {
      _mostrarMensagem('Erro ao buscar listas: $e', Colors.red);
    }
  }

  Future<void> searchList(String query) async {
    try {
      if (query.isEmpty) {
        await _fetchListas(); // Se a busca estiver vazia, recarregue todas as listas
      } else {
        final listas = await _db?.query(
          'Listas',
          where: 'id_usu_fk = ? AND nome_lista LIKE ?',
          whereArgs: [_userId, '%$query%'],
        );
        _listas = listas ?? [];
      }
      notifyListeners(); // Notifica que a lista foi atualizada
    } catch (e) {
      _mostrarMensagem('Erro ao buscar listas: $e', Colors.red);
    }
  }

  List<Map<String, dynamic>> get listas => _listas;

  void novaLista() {
  Navigator.pushNamed(
    context,
    '/telaCadastro',
    arguments: {'userId': _userId}, 
  ).then((_) {
    _fetchListas();
  });
}


  Future<void> visualizarLista(int id, String nome,int userId) async {
    try {
      final listas = await _db?.query('Listas', where: 'id_lista = ?', whereArgs: [id]);

      if (listas != null && listas.isNotEmpty) {
        final lista = listas.first;
        final status = lista['status_lista'];
        final dataCriacao = lista['data_criacao_lista'];

        if (status == 'Finalizado') {
          Navigator.pushNamed(
            context,
            '/visualizarFinalizado',
            arguments: {
              'idLista': id,
              'nomeLista': nome,
              'dataCriacao': dataCriacao,
              'id_usu_fk': userId,
            },
          );
        } else {
          Navigator.pushNamed(
            context,
            '/visualizar',
            arguments: {
              'idLista': id,
              'nomeLista': nome,
              'id_usu_fk': userId,
            },
          );
        }
      }
    } catch (e) {
      _mostrarMensagem('Erro ao visualizar lista: $e', Colors.red);
    }
  }

  Future<void> editarLista(int id, String nome, int userId) async {
    Navigator.pushNamed(
      context,
      '/editar',
      arguments: {
        'idLista': id,
        'nomeLista': nome,
        'id_usu_fk': userId,
      },
    ).then((_) {
      _fetchListas();
    });
  }

Future<bool> deletarLista(int id) async {
    try {
      final result = await _db?.delete('Listas', where: 'id_lista = ?', whereArgs: [id]);
      return result != 0; // Retorna true se a deleção foi bem-sucedida
    } catch (e) {
      print("Erro ao deletar lista: $e");
      return false;
    }
  }


  Color getStatusColor(String status) {
    switch (status) {
      case 'Em Andamento':
        return Colors.orange;
      case 'Finalizado':
        return Colors.green;
      case 'Cancelado':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sair'),
          content: Text('Você realmente deseja sair?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarMensagem(String mensagem, Color corFundo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensagem,
          style: TextStyle(color: Colors.white), // Texto em branco
        ),
        backgroundColor: corFundo, // Cor de fundo configurada
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.0),
      ),
    );
  }
}
