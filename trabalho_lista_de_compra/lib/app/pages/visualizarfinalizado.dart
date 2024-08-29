import 'package:flutter/material.dart';
import '../controllers/visualizarFinalizadoController.dart';
import '../../database/bd.dart';

class VisualizarFinalizado extends StatefulWidget {
  final int idLista;
  final String nomeLista;
  final int userId;

  VisualizarFinalizado(
      {required this.idLista, required this.nomeLista, required this.userId});

  @override
  _VisualizarFinalizadoState createState() => _VisualizarFinalizadoState();
}

class _VisualizarFinalizadoState extends State<VisualizarFinalizado> {
  VisualizarFinalizadoController? _controller;
  late Future<void> _fetchData;

  @override
  void initState() {
    super.initState();
    _fetchData = _initController();
  }

  Future<void> _initController() async {
    try {
      final db = await ListaDatabase();
      _controller = VisualizarFinalizadoController(db, widget.idLista);
      await _controller!.fetchItens();
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
        title: Text('Voltar'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
           Navigator.pushNamed(
              context,
              '/telaPrincipal',
              arguments: {'userId': widget.userId},
            );
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

            final dataCriacao = _controller!.dataCriacaoFormatted;
            final precoTotal = _controller!.precoTotal;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          size: 30,
                          color: Color.fromARGB(255, 49, 209, 49),
                        ),
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
                    SizedBox(height: 20),
                    Text(
                      'Data de Criação: ${dataCriacao ?? 'Não disponível'}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF003366),
                      ),
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
                            contentPadding: EdgeInsets.all(16.0),
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
                    Text(
                      'Valor Total: R\$ ${precoTotal?.toStringAsFixed(2) ?? '0.00'}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
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
