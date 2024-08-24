import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/bd.dart';



class CadastroListaController {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();
  final List<Map<String, String>> itens = [];
  DateTime? dataInicio;
  String nomeLista = '';
  String? unidadeSelecionada;
  final List<String> unidades = ['Kg', 'Litro', 'Unidade'];

  Future<Database> _getDatabase() async {
    return await initializeDatabase();
  }

  void adicionarItem(VoidCallback updateUI, BuildContext context) async {
    if (itemController.text.isEmpty ||
        quantidadeController.text.isEmpty ||
        unidadeSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    // Inserir item na tabela Itens
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
      'id_item': idItem.toString(),
      'nome': itemController.text,
      'quantidade': quantidadeController.text,
      'unidade': unidadeSelecionada!,
    });
    itemController.clear();
    quantidadeController.clear();
    unidadeSelecionada = null;

    updateUI();
  }

  void removerItem(int index, VoidCallback updateUI, BuildContext context) async {
    final db = await _getDatabase();
    final idItem = int.parse(itens[index]['id_item']!);

    // Deletar o item da tabela Itens
    await db.delete('Itens', where: 'id_item = ?', whereArgs: [idItem]);

    itens.removeAt(index);
    updateUI();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 10),
            Expanded(child: Text('O item foi removido da lista')),
          ],
        ),
      ),
    );
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
    final db = await _getDatabase();

    // Inserir a lista na tabela Listas
    final idLista = await db.insert('Listas', {
      'nome_lista': nomeLista,
      'data_criacao_lista': dataInicio?.toIso8601String(),
      // Adicione outras colunas conforme necessário
    });

    // Inserir os itens na tabela ListaItens
    for (var item in itens) {
      await db.insert('ListaItens', {
        'quantidade_lista_item': int.parse(item['quantidade']!),
        'id_lista_fk': idLista,
        'id_item_fk': int.parse(item['id_item']!),
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lista salva com sucesso')),
    );

    // Limpar os dados após salvar
    nomeLista = '';
    dataInicio = null;
    itens.clear();
  }

  void cancelarLista(VoidCallback updateUI) {
    nomeLista = '';
    dataInicio = null;
    itens.clear();
    updateUI();
  }
}
