import 'package:flutter/material.dart';
import '../controllers/cadastro_lista_controller.dart';
import 'package:intl/intl.dart';
// Importando o controlador

class TelaCadastro extends StatefulWidget {
  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  late CadastroListaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CadastroListaController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela da Lista'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vamos Montar a Lista!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _controller.itemController,
              decoration: InputDecoration(labelText: 'Nome do Item'),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _controller.unidadeSelecionada,
                    hint: Text('Unidade de Medida'),
                    items: _controller.unidades.map((unidade) {
                      return DropdownMenuItem<String>(
                        value: unidade,
                        child: Text(unidade),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _controller.unidadeSelecionada = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _controller.quantidadeController,
                    decoration: InputDecoration(labelText: 'Quantidade'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _controller.adicionarItem(() => setState(() {}), context),
              child: Text('Adicionar Item'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _controller.itens.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${_controller.itens[index]['nome']} (${_controller.itens[index]['quantidade']} ${_controller.itens[index]['unidade']})'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _controller.removerItem(index, () => setState(() {}), context),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Nome da Lista'),
              onChanged: (value) {
                setState(() {
                  _controller.nomeLista = value;
                });
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _controller.selecionarData(context, () => setState(() {})),
              child: Text(_controller.dataInicio == null
                  ? 'Selecionar Data'
                  : 'Data: ${DateFormat('dd/MM/yyyy').format(_controller.dataInicio!)}'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _controller.salvarLista(context),
                    child: Text('SALVAR'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Voltar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


