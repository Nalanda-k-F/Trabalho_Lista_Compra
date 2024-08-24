import 'package:flutter/material.dart';
import '../controllers/ListaPrincipalController.dart';

class TelaListas extends StatefulWidget {
  @override
  _TelaListasState createState() => _TelaListasState();
}

class _TelaListasState extends State<TelaListas> {
  late ListaPrincipalController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ListaPrincipalController(context);
    _controller.initDatabase().then((_) {
      setState(() {}); // Atualiza a tela após as listas serem carregadas
    });
  }

  @override
  void dispose() {
    _controller.searchController.removeListener(() {
      setState(() {});
    });
    _controller.searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3A776),
      appBar: AppBar(
        backgroundColor: Color(0xFFE3A776),

        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Lógica para sair
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller.searchController,
              style: TextStyle(
                color: Color.fromARGB(255, 1, 1, 1),
                fontWeight: FontWeight.bold, // Adiciona o texto em negrito
              ),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontFamily: "WorkSansLight",
                  fontSize: 15.0,
                ),
                filled: true,
                fillColor: Colors.white24,
                hintText: "Buscar por nome",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide(
                    color: Colors.white24,
                    width: 0.5,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 6, 6, 6),
                ),
              ),
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
                itemCount: _controller.filteredListas.length,
                itemBuilder: (context, index) {
                  final lista = _controller.filteredListas[index];
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
                              onPressed: () => _controller
                                  .visualizarLista(lista['id_lista']),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.orange),
                              onPressed: () {
                                if (lista['status_lista'] == 'Em Andamento') {
                                  _controller.editarLista(lista['id_lista']);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Esta lista está finalizada e não pode ser editada.')),
                                  );
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                bool sucesso = await _controller.deletarLista(lista['id_lista']);
                                if (sucesso) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Lista deletada com sucesso.'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Erro ao deletar a lista.'),
                                    ),
                                  );
                                }
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
