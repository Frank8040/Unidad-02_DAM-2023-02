class User {
  final String? id;
  final String? nombres;
  final String? apellidos;
  final String? dni;
  final String? correo;
  final String? password;

  const User(
      {this.id,
      this.nombres,
      this.apellidos,
      this.dni,
      this.correo,
      this.password});

  factory User.fromMap(Map<String, dynamic> json) => User(
      id: json["id"],
      nombres: json["nombres"],
      apellidos: json["apellidos"],
      dni: json["dni"],
      correo: json["correo"],
      password: json["password"]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'dni': dni,
      'correo': correo,
      'password': password,
    };
  }
}
