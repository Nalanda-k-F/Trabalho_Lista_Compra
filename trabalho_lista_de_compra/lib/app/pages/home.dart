import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Image.asset(
            'img/imagem2.jpg', // Substitua pelo caminho correto da sua imagem de fundo
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          // Conteúdo sobre a imagem de fundo
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               SizedBox(height: 30),
              Center(
                child: Text(
                  'Bem Vindo!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20), // Espaçamento entre o texto e a imagem
              Expanded(
                child: Center(
                  child: Image.asset(
                    'img/logo.png', // Substitua pelo caminho correto da sua imagem central
                    width: 250, // Largura da imagem
                    height: 250, // Altura da imagem
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0), // Espaçamento em torno dos botões
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/cadastrar'); // Navega para a página de cadastro
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF0A7744), // Cor de fundo verde
                        onPrimary: Colors.white, // Cor do texto branco
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15), // Ajuste o tamanho do botão
                      ),
                      child: Text('Cadastrar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login'); // Navega para a página de login
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF0A7744), // Cor de fundo verde
                        onPrimary: Colors.white, // Cor do texto branco
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15), // Ajuste o tamanho do botão
                      ),
                      child: Text('Login'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
