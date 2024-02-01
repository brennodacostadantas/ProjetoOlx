import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/models/Anuncio.dart';
import 'package:olx/utils/Configuracoes.dart';
import 'package:olx/views/widgets/BotaoCustomizado.dart';
import 'package:olx/views/widgets/InputCustomizado.dart';
import 'package:validadores/validadores.dart';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({super.key});

  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  final _formKey = GlobalKey<FormState>();
  final List<File> _listaImagens = <File>[];
   List<DropdownMenuItem<String>> _listaItensDropEstados = [];
   List<DropdownMenuItem<String>> _listaItensDropCategorias = [];
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  Anuncio? _anuncio;
  BuildContext? _dialogContext;
  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;

  _selecionarImagemGaleria() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _listaImagens.add(File(pickedFile!.path));
    });
  }

  _abrirDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text("Salvando anúncio...")
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropdown();
    _anuncio = Anuncio.gerarId();
  }

  _carregarItensDropdown() {
    //Categorias
    _listaItensDropCategorias = Configuracoes.getCategorias();
    //Estados
    _listaItensDropEstados = Configuracoes.getEstados();
  }

  _salvarAnuncio() async {
    _abrirDialog(_dialogContext!);
    //Fazer o upload das imagens no Storage
    await _uploadImagens();
    //Salva o anúncio
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("meus_anuncios")
        .doc(usuarioLogado!.uid)
        .collection("anuncios")
        .doc(_anuncio!.id)
        .set(_anuncio!.toMap())
        .then((_) {
          //Salvar anúncio público
          db.collection("anuncios").doc(_anuncio!.id).set(_anuncio!.toMap()).then((_) {      
            Navigator.pop(_dialogContext!);
            Navigator.pop(context);
            });
    });
  }

  Future _uploadImagens() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    //Percorrendo a lista de imagens para fazer upload
    for (var imagem in _listaImagens) {
      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
      Reference arquivo = pastaRaiz
          .child("meus_anuncios")
          .child(_anuncio!.id!)
          .child("$nomeImagem.jpg");
      //Fazendo o upload das imagens
      UploadTask uploadTask = arquivo.putFile(imagem);
      await uploadTask.whenComplete(() async {
        try {
          String url = await (await uploadTask).ref.getDownloadURL();
          _anuncio!.fotos!.add(url);
        } catch (onError) {
          print(onError);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Anúncio"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormField<List>(
                    initialValue: _listaImagens,
                    validator: (imagens) {
                      if (imagens!.isEmpty) {
                        return "Necessário selecionar uma imagem!";
                      }
                      return null;
                    },
                    builder: (state) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                                itemCount: _listaImagens.length + 1,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, indice) {
                                  if (indice == _listaImagens.length) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 8),
                                      child: GestureDetector(
                                        onTap: _selecionarImagemGaleria,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey[400],
                                          radius: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_a_photo,
                                                size: 40,
                                                color: Colors.grey[100],
                                              ),
                                              Text(
                                                "Adicionar",
                                                style: TextStyle(
                                                    color: Colors.grey[100]),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  if (_listaImagens.isNotEmpty) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Image.file(
                                                            _listaImagens[
                                                                indice]),
                                                        TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                _listaImagens.removeAt(indice);
                                                                Navigator.of(context).pop();
                                                              });
                                                            },
                                                            child: const Text(
                                                              "Excluir",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ))
                                                      ],
                                                    ),
                                                  ));
                                        },
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              FileImage(_listaImagens[indice]),
                                          child: Container(
                                            color: const Color.fromRGBO(
                                                255, 255, 255, 0.4),
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Container();
                                }),
                          ),
                          if (state.hasError)
                            Text(
                              "[${state.errorText}]",
                              style: const TextStyle(color: Colors.red, fontSize: 14),
                            )
                        ],
                      );
                    }),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: DropdownButtonFormField(
                        value: _itemSelecionadoEstado,
                        hint: const Text("Estados"),
                        onSaved: (estado) {
                          _anuncio!.estado = estado;
                        },
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                        items: _listaItensDropEstados,
                        validator: (value) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Campo obrigatório!")
                              .valido(value);
                        },
                        onChanged: (value) {
                          setState(() {
                            _itemSelecionadoEstado = value;
                          });
                        },
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: DropdownButtonFormField(
                        value: _itemSelecionadoCategoria,
                        hint: const Text("Categorias"),
                        onSaved: (categoria) {
                          _anuncio!.categoria = categoria;
                        },
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                        items: _listaItensDropCategorias,
                        validator: (value) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Campo obrigatório!")
                              .valido(value);
                        },
                        onChanged: (value) {
                          setState(() {
                            _itemSelecionadoCategoria = value;
                          });
                        },
                      ),
                    ))
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 15, top: 15),
                    child: InputCustomizado(
                        controller: _tituloController,
                        hint: "Título",
                        onSaved: (titulo) {
                          _anuncio!.titulo = titulo;
                          return null;
                        },
                        validator: (valor) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Campo obrigatório")
                              .validar(valor);
                        })),
                Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: InputCustomizado(
                        controller: _precoController,
                        hint: "Preço",
                        type: TextInputType.number,
                        inputFormaters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(casasDecimais: 2)
                        ],
                        onSaved: (preco) {
                          _anuncio!.preco = preco;
                          return null;
                        },
                        validator: (valor) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Campo obrigatório")
                              .validar(valor);
                        })),
                Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: InputCustomizado(
                        controller: _telefoneController,
                        hint: "Telefone",
                        type: TextInputType.number,
                        inputFormaters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter()
                        ],
                        onSaved: (telefone) {
                          _anuncio!.telefone = telefone;
                          return null;
                        },
                        validator: (valor) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Campo obrigatório")
                              .validar(valor);
                        })),
                Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: InputCustomizado(
                        controller: _descricaoController,
                        hint: "Descrição (200 caracteres)",
                        maxLines: null,
                        onSaved: (descricao) {
                          _anuncio!.descricao = descricao;
                          return null;
                        },
                        validator: (valor) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Campo obrigatório")
                              .maxLength(200, msg: "Máximo de 200 caracteres")
                              .validar(valor);
                        })),
                BotaoCustomizado(
                  texto: "Cadastrar Anúncio",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      //Salvar os campos do formulário
                      _formKey.currentState!.save();
                      //Configurar o dialog context
                      _dialogContext = context;
                      //Salvar anúncio
                      _salvarAnuncio();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
