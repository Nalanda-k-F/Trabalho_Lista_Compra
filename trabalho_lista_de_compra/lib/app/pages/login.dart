import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import '../widgets/custom_button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final LoginController _loginController = LoginController();

  bool _obscureTextSenha = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureTextSenha = !_obscureTextSenha;
    });
  }

  void _fazerLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final senha = _senhaController.text;

      final sucesso = await _loginController.fazerLogin(
        context: context,
        email: email,
        senha: senha,
        limparCampos: _limparCampos,
      );

      if (sucesso) {
        // Redirecionar para a próxima tela após login bem-sucedido
        Navigator.pushReplacementNamed(context, '/userListPage'); // Ajuste para a rota desejada
      }
    }
  }

  void _limparCampos() {
    setState(() {
      _emailController.clear();
      _senhaController.clear();
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
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: "WorkSansLight",
                            fontSize: 15.0),
                        filled: true,
                        fillColor: Colors.white24,
                        hintText: "E-mail",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide(color: Colors.white24, width: 0.5)),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: _senhaController,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: "WorkSansLight",
                            fontSize: 15.0),
                        filled: true,
                        fillColor: Colors.white24,
                        hintText: "Senha",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide(color: Colors.white24, width: 0.5)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextSenha
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                      obscureText: _obscureTextSenha,
                    ),
                    SizedBox(height: 32.0),
                    CustomButton(
                      text: 'ENTRAR',
                      onPressed: _fazerLogin,
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
