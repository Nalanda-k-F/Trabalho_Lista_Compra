import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../controllers/usuario_controller.dart';
import '../widgets/custom_button.dart';
import 'login.dart'; // Importe a tela de login

class Cadastrar extends StatefulWidget {
  @override
  _CadastrarState createState() => _CadastrarState();
}

class _CadastrarState extends State<Cadastrar> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmacaoSenhaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final UsuarioController _usuarioController = UsuarioController();

  bool _obscureTextSenha = true;
  bool _obscureTextConfirmacaoSenha = true;

  void _togglePasswordVisibilitySenha() {
    setState(() {
      _obscureTextSenha = !_obscureTextSenha;
    });
  }

  void _togglePasswordVisibilityConfirmacaoSenha() {
    setState(() {
      _obscureTextConfirmacaoSenha = !_obscureTextConfirmacaoSenha;
    });
  }

  void _cadastrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      final nome = _nomeController.text;
      final email = _emailController.text;
      final senha = _senhaController.text;
      final confirmacaoSenha = _confirmacaoSenhaController.text;

      final sucesso = await _usuarioController.cadastrarUsuario(
        context: context,
        nome: nome,
        email: email,
        senha: senha,
        confirmacaoSenha: confirmacaoSenha,
        limparCampos: _limparCampos,
      );
      
    }
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
          Positioned.fill(
            child: Image.asset(
              'img/imagem20.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 125, 112, 112).withOpacity(0.5),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      style: TextStyle(
                        color:  Color.fromARGB(255, 1, 1, 1),
                        fontWeight:
                            FontWeight.bold, // Adiciona o texto em negrito
                      ),
                      controller: _nomeController,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color:  Color.fromARGB(255, 0, 0, 0),
                            fontFamily: "WorkSansLight",
                            fontSize: 15.0),
                        filled: true,
                        fillColor: Colors.white24,
                        hintText: "Nome Completo",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide:
                                BorderSide(color: Colors.white24, width: 0.5)),
                        prefixIcon: const Icon(
                          Icons.person_add,
                          color: Color.fromARGB(255, 6, 6, 6),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      style: TextStyle(
                        color: const Color.fromARGB(255, 1, 1, 1),
                        fontWeight:
                            FontWeight.bold,
                      ),
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontFamily: "WorkSansLight",
                            fontSize: 15.0),
                        filled: true,
                        fillColor: Colors.white24,
                        hintText: "E-mail",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide:
                                BorderSide(color: Colors.white24, width: 0.5)),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 3, 3, 3),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      style: TextStyle(
                        color: const Color.fromARGB(255, 1, 1, 1),
                        fontWeight: FontWeight.bold,
                      ),
                      controller: _senhaController,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontFamily: "WorkSansLight",
                            fontSize: 15.0),
                        filled: true,
                        fillColor: Colors.white24,
                        hintText: "Senha",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide:
                                BorderSide(color: Colors.white24, width: 0.5)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextSenha
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromARGB(255, 5, 5, 5),
                          ),
                          onPressed: _togglePasswordVisibilitySenha,
                        ),
                      ),
                      obscureText: _obscureTextSenha,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      style: TextStyle(
                        color: const Color.fromARGB(255, 1, 1, 1),
                        fontWeight: FontWeight.bold,
                      ),
                      controller: _confirmacaoSenhaController,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontFamily: "WorkSansLight",
                            fontSize: 15.0),
                        filled: true,
                        fillColor: Colors.white24,
                        hintText: "Canfirmar Senha",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide:
                                BorderSide(color: Colors.white24, width: 0.5)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextConfirmacaoSenha
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromARGB(255, 11, 11, 11),
                          ),
                          onPressed: _togglePasswordVisibilityConfirmacaoSenha,
                        ),
                      ),
                      obscureText: _obscureTextConfirmacaoSenha,
                    ),
                    SizedBox(height: 32.0),
                    CustomButton(
                      text: 'CADASTRAR',
                      onPressed: _cadastrarUsuario,
                    ),
                  SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Já tem cadastro? ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            'Faça login',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Página Inicial! ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/home'); 
                          },
                          child: Text(
                            'Voltar',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}