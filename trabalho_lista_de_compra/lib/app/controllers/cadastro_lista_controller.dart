import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/bd.dart'; // Importa a função de inicializaç

class CadastroListaController {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();
  final List<Map<String, String>> itens = [];
  DateTime? dataInicio;
  String nomeLista = '';
  String? unidadeSelecionada;
  final List<String> unidades = ['Kg', 'Litro', 'Unidade'];

  void adicionarItem(VoidCallback updateUI, BuildContext context) {
    if (itemController.text.isEmpty ||
        quantidadeController.text.isEmpty ||
        unidadeSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    itens.add({
      'nome': itemController.text,
      'quantidade': quantidadeController.text,
      'unidade': unidadeSelecionada!,
    });
    itemController.clear();
    quantidadeController.clear();
    unidadeSelecionada = null;

    updateUI();
  }

  void removerItem(int index, VoidCallback updateUI, BuildContext context) {
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
    if (nomeLista.isEmpty || itens.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha o nome da lista e adicione pelo menos um item')),
      );
      return;
    }

    // Aqui você pode adicionar a lógica para salvar a lista e os itens no banco de dados

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lista salva com sucesso')),
    );
  }
}
