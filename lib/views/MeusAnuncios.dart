import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/Anuncio.dart';
import 'package:olx/views/widgets/ItemAnucio.dart';

class MeusAnuncios extends StatefulWidget {
  const MeusAnuncios({super.key});

  @override
  State<MeusAnuncios> createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String? _idUsuarioLogado;

  _recuperarDadosUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = auth.currentUser!;
    _idUsuarioLogado = usuarioLogado.uid;
  }

  Future<Stream<QuerySnapshot>?> _adicionarListenerAnuncios() async {
    _recuperarDadosUsuarioLogado();
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("meus_anuncios")
        .doc(_idUsuarioLogado)
        .collection("anuncios")
        .snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
    return null;
  }

  _removerAnuncio(String idAnuncio) {
    //Remove o anúncio
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("meus_anuncios")
        .doc(_idUsuarioLogado)
        .collection("anuncios")
        .doc(idAnuncio)
        .delete().then((_) {
          db.collection("anuncios").doc(idAnuncio).delete();
          });
    //Remove as fotos do anúncio
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref().child("meus_anuncios").child(idAnuncio);
    pastaRaiz.listAll().then((diretorio) => {
          diretorio.items.forEach((fileRef) {
            var refFile = storage.ref(pastaRaiz.fullPath);
            var childRef = pastaRaiz.child(fileRef.name);
            childRef.delete();
          })
        });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    var carregandoDados = const Center(
        child: Column(
      children: [Text("Carregando anúncios..."), CircularProgressIndicator()],
    ));
    return Scaffold(
        appBar: AppBar(
          title: const Text("Meus Anúncios"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text("Adicionar"),
            onPressed: () {
              Navigator.pushNamed(context, "/novo-anuncio");
            }),
        body: StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return carregandoDados;
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return const Text("Erro ao carregar os dados!");
                }
                QuerySnapshot querySnapshot = snapshot.data!;
                return ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (_, indice) {
                      List<DocumentSnapshot> anuncios =
                          querySnapshot.docs.toList();
                      DocumentSnapshot documentSnapshot = anuncios[indice];
                      Anuncio anuncio =
                          Anuncio.fromDocumentSnapshot(documentSnapshot);
                      return ItemAnuncio(
                        anuncio: anuncio,
                        onPressedRemover: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Confirmar"),
                                  content: const Text(
                                      "Deseja realmente excluir o anúncio?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.grey),
                                      child: const Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _removerAnuncio(anuncio.id!);
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.red),
                                      child: const Text("Remover"),
                                    )
                                  ],
                                );
                              });
                        },
                      );
                    });
            }
          },
        ));
  }
}
