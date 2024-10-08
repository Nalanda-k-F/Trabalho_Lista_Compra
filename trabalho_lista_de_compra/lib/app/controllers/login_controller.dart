import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/bd.dart'; // Importa a função de inicialização do banco

class LoginController {
  String? erroLogin; // Campo para armazenar a mensagem de erro

  Future<bool> fazerLogin({
    required BuildContext context,
    required String email,
    required String senha,
    required Function() limparCampos, // Função para limpar campos
  }) async {
    // Verificar se todos os campos estão preenchidos
    if (email.isEmpty || senha.isEmpty) {
      erroLogin = 'Todos os campos devem ser preenchidos.';
      _mostrarMensagem(context, erroLogin!, Colors.red);
      limparCampos(); // Limpar campos ao exibir erro
      return false;
    }

    final db = await ListaDatabase(); // Inicializa o banco de dados

    // Verificar se o usuário existe
    final resultado = await db.query(
      'Usuarios',
      where: 'email_usu = ? AND senha_usu = ?',
      whereArgs: [email, senha],
    );

    if (resultado.isEmpty) {
      erroLogin = 'E-mail ou senha inválidos.';
      _mostrarMensagem(context, erroLogin!, Colors.red);
      limparCampos(); // Limpar campos ao exibir erro
      return false;
    }

    // Obter o userId do usuário logado
    final userId = resultado.first['id_usu'] as int;

    // Login bem-sucedido
    _mostrarMensagem(context, 'Login realizado com sucesso.', Colors.green);
    erroLogin = null; // Limpe a mensagem de erro
    limparCampos(); // Limpar campos após sucesso

    // Navegar para TelaListas passando o userId
    Navigator.pushNamed(
      context,
      '/telaPrincipal',
      arguments: {'userId': userId},
    );

    return true;
  }

  void _mostrarMensagem(BuildContext context, String mensagem, Color corFundo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensagem,
          style: TextStyle(color: Colors.white), // Texto em branco
        ),
        backgroundColor: corFundo, // Cor de fundo configurada
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.0),
      ),
    );
  }
}
