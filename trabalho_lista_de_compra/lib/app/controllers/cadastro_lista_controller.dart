import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/bd.dart';

class CadastroListaController {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();
  final List<Map<String, dynamic>> itens = [];
  DateTime? dataInicio;
  String nomeLista = '';
  String? unidadeSelecionada;
  final List<String> unidades = ['Kg', 'Litro', 'Unidade'];

  Future<Database> _getDatabase() async {
    return await ListaDatabase();
  }

  void adicionarItem(VoidCallback updateUI, BuildContext context) async {
    if (itemController.text.isEmpty ||
        quantidadeController.text.isEmpty ||
        unidadeSelecionada == null) {
      _showSnackBar(context, 'Preencha todos os campos', Colors.red);
      return;
    }

    try {
      final db = await _getDatabase();
      final idItem = await db.insert(
        'Itens',
        {
          'nome_item': itemController.text,
          'quantidade_item': double.parse(quantidadeController.text),
          'id_unidade_medida_fk': unidades.indexOf(unidadeSelecionada!) + 1,
        },
      );

      itens.add({
        'id_item': idItem,
        'nome': itemController.text,
        'quantidade': quantidadeController.text,
        'unidade': unidadeSelecionada!,
      });
      itemController.clear();
      quantidadeController.clear();
      unidadeSelecionada = null;

      updateUI();
      _showSnackBar(context, 'Item adicionado com sucesso', Colors.green);
    } catch (e) {
      _showSnackBar(context, 'Erro ao adicionar item: $e', Colors.red);
    }
  }

  void removerItem(int index, VoidCallback updateUI, BuildContext context) async {
    try {
      final db = await _getDatabase();
      final idItem = int.parse(itens[index]['id_item'].toString());

      await db.delete('Itens', where: 'id_item = ?', whereArgs: [idItem]);

      itens.removeAt(index);
      updateUI();
      _showSnackBar(context, 'O item foi removido da lista', Colors.orange);
    } catch (e) {
      _showSnackBar(context, 'Erro ao remover item: $e', Colors.red);
    }
  }

  Future<void> selecionarData(BuildContext context, VoidCallback updateUI) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != dataInicio) {
      dataInicio = picked;
      updateUI();
    }
  }

  void salvarLista(BuildContext context) async {
    try {
      final db = await _getDatabase();

      final idLista = await db.insert('Listas', {
        'nome_lista': nomeLista,
        'data_criacao_lista': dataInicio?.toIso8601String(),
        // Adicione outras colunas conforme necessário
      });

      for (var item in itens) {
        await db.insert('ListaItens', {
          'quantidade_lista_item': double.parse(item['quantidade'].toString()),
          'id_lista_fk': idLista,
          'id_item_fk': int.parse(item['id_item'].toString()),
        });
      }

      _showSnackBar(context, 'Lista salva com sucesso', Colors.green);

      nomeLista = '';
      dataInicio = null;
      itens.clear();
    } catch (e) {
      _showSnackBar(context, 'Erro ao salvar lista: $e', Colors.red);
    }
  }

  void cancelarLista(VoidCallback updateUI) {
    nomeLista = '';
    dataInicio = null;
    itens.clear();
    updateUI();
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 2),
      ),
    );
  }  //
}
