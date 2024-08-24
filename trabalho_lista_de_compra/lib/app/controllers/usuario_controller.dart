import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/bd.dart'; // Importa a função de inicialização do banco
import '../pages/login.dart';

class UsuarioController {
  String? erroCadastro; // Campo para armazenar a mensagem de erro

  Future<void> cadastrarUsuario({
    required BuildContext context,
    required String nome,
    required String email,
    required String senha,
    required String confirmacaoSenha,
    required Function() limparCampos, // Função para limpar campos
  }) async {
    // Verificar se todos os campos estão preenchidos
    if (nome.isEmpty ||
        email.isEmpty ||
        senha.isEmpty ||
        confirmacaoSenha.isEmpty) {
      erroCadastro = 'Todos os campos devem ser preenchidos.';
      limparCampos(); // Limpar campos ao exibir erro
      _mostrarMensagem(context, erroCadastro!, Colors.red);
      return;
    }
    // Verificar o comprimento do nome
    if (nome.length < 3) {
      erroCadastro = 'O nome deve ter pelo menos 3 letras.';
      limparCampos(); // Limpar campos ao exibir erro
      _mostrarMensagem(context, erroCadastro!, Colors.red);
      return;
    }
    // Verificar o formato do email
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      erroCadastro =
          'O email deve conter um símbolo "@" e estar no formato correto.';
      limparCampos(); // Limpar campos ao exibir erro
      _mostrarMensagem(context, erroCadastro!, Colors.red);
      return;
    }

    // Verificar o comprimento da senha
    if (senha.length < 8) {
      erroCadastro = 'A senha deve ter pelo menos 8 dígitos.';
      limparCampos();
      _mostrarMensagem(context, erroCadastro!, Colors.red);
      return;
    }

    // Verificar se a senha e a confirmação de senha coincidem
    if (senha != confirmacaoSenha) {
      erroCadastro = 'A senha e a confirmação de senha não são iguais.';
      limparCampos();
      _mostrarMensagem(context, erroCadastro!, Colors.red);
      return;
    }

    final db = await initializeDatabase();

    // Verificar se o email já está cadastrado
    final resultado = await db.query(
      'Usuarios',
      where: 'email_usu = ?',
      whereArgs: [email],
    );

    if (resultado.isNotEmpty) {
      erroCadastro = 'O email já está cadastrado.';
      limparCampos(); // Limpar campos ao exibir erro
      _mostrarMensagem(context, erroCadastro!, Colors.red);
      return;
    }

    // Inserir novo usuário
    await db.insert(
      'Usuarios',
      {
        'nome_usu': nome,
        'email_usu': email,
        'senha_usu': senha,
        'confirmacao_senha_usu': confirmacaoSenha,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Mostrar mensagem de sucesso e redirecionar para a tela de login
    _mostrarMensagem(context, 'Cadastro realizado com sucesso.', Colors.green);
    erroCadastro = null; // Limpe a mensagem de erro
    limparCampos(); // Limpar campos após sucesso

    // Redirecionar para a tela de login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Login()), // Altere para a tela de login correta
    );
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
