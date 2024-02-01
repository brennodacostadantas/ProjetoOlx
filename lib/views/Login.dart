import 'package:flutter/material.dart';
import 'package:olx/models/Usuario.dart';
import 'package:olx/views/widgets/BotaoCustomizado.dart';
import 'package:olx/views/widgets/InputCustomizado.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _cadastrar = false;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";
  String _textoBotao = "Entrar";

  _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length > 6) {
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        if (_cadastrar) {
          _cadastrarUsuario(usuario);
        } else {
          _logarUsuario(usuario);
        }
      } else {
        _mensagemErro =
            "O campo senha é obrigatório! Senha precisa de mais de 6 caracteres!";
      }
    } else {
      _mensagemErro = "O campo email é obrigatório! Email precisa conter @!";
    }
  }

  _cadastrarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(
            email: usuario.email!, password: usuario.senha!)
        .then((firebaseUser) {
      Navigator.pushNamed(context, "/");
    });
  }

  _logarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(
            email: usuario.email!, password: usuario.senha!)
        .then((firebseUser) {
      Navigator.pushNamed(context, "/");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "Imagens/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                InputCustomizado(
                    controller: _controllerEmail,
                    hint: "Email",
                    autofocus: true,
                    type: TextInputType.emailAddress),
                InputCustomizado(
                    controller: _controllerSenha,
                    hint: "Senha",
                    obscure: true,
                    type: TextInputType.text),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Logar"),
                    Switch(
                        value: _cadastrar,
                        onChanged: (bool valor) {
                          setState(() {
                            _cadastrar = valor;
                            if (_cadastrar) {
                              _textoBotao = "Cadastrar";
                            }
                          });
                        }),
                    const Text("Cadastrar")
                  ],
                ),
                BotaoCustomizado(
                  texto: _textoBotao,
                  onPressed: () {
                    _validarCampos();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _mensagemErro,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
