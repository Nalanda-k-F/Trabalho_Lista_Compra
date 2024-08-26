import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class VisualizarListaController {
  final Database db;
  final int idLista;
  List<Map<String, dynamic>> itens = [];
  List<Map<String, dynamic>> unidades = [];
  final TextEditingController precoController = TextEditingController();
  String? unidadeSelecionada;

  VisualizarListaController(this.db, this.idLista);

  Future<void> fetchItens() async {
    try {
      // Consulta a tabela ListaItens para os itens associados à lista especificada
      final List<Map<String, dynamic>> maps = await db.query(
        'ListaItens',
        where: 'id_lista_fk = ?',
        whereArgs: [idLista],
      );

      // Obtém todas as unidades de medida e cria um mapa para rápida busca
      final List<Map<String, dynamic>> unidadesDb =
          await db.query('UnidadesMedida');
      final unidadesMap = {
        for (var u in unidadesDb) u['id_unidade_medida']: u['nome_unidade']
      };

      // Processa cada item da lista de itens
      itens = await Future.wait(maps.map((map) async {
        // Obtém o nome do item a partir do ID do item
        final nomeItemList = await db.query('Itens',
            where: 'id_item = ?', whereArgs: [map['id_item_fk']]);
        final nomeItem = nomeItemList.isNotEmpty
            ? nomeItemList.first['nome_item']
            : 'Desconhecido';

        // Obtém o nome da unidade de medida
        final idUnidade = nomeItemList.isNotEmpty
            ? nomeItemList.first['id_unidade_medida_fk']
            : null;
        final nomeUnidade = idUnidade != null
            ? unidadesMap[idUnidade] ?? 'Desconhecida'
            : 'Desconhecida';

        return {
          'id_lista_item': map['id_lista_item'],
          'quantidade_lista_item': map['quantidade_lista_item'],
          'comprado': map['comprado_lista_item'],
          'nome_item': nomeItem,
          'nome_unidade': nomeUnidade,
        };
      }).toList());

      print('Itens processados: $itens');
    } catch (e) {
      print('Erro ao buscar itens: $e');
    }
  }

  Future<void> marcarComoComprado(int idListaItem, int status) async {
    await db.update(
      'ListaItens',
      {'comprado_lista_item': status},
      where: 'id_lista_item = ?',
      whereArgs: [idListaItem],
    );
  }

Future<void> finalizarCompra(BuildContext context) async {
  try {
    // Obter o valor do preço total do TextEditingController
    final precoTotalStr = precoController.text.trim();
    print('Preço Total: $precoTotalStr');

    final precoTotal = double.tryParse(precoTotalStr);
    if (precoTotal == null) {
      print('Erro: Valor inválido para preço total');
      throw Exception('Valor inválido para preço total');
    }

    // Verificar se idLista é válido
    if (idLista <= 0) {
      print('Erro: idLista inválido');
      throw Exception('idLista inválido');
    }

    // Atualizar a tabela Listas
    final result = await db.update(
      'Listas',
      {
        'status_lista': 'Finalizado',
        'preco_total': precoTotal,
      },
      where: 'id_lista = ?',
      whereArgs: [idLista],
    );
    print('Resultado da atualização: $result');

    if (result == 0) {
      print('Nenhuma linha atualizada. Verifique se o id_lista existe.');
      throw Exception('Nenhuma linha atualizada. Verifique se o id_lista existe.');
    }

    // Mostrar a mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compra finalizada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    // Tratar erros
    print('Erro ao finalizar a compra: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erro ao finalizar a compra 2: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}



 //
}
