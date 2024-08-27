import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/bd.dart';

class ListaPrincipalController extends ChangeNotifier {
  final BuildContext context;
  Database? _db;
  List<Map<String, dynamic>> _listas = [];

  ListaPrincipalController(this.context);

  Future<void> initDatabase() async {
    try {
      _db = await ListaDatabase();
      await _fetchListas();
    } catch (e) {
      print("Erro ao inicializar o banco de dados: $e");
    }
  }

  Future<void> _fetchListas() async {
    try {
      final listas = await _db?.query('Listas');
      _listas = listas ?? [];
      notifyListeners(); // Notifica que a lista foi atualizada
    } catch (e) {
      print("Erro ao buscar listas: $e");
    }
  }

  Future<void> searchList(String query) async {
    try {
      if (query.isEmpty) {
        await _fetchListas(); // Se a busca estiver vazia, recarregue todas as listas
      } else {
        final listas = await _db?.query(
          'Listas',
          where: 'nome_lista LIKE ?',
          whereArgs: ['%$query%'],
        );
        _listas = listas ?? [];
      }
      notifyListeners(); // Notifica que a lista foi atualizada
    } catch (e) {
      print("Erro ao buscar listas: $e");
    }
  }

  List<Map<String, dynamic>> get listas => _listas;

  void novaLista() {
    Navigator.pushNamed(context, '/telaCadastro').then((_) {
      _fetchListas();
    });
  }

  void visualizarLista(int id, String nome) {
    Navigator.pushNamed(
      context,
      '/visualizar',
      arguments: {
        'idLista': id,
        'nomeLista': nome,
      },
    ).then((_) {
      _fetchListas();
    });
  }

  Future<void> editarLista(int id, String nome) async {
    try {
      final listas = await _db?.query('Listas', where: 'id_lista = ?', whereArgs: [id]);
      if (listas != null && listas.isNotEmpty) {
        final lista = listas.first;
        final status = lista['status_lista'];

        if (status != 'Finalizado') {
          Navigator.pushNamed(
            context,
            '/editar',
            arguments: {'id': id, 'nome': nome},
          ).then((_) {
            _fetchListas();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Esta lista está finalizada e não pode ser editada.')),
          );
        }
      }
    } catch (e) {
      print("Erro ao editar lista: $e");
    }
  }

  Future<bool> deletarLista(int id) async {
    try {
      if (_db != null) {
        await _db!.delete('ListaItens', where: 'id_lista_fk = ?', whereArgs: [id]);
        await _db!.delete('Listas', where: 'id_lista = ?', whereArgs: [id]);
        await _fetchListas();
        return true;
      }
      return false;
    } catch (e) {
      print("Erro ao deletar lista: $e");
      return false;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Em Andamento':
        return Colors.red;
      case 'Finalizado':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sair'),
          content: Text('Você tem certeza que deseja sair?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sair'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }
}
