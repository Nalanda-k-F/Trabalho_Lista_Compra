import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/background_image.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(
              imagePath:
                  'img/imagem2.jpg'), // Usando o widget de imagem de fundo
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
                    width: 250,
                    height: 250,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      text: 'Cadastrar',
                      onPressed: () {
                        Navigator.pushNamed(context, '/cadastrar');
                      },
                    ),
                    CustomButton(
                      text: 'Login',
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
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
