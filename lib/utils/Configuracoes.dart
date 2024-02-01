import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class Configuracoes{

  static List<DropdownMenuItem<String>> getCategorias(){
    List<DropdownMenuItem<String>> itensDropCategoria = [];
    
    itensDropCategoria.add(const DropdownMenuItem(
      value: null,
      child: Text("Categoria", style: TextStyle(color: Color(0xff9c27b0)),),
    ));
    
    itensDropCategoria.add(const DropdownMenuItem(
      value: "auto",
      child: Text("Automóvel"),
    ));

    itensDropCategoria.add(const DropdownMenuItem(
      value: "imovel",
      child: Text("Imóvel"),
    ));

    itensDropCategoria.add(const DropdownMenuItem(
      value: "eletro",
      child: Text("Eletrônicos"),
    ));

    itensDropCategoria.add(const DropdownMenuItem(
      value: "moda",
      child: Text("Moda"),
    ));
    
    return itensDropCategoria;
  }
  static List<DropdownMenuItem<String>> getEstados(){
    List<DropdownMenuItem<String>> listaItensDropEstados = [];
    
    listaItensDropEstados.add(const DropdownMenuItem(
      value: null,
      child: Text("Região", style: TextStyle(color: Color(0xff9c27b0)),),
    ));

    for (var estado in Estados.listaEstadosSigla) {
      listaItensDropEstados.add(DropdownMenuItem(
        value: estado,
        child: Text(estado),
      ));
    }
    
    return listaItensDropEstados;
  }
}