import 'package:flutter/material.dart';
import '../controllers/ListaPrincipalController.dart';

class TelaListas extends StatefulWidget {
  final int userId;
  TelaListas({required this.userId});

  @override
  _TelaListasState createState() => _TelaListasState();
}

class _TelaListasState extends State<TelaListas> {
  late ListaPrincipalController _controller;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = ListaPrincipalController(context, widget.userId);
    _controller.initDatabase().then((_) {
      setState(() {}); // Atualiza a tela após as listas serem carregadas
    });
  }

  void _searchList() {
    setState(() {
      _controller.searchList(_searchQuery);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3A776),
      appBar: AppBar(
        backgroundColor: Color(0xFFE3A776),
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            _controller.showLogoutDialog(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontFamily: "WorkSansLight",
                  fontSize: 15.0,
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 253, 253),
                hintText: 'Nome da Lista',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(255, 255, 255, 0.239),
                    width: 0.5,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchList,
                ),
              ),
              style: TextStyle(
                color: Color.fromARGB(255, 1, 1, 1),
                fontWeight: FontWeight.bold,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _controller.novaLista,
              icon: Icon(Icons.add),
              label: Text('Nova Lista'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF0A7744), // Cor de fundo verde
                onPrimary: Colors.white, // Cor do texto branco
                padding: EdgeInsets.symmetric(
                    horizontal: 25, vertical: 15), // Tamanho do botão
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _controller.listas.length,
                itemBuilder: (context, index) {
                  final lista = _controller.listas[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.all(12),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lista['nome_lista'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Status: ${lista['status_lista']}',
                                style: TextStyle(
                                  color: _controller
                                      .getStatusColor(lista['status_lista']),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.visibility, color: Colors.blue),
                              onPressed: () {
                                final id = lista['id_lista'];
                                final nome = lista['nome_lista'];
                                final userId = lista['id_usu_fk'];
                                _controller.visualizarLista(id, nome, userId);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.orange),
                              onPressed: () {
                                final id = lista['id_lista'];
                                final nome = lista['nome_lista'];
                                final userId = lista['id_usu_fk'];
                                if (lista['status_lista'] == 'Em Andamento') {
                                  _controller.editarLista(id, nome, userId);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Esta lista está finalizada e não pode ser editada.'),
                                    ),
                                  );
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                bool sucesso = await _controller
                                    .deletarLista(lista['id_lista']);
                                if (sucesso) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Color.fromARGB(255, 3, 129, 15),
                                      content:
                                          Text('Lista deletada com sucesso.'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                       backgroundColor: Color.fromARGB(255, 111, 0, 0),
                                      content: Text('Erro ao deletar a lista.'),
                                    ),
                                  );
                                }
                                // Atualiza a tela após a deleção
                                setState(() {
                                  Navigator.pushNamed(
                                    context,
                                    '/telaPrincipal',
                                    arguments: {'userId': widget.userId},
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
