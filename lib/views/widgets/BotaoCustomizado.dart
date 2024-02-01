import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  final String texto;
  final Color corTexto;
  final VoidCallback? onPressed;

  const BotaoCustomizado(
      {required this.texto,
      this.corTexto = Colors.white,
      this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          backgroundColor: const Color(0xff9c27b0),
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16)),
      child: Text(
        texto,
        style: TextStyle(color: corTexto, fontSize: 20),
      ),
    );
  }
}
