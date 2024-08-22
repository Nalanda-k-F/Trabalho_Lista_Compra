import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF0A7744), // Cor de fundo verde
        onPrimary: Colors.white, // Cor do texto branco
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15), // Tamanho do botão
      ),
      child: Text(text),
    );
  }
}
