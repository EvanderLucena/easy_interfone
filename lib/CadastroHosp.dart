import 'package:easy_interfone/HomeAdmin.dart';
import 'package:easy_interfone/model/User.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroHosp extends StatefulWidget {
  @override
  _CadastroHospState createState() => _CadastroHospState();
}

class _CadastroHospState extends State<CadastroHosp> {
  //controladores
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerQuarto = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerTipo = TextEditingController();

  String _msgErro = "";

  _validarCampos() {
    String nome = _controllerNome.text;
    String quarto = _controllerQuarto.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (nome.isNotEmpty) {
      if (quarto.isNotEmpty) {
        if (email.isNotEmpty && email.contains("@")) {
          if (senha.isNotEmpty && senha.length > 5) {
            setState(() {
              _msgErro = "";
            });
            User hospede = User();
            hospede.nome = nome;
            hospede.quarto = quarto;
            hospede.email = email;
            hospede.senha = senha;

            _cadastrarHosp( hospede );
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
      } else {
        setState(() {
          _msgErro = "Quarto não pode ser vazio.";
        });
      }
    } else {
      setState(() {
        _msgErro = "Nome não pode ser vazio.";
      });
    }
  }

  _cadastrarHosp(User hospede){

      FirebaseAuth auth = FirebaseAuth.instance;
      auth.createUserWithEmailAndPassword(
          email: hospede.email,
          // ignore: non_constant_identifier_names
          password: hospede.senha).then((FirebaseUser){
            //salvar dados do usuario
        Firestore db = Firestore.instance;
        db.collection("usuarios")
        .document(FirebaseUser.user.uid)
        .setData({});

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeAdmin()
                ));
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Hospede"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffF5F5F5)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Icon(
                    Icons.person_add,
                    color: Color(0xff00008B),
                    size: 40,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerQuarto,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Quarto",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "email",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
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
                          borderRadius: BorderRadius.circular(32))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Color(0xff00008B),
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
