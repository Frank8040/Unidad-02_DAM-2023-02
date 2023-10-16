class UserModel {
  UserModel({
    required this.nombres,
    required this.apellidos,
    required this.password,
    required this.correo,
    required this.token,
    required this.dni,
  });

  UserModel.login(this.correo, this.password)
      : nombres = "",
        apellidos = "",
        dni = "",
        token = "";

  late final String? nombres;
  late final String? apellidos;
  late final String? password;
  late final String? correo;
  late final String? token;
  late final String? dni;
  late final List<Roles>? roles;

  UserModel.fromJson(Map<String, dynamic> json) {
    nombres = json['nombres'];
    apellidos = json['apellidos'];
    password = json['password'];
    correo = json['correo'];
    token = json['token'];
    dni = json['dni'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['nombres'] = nombres;
    data['apellidos'] = apellidos;
    data['password'] = password;
    data['correo'] = correo;
    data['token'] = token;
    data['dni'] = dni;
    return data;
  }
}

class Roles {
  Roles({
    required this.id,
    required this.rolNombre,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });
  late final int id;
  late final String rolNombre;
  late final String fechaCreacion;
  late final String fechaActualizacion;

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rolNombre = json['rolNombre'];
    fechaCreacion = json['fechaCreacion'];
    fechaActualizacion = json['fechaActualizacion'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['rolNombre'] = rolNombre;
    data['fechaCreacion'] = fechaCreacion;
    data['fechaActualizacion'] = fechaActualizacion;
    return data;
  }
}

class RespUserModel {
  RespUserModel({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.password,
    required this.correo,
    required this.token,
    required this.dni,
  });
  late final int id;
  late final String nombres;
  late final String apellidos;
  late final String password;
  late final String correo;
  late final String token;
  late final String dni;

  RespUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombres = json['nombres'];
    apellidos = json['apellidos'];
    password = json['password'];
    correo = json['correo'];
    token = json['token'];
    dni = json['dni'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['nombres'] = nombres;
    data['apellidos'] = apellidos;
    data['password'] = password;
    data['correo'] = correo;
    data['token'] = token;
    data['dni'] = dni;
    return data;
  }
}
