import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomeAdmin.dart';
import 'HomeHosp.dart';
import 'HomePorteiro.dart';
import 'model/User.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  String _msgErro = "";

  _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;


    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length > 5) {
        setState(() {
          _msgErro = "";
        });
        User usuario = User();
        usuario.email = email;
        usuario.senha = senha;

        _logarUsuario(usuario);
      } else {
        setState(() {
          _msgErro = "Senha não pode ser vazia.";
        });
      }
    } else {
      setState(() {
        _msgErro = "Email invalido ou incorrento.";
      });
    }
  }

  _logarUsuario(User usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        // ignore: non_constant_identifier_names
        .then((FirebaseUser) {

      Firestore db = Firestore.instance;
      var uid = FirebaseUser.user.uid;
      var tipo = db.collection("hospedes").document(uid).collection("tipo");

      //fazer a verificação do tipo de user
      // ignore: unrelated_type_equality_checks
      if(tipo == "hospede"){

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeHosp()));

      // ignore: unrelated_type_equality_checks
      }else if(tipo == "porteiro"){

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePorteiro()));
      // ignore: unrelated_type_equality_checks
      }else {

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeAdmin()));
      }

    }).catchError((error) {
      setState(() {
        _msgErro = "Erro ao autenticar, verifique usuário e senha";
      });
    });
  }

  Future _verificaUserLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    if(usuarioLogado != null){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeAdmin()));
    }
  }
  @override
  void initState() {
    _verificaUserLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.blueAccent),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Icon(
                    Icons.person,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Login",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.black54,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      _validarCampos();
                    },
                  ),
                ),
                Center(
                  child: Text(
                    _msgErro,
                    style: TextStyle(color: Colors.red, fontSize: 20),
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
