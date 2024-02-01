import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:olx/main.dart';
import 'package:olx/models/Anuncio.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesAnuncio extends StatefulWidget {
  Anuncio anuncio;
  DetalhesAnuncio(this.anuncio, {super.key});

  @override
  State<DetalhesAnuncio> createState() => _DetalhesAnuncioState();
}

class _DetalhesAnuncioState extends State<DetalhesAnuncio> {
  Anuncio? _anuncio;

  List<Widget> _getListaImagens() {
    List<String> listaUrlImagens = _anuncio!.fotos!;
    return listaUrlImagens.map((url) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(url), fit: BoxFit.fitWidth)),
      );
    }).toList();
  }

  _ligarTelefone(String telefone) async {
    await launchUrl(Uri.parse("tel:$telefone"));
  }

  @override
  void initState() {
    super.initState();
    _anuncio = widget.anuncio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anúncio"),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 250,
                child: CarouselSlider(
                    items: _getListaImagens(), options: CarouselOptions()),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("R\$ ${_anuncio!.preco}",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: temaPadrao.primaryColor)),
                    Text(
                      "${_anuncio!.titulo}",
                      style:
                          const TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    const Text(
                      "Descrição",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${_anuncio!.descricao}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider()),
                    const Text(
                      "Contato",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 66),
                      child: Text(
                        "${_anuncio!.telefone}",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: GestureDetector(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: temaPadrao.primaryColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Text(
                    "Ligar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                onTap: () {
                  _ligarTelefone(_anuncio!.telefone!);
                },
              ))
        ],
      ),
    );
  }
}
