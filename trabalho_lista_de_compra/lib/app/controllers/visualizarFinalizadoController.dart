import 'package:intl/intl.dart'; 
import 'package:sqflite/sqflite.dart';

class VisualizarFinalizadoController {
  final Database db;
  final int idLista;
  List<Map<String, dynamic>> itens = [];
  Map<String, dynamic>? lista;

  VisualizarFinalizadoController(this.db, this.idLista);

  Future<void> fetchItens() async {
    try {
      final List<Map<String, dynamic>> listaMaps = await db.query(
        'Listas',
        where: 'id_lista = ?',
        whereArgs: [idLista],
      );

      if (listaMaps.isNotEmpty) {
        lista = listaMaps.first;
      } else {
        throw Exception('Lista não encontrada.');
      }

      final List<Map<String, dynamic>> maps = await db.query(
        'ListaItens',
        where: 'id_lista_fk = ?',
        whereArgs: [idLista],
      );

      final List<Map<String, dynamic>> unidadesDb =
          await db.query('UnidadesMedida');
      final unidadesMap = {
        for (var u in unidadesDb) u['id_unidade_medida']: u['nome_unidade']
      };

      itens = await Future.wait(maps.map((map) async {
        final nomeItemList = await db.query('Itens',
            where: 'id_item = ?', whereArgs: [map['id_item_fk']]);
        final nomeItem = nomeItemList.isNotEmpty
            ? nomeItemList.first['nome_item']
            : 'Desconhecido';

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
      print('Erro ao buscar lista e itens: $e');
    }
  }

  // Formatar a data para 'dd/MM/yyyy'
  String? get dataCriacaoFormatted {
    final dataCriacaoStr = lista?['data_criacao_lista'] as String?;
    if (dataCriacaoStr != null) {
      try {
        final dateTime = DateTime.parse(dataCriacaoStr);
        final dateFormat = DateFormat('dd/MM/yyyy'); // Formato desejado
        return dateFormat.format(dateTime);
      } catch (e) {
        print('Erro ao formatar a data: $e');
      }
    }
    return null;
  }

  double? get precoTotal => lista?['preco_total'];
}
