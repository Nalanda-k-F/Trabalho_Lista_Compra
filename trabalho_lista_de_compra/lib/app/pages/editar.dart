import 'package:flutter/material.dart';
import '../controllers/editarController.dart';
import '../../database/bd.dart';
import '../widgets/custom_button.dart';

class Editar extends StatefulWidget {
  final int idLista;
  final String nomeLista;

  Editar({required this.idLista, required this.nomeLista});

  @override
  _EditarState createState() => _EditarState();
}

class _EditarState extends State<Editar> {
  EditarListaController? _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    try {
      final db = await ListaDatabase();
      _controller = EditarListaController(db, widget.idLista);
      await _controller!.fetchItens();
      await _controller!.fetchUnidades();
      setState(() {}); // Atualiza a interface após carregar os dados
    } catch (e) {
      print("Erro ao inicializar controlador: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Editar Lista'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFE3A776),
      appBar: AppBar(
        backgroundColor: Color(0xFFE3A776),
        title: Text('Voltar'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                color: Color(0xFFE3A776),
                child: Text(
                  'Editar ${widget.nomeLista}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _controller!.itemController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: "WorkSansLight",
                    fontSize: 15.0,
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 253, 253),
                  hintText: 'Nome do Item',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 255, 255, 0.239),
                      width: 0.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _controller!.quantidadeController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: "WorkSansLight",
                    fontSize: 15.0,
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 253, 253),
                  hintText: 'Quantidade',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 255, 255, 0.239),
                      width: 0.5,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _controller!.unidadeSelecionada ??
                    (_controller!.unidades.isNotEmpty
                        ? _controller!.unidades[0]['nome_unidade']
                        : null),
                items: _controller!.unidades
                    .map((unidade) => DropdownMenuItem<String>(
                          value: unidade['nome_unidade'],
                          child: Text(unidade['nome_unidade']),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _controller!.unidadeSelecionada = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 253, 253),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 255, 255, 0.239),
                      width: 0.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              CustomButton(
                text: 'Adicionar Item',
                onPressed: () async {
                  if (_controller != null) {
                    await _controller!.adicionarItem(context);
                    setState(
                        () {}); // Atualiza a interface após adicionar o item
                  }
                },
              ),
              SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _controller!.itens.length,
                itemBuilder: (context, index) {
                  final item = _controller!.itens[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(item['nome_item']),
                      subtitle: Text(
                        'Quantidade: ${item['quantidade_lista_item'] ?? 0} UN: ${item['nome_unidade']}',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _controller!.removerItem(index, context);
                          setState(
                              () {}); // Atualiza a interface após remover o item
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: 'Cancelar',
                    onPressed: () => _controller!.cancelarLista(context),
                  ),
                  CustomButton(
                    text: 'Salvar',
                    onPressed: () async {
                      await _controller!.salvarLista(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
