import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:olx/models/Anuncio.dart';
import 'package:olx/utils/Configuracoes.dart';
import 'package:olx/views/widgets/ItemAnucio.dart';

class Anuncios extends StatefulWidget {
  const Anuncios({super.key});

  @override
  State<Anuncios> createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  List<String> itensMenu = [];
  List<DropdownMenuItem<String>> _listaItensDropCategorias = [];
  List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;
  final _controller = StreamController<QuerySnapshot>.broadcast();

  _escolhaMenuItem(String? itemEscolhido) {
    switch (itemEscolhido) {
      case "Meus anúncios":
        Navigator.pushNamed(context, "/meus-anuncios");
        break;
      case "Entrar/Cadastar":
        Navigator.pushNamed(context, "/login");
        break;
      case "Sair":
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushNamed(context, "/");
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;

    if (usuarioLogado == null) {
      itensMenu = ["Entrar/Cadastar"];
    } else {
      itensMenu = ["Meus anúncios", "Sair"];
    }
  }

  _carregarItensDropdown() {
    //Categorias
    _listaItensDropCategorias = Configuracoes.getCategorias();
    //Estados
    _listaItensDropEstados = Configuracoes.getEstados();
  }

  Future<Stream<QuerySnapshot>?> _filtrarAnuncios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = db.collection("anuncios");

    if (_itemSelecionadoEstado != null) {
      query = query.where("estado", isEqualTo: _itemSelecionadoEstado);
    }

    if (_itemSelecionadoCategoria != null) {
      query = query.where("categoria", isEqualTo: _itemSelecionadoCategoria);
    }

    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((event) {
      _controller.add(event);
    });
    return null;
  }

  Future<Stream<QuerySnapshot>?> _adicionarListenerAnuncios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db.collection("anuncios").snapshots();
    stream.listen((event) {
      _controller.add(event);
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropdown();
    _verificarUsuarioLogado();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    var carregandoDados = const Center(
        child: Column(
      children: [Text("Carregando anúncios"), CircularProgressIndicator()],
    ));
    return Scaffold(
      appBar: AppBar(
        title: const Text("OLX"),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: DropdownButtonHideUnderline(
                        child: Center(
                  child: DropdownButton(
                    iconEnabledColor: const Color(0xff9c27b0),
                    value: _itemSelecionadoEstado,
                    items: _listaItensDropEstados,
                    style: const TextStyle(fontSize: 22, color: Colors.black),
                    onChanged: (estado) {
                      setState(() {
                        _itemSelecionadoEstado = estado;
                        _filtrarAnuncios();
                      });
                    },
                  ),
                ))),
                Container(
                  color: Colors.grey[200],
                  width: 2,
                  height: 60,
                ),
                Expanded(
                    child: DropdownButtonHideUnderline(
                        child: Center(
                  child: DropdownButton(
                    iconEnabledColor: const Color(0xff9c27b0),
                    value: _itemSelecionadoCategoria,
                    items: _listaItensDropCategorias,
                    style: const TextStyle(fontSize: 22, color: Colors.black),
                    onChanged: (categoria) {
                      setState(() {
                        _itemSelecionadoCategoria = categoria;
                        _filtrarAnuncios();
                      });
                    },
                  ),
                )))
              ],
            ),
            StreamBuilder(
                stream: _controller.stream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return carregandoDados;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      QuerySnapshot querySnapshot = snapshot.data!;

                      if (querySnapshot.docs.isEmpty) {
                        return Container(
                            padding: const EdgeInsets.all(25),
                            child: const Text(
                              "Nenhum anúncio cadastrado!",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ));
                      }

                      return Expanded(
                        child: ListView.builder(
                            itemCount: querySnapshot.docs.length,
                            itemBuilder: (_, indice) {
                              List<DocumentSnapshot> anuncios =
                                  querySnapshot.docs.toList();
                              DocumentSnapshot documentSnapshot =
                                  anuncios[indice];
                              Anuncio anuncio = Anuncio.fromDocumentSnapshot(
                                  documentSnapshot);
                              return ItemAnuncio(
                                anuncio: anuncio,
                                onTapItem: () {
                                  Navigator.pushNamed(
                                      context, "/detalhes-anuncio",
                                      arguments: anuncio);
                                },
                              );
                            }),
                      );
                  }
                })
          ],
        ),
      ),
    );
  }
}
