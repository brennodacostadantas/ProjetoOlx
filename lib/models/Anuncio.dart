import 'package:cloud_firestore/cloud_firestore.dart';

class Anuncio {
  String? _id;
  String? _estado;
  String? _categoria;
  String? _titulo;
  String? _preco;
  String? _telefone;
  String? _descricao;
  List<String>? _fotos;

  Anuncio();

  Anuncio.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.id;
    estado = documentSnapshot["estado"];
    categoria = documentSnapshot["categoria"];
    titulo = documentSnapshot["titulo"];
    preco = documentSnapshot["preco"];
    telefone = documentSnapshot["telefone"];
    descricao = documentSnapshot["descricao"];
    fotos = List<String>.from(documentSnapshot["fotos"]);
  }

  Anuncio.gerarId() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference anuncios = db.collection("meus_anuncios");
    id = anuncios.doc().id;
    fotos = [];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "estado": estado,
      "categoria": categoria,
      "titulo": titulo,
      "preco": preco,
      "telefone": telefone,
      "descricao": descricao,
      "fotos": fotos,
    };
    return map;
  }

  List<String>? get fotos => _fotos;

  set fotos(List<String>? value) {
    _fotos = value;
  }

  String? get descricao => _descricao;

  set descricao(String? value) {
    _descricao = value;
  }

  String? get titulo => _titulo;

  set titulo(String? value) {
    _titulo = value;
  }

  String? get telefone => _telefone;

  set telefone(String? value) {
    _telefone = value;
  }

  String? get estado => _estado;

  set estado(String? value) {
    _estado = value;
  }

  String? get categoria => _categoria;

  set categoria(String? value) {
    _categoria = value;
  }

  String? get id => _id;

  set id(String? value) {
    _id = value;
  }

  String? get preco => _preco;

  set preco(String? value) {
    _preco = value;
  }
}
