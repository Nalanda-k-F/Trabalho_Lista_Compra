import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/bd.dart'; // Ajuste o caminho conforme necessário

class EditarListaController {
  final Database db;
  final int idLista;
  List<Map<String, dynamic>> itens = [];
  List<Map<String, dynamic>> unidades = [];
  TextEditingController itemController = TextEditingController();
  TextEditingController quantidadeController = TextEditingController();
  String? unidadeSelecionada;

  EditarListaController(this.db, this.idLista);
  
  Future<void> fetchItens() async {
  itens = await db.rawQuery('''
    SELECT i.*, um.nome_unidade, li.quantidade_lista_item
    FROM Itens i
    INNER JOIN UnidadesMedida um ON i.id_unidade_medida_fk = um.id_unidade_medida
    INNER JOIN ListaItens li ON i.id_item = li.id_item_fk
    WHERE li.id_lista_fk = ?
    ORDER BY i.id_item
  ''', [idLista]);

  print("Itens carregados: $itens");
}

  Future<void> fetchUnidades() async {
    final unidadesDb = await db.query('UnidadesMedida');
    unidades = unidadesDb.map((unidade) => {
          'id_unidade_medida': unidade['id_unidade_medida'],
          'nome_unidade': unidade['nome_unidade']
        }).toList();
    print("Unidades carregadas: $unidades");
  }

  Future<void> adicionarItem(BuildContext context) async {
  final nome = itemController.text;
  final quantidade = double.tryParse(quantidadeController.text) ?? 0;

  if (nome.isNotEmpty && unidadeSelecionada != null) {
    final unidadeSelecionadaId = unidades.firstWhere(
      (unidade) => unidade['nome_unidade'] == unidadeSelecionada,
      orElse: () => {'id_unidade_medida': 0}
    )['id_unidade_medida'];

    print("Unidade selecionada ID: $unidadeSelecionadaId");

    final existingItem = await db.query(
      'Itens',
      where: 'nome_item = ? AND id_unidade_medida_fk = ?',
      whereArgs: [nome, unidadeSelecionadaId],
    );

    int idItem;
    if (existingItem.isEmpty) {
      idItem = await db.insert('Itens', {
        'nome_item': nome,
        'quantidade_item': quantidade, // Adiciona quantidade ao novo item
        'id_unidade_medida_fk': unidadeSelecionadaId,
      }) ?? 0;
    } else {
      idItem = existingItem.first['id_item'] as int;
    }

    final existingListaItem = await db.query(
      'ListaItens',
      where: 'id_item_fk = ? AND id_lista_fk = ?',
      whereArgs: [idItem, idLista],
    );

    if (existingListaItem.isEmpty) {
      await db.insert('ListaItens', {
        'id_lista_fk': idLista,
        'id_item_fk': idItem,
        'quantidade_lista_item': quantidade, // Adiciona a quantidade correta
      });
    } else {
      await db.update(
        'ListaItens',
        {'quantidade_lista_item': quantidade},
        where: 'id_item_fk = ? AND id_lista_fk = ?',
        whereArgs: [idItem, idLista],
      );
    }

    await fetchItens();
    itemController.clear();
    quantidadeController.clear();
    unidadeSelecionada = null;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item adicionado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Por favor, preencha todos os campos corretamente.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  Future<void> removerItem(int index, BuildContext context) async {
    final idItem = itens[index]['id_item'];

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 10),
            Text('Confirmar'),
          ],
        ),
        content: Text('Deseja realmente remover este item? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Remover'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await db.delete(
          'ListaItens',
          where: 'id_item_fk = ? AND id_lista_fk = ?',
          whereArgs: [idItem, idLista],
        );
        await fetchItens();
        // Mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item removido com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print("Erro ao remover item: $e");
        // Mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao remover o item.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void cancelarLista(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> salvarLista(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lista salva com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
