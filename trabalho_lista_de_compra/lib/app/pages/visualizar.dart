import 'package:flutter/material.dart';
import '../controllers/visualizarController.dart';
import '../../database/bd.dart';
import '../widgets/custom_button.dart';

class Visualizar extends StatefulWidget {
  final int idLista;
  final String nomeLista;

  Visualizar({required this.idLista, required this.nomeLista});

  @override
  _VisualizarState createState() => _VisualizarState();
}

class _VisualizarState extends State<Visualizar> {
  VisualizarListaController? _controller;
  late Future<void> _fetchData;

  @override
  void initState() {
    super.initState();
    _fetchData = _initController();
  }

  Future<void> _initController() async {
    try {
      final db = await ListaDatabase();
      _controller = VisualizarListaController(db, widget.idLista);
      await _controller!.fetchItens();
      // print('Itens após fetch: ${_controller!.itens}');

      setState(() {});
    } catch (e) {
      print("Erro ao inicializar controlador: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3A776),
      appBar: AppBar(
        backgroundColor: Color(0xFFE3A776),
        title: Text('Visualizar Lista'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
           onPressed: () {
             Navigator.pushNamed(context, '/telaPrincipal');
          },
        ),
      ),
      body: FutureBuilder<void>(
        future: _fetchData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar os dados: ${snapshot.error}'));
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (_controller == null) {
              return Center(child: Text('Controlador não inicializado.'));
            }
            if (_controller!.itens.isEmpty) {
              return Center(child: Text('Nenhum item encontrado.'));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shopping_cart, size: 30),
                        SizedBox(width: 10),
                        Text(
                          widget.nomeLista,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _controller!.itens.length,
                      itemBuilder: (context, index) {
                        final item = _controller!.itens[index];
                        final bool isChecked = item['comprado'] == 1;

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
                            contentPadding: EdgeInsets.all(16.0),
                            leading: Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) async {
                                if (value != null) {
                                  await _controller!.marcarComoComprado(
                                      item['id_lista_item'], value ? 1 : 0);
                                  await _controller!.fetchItens();
                                  setState(() {});
                                }
                              },
                            ),
                            title: Text(
                              item['nome_item'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quantidade: ${item['quantidade_lista_item']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'UN: ${item['nome_unidade']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: _controller!.precoController,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: "WorkSansLight",
                          fontSize: 15.0,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Valor Total',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.5),
                            width: 0.5,
                          ),
                        ),
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                    SizedBox(height: 16),
                    CustomButton(
                      text: 'Finalizar Compra',
                      onPressed: () async {
                        if (_controller != null) {
                          await _controller!.finalizarCompra(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('Erro inesperado'));
          }
        },
      ),
    );
  }
}
