class User {
  String _nome;
  String _quarto;
  String _email;
  String _senha;
  String _tipo;

  User();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {

    };
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get quarto => _quarto;

  set quarto(String value) {
    _quarto = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }
}