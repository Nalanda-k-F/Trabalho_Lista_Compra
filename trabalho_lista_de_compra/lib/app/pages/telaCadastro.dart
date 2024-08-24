import 'package:flutter/material.dart';
import '../controllers/cadastro_lista_controller.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_button.dart'; // Importe o arquivo onde você definiu o CustomButton

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
      backgroundColor: Color(0xFFE3A776),
      appBar: AppBar(
        backgroundColor: Color(0xFFE3A776),
        title: Text('Voltar'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Volta para a página anterior
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
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              color: Color(0xFFE3A776),
              child: Text(
                'Vamos Montar a Lista!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  TextFormField(
                    style: TextStyle(
                      color: Color.fromARGB(255, 1, 1, 1),
                      fontWeight: FontWeight.bold,
                    ),
                    controller: _controller.itemController,
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
                  Container(
                    width: double.infinity,
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      icon: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    child: TextField(
                      controller: _controller.quantidadeController,
                      style: TextStyle(
                        color: Color.fromARGB(255, 1, 1, 1),
                        fontWeight: FontWeight.bold,
                      ),
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  SizedBox(height: 16),
                  CustomButton(
                    text: 'Adicionar Item',
                    onPressed: () => _controller.adicionarItem(() => setState(() {}), context),
                  ),
                  SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _controller.itens.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white, // Fundo branco
                          borderRadius: BorderRadius.circular(15.0), // Borda arredondada
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12), // Espaçamento interno
                          title: Text(
                            '${_controller.itens[index]['nome']} (${_controller.itens[index]['quantidade']} ${_controller.itens[index]['unidade']})',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red), // Ícone vermelho
                            onPressed: () => _controller.removerItem(index, () => setState(() {}), context),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Nome da Lista',
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
                    onChanged: (value) {
                      setState(() {
                        _controller.nomeLista = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      onPressed: () => _controller.selecionarData(context, () => setState(() {})),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 155, 130, 84),
                        onPrimary: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            _controller.dataInicio == null
                                ? 'Selecionar Data'
                                : 'Data: ${DateFormat('dd/MM/yyyy').format(_controller.dataInicio!)}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'SALVAR',
                          onPressed: () => _controller.salvarLista(context),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomButton(
                          text: 'Cancelar',
                          onPressed: () {
                            _controller.cancelarLista(() => setState(() {}));
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
