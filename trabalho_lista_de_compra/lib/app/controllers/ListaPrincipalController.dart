import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/bd.dart';

class ListaPrincipalController extends ChangeNotifier {
  final BuildContext context;
  Database? _db;
  List<Map<String, dynamic>> _listas = [];
  List<Map<String, dynamic>> _filteredListas = [];
  final TextEditingController searchController = TextEditingController();

  ListaPrincipalController(this.context) {
    searchController.addListener(_filterListas);
  }

  Future<void> initDatabase() async {
    try {
      _db = await initializeDatabase();
      await _fetchListas();
    } catch (e) {
      // Lidar com erros de inicialização do banco de dados
      print("Erro ao inicializar o banco de dados: $e");
    }
  }

 Future<void> _fetchListas() async {
  try {
    final listas = await _db?.query('Listas');
    _listas = listas ?? [];
    _filterListas(); // Atualiza a lista filtrada
  } catch (e) {
    print("Erro ao buscar listas: $e");
  }
}


  void _filterListas() {
    final query = searchController.text.toLowerCase();
    _filteredListas = _listas.where((lista) {
      return lista['nome_lista'].toLowerCase().contains(query);
    }).toList();
    notifyListeners();
  }

  void novaLista() {
    Navigator.pushNamed(context, '/telaCadastro').then((_) {
      _fetchListas();
    });
  }

  void visualizarLista(int id) {
    Navigator.pushNamed(context, '/visualizar_lista', arguments: id);
  }

  Future<void> editarLista(int id) async {
    try {
      final listas = await _db?.query('Listas', where: 'id_lista = ?', whereArgs: [id]);
      if (listas != null && listas.isNotEmpty) {
        final lista = listas.first;
        final status = lista['status_lista'];

        if (status != 'Finalizado') {
          Navigator.pushNamed(context, '/editar_lista', arguments: id).then((_) {
            _fetchListas();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Esta lista está finalizada e não pode ser editada.')),
          );
        }
      }
    } catch (e) {
      // Lidar com erros de consulta ao banco de dados
      print("Erro ao editar lista: $e");
    }
  }

 Future<bool> deletarLista(int id) async {
  try {
    if (_db != null) {
      // Primeiro, remover os registros da tabela ListaItens que referenciam a lista
      await _db!.delete(
        'ListaItens',
        where: 'id_lista_fk = ?',
        whereArgs: [id],
      );

      // Agora, remover a lista da tabela Listas
      await _db!.delete(
        'Listas',
        where: 'id_lista = ?',
        whereArgs: [id],
      );

      // Atualizar a lista de listas
      await _fetchListas();
      return true; // Deleção bem-sucedida
    }
    return false; // Banco de dados não disponível
  } catch (e) {
    // Lidar com erros de deleção no banco de dados
    print("Erro ao deletar lista: $e");
    return false; // Erro durante a deleção
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

  List<Map<String, dynamic>> get filteredListas => _filteredListas;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
