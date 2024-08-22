import 'package:flutter/material.dart';
import '../controllers/usuario_controller.dart';
import '../widgets/background_image.dart';
import '../widgets/custom_button.dart';

class Cadastrar extends StatefulWidget {
  @override
  _CadastrarState createState() => _CadastrarState();
}

class _CadastrarState extends State<Cadastrar> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmacaoSenhaController = TextEditingController();

  final UsuarioController _usuarioController = UsuarioController();

  void _cadastrarUsuario() {
    final nome = _nomeController.text;
    final email = _emailController.text;
    final senha = _senhaController.text;
    final confirmacaoSenha = _confirmacaoSenhaController.text;

    _usuarioController.cadastrarUsuario(
      context: context,
      nome: nome,
      email: email,
      senha: senha,
      confirmacaoSenha: confirmacaoSenha,
      limparCampos: _limparCampos, // Passar função para limpar campos
    );
  }

  void _limparCampos() {
    setState(() {
      _nomeController.clear();
      _emailController.clear();
      _senhaController.clear();
      _confirmacaoSenhaController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(
              imagePath: 'img/imagem2.jpg'), // Substitua pelo caminho correto
          // Conteúdo sobre a imagem de fundo
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _senhaController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _confirmacaoSenhaController,
                  decoration: InputDecoration(
                    labelText: 'Confirmação da Senha',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: 'Cadastrar',
                  onPressed: _cadastrarUsuario,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
