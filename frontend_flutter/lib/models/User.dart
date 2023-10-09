class User {
  final String nombres;
  final String apellidos;
  final String correo;
  final String password;
  final String dni;

  User({
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.password,
    required this.dni
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        correo: json["correo"],
        password: json["password"],
        dni: json["dni"]
      );

  Map<String, dynamic> toMap() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'correo': correo,
      'password': password,
      'dni': dni
    };
  }
}
