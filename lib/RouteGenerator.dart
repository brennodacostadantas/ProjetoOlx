import 'package:flutter/material.dart';
import 'package:olx/views/Anuncios.dart';
import 'package:olx/views/DetalhesAnuncio.dart';
import 'package:olx/views/Login.dart';
import 'package:olx/views/MeusAnuncios.dart';
import 'package:olx/views/NovoAnuncio.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    dynamic args = settings.arguments;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const Anuncios());
      case "/login":
        return MaterialPageRoute(builder: (_) => const Login());
      case "/meus-anuncios":
        return MaterialPageRoute(builder: (_) => const MeusAnuncios());
      case "/novo-anuncio":
        return MaterialPageRoute(builder: (_) => const NovoAnuncio());
      case "/detalhes-anuncio":
        return MaterialPageRoute(builder: (_) => DetalhesAnuncio(args));
      default:
        _erroRota();
    }
    return null;
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Tela não encontrada!"),
        ),
        body: const Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}
