import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class EmpresaModelo {
  EmpresaModelo({
    required this.id,
    required this.nombre,
    required this.nombreCorto,
    required this.direccion,
    required this.ruc,
    required this.ubigeo,
    required this.userId,
  });

  EmpresaModelo.unlaunched();

  late int id = 0;
  late final String nombre;
  late final String nombreCorto;
  late final String direccion;
  late final String ruc;
  late final String ubigeo;
  late final String userId;

  EmpresaModelo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    nombreCorto = json['nombreCorto'];
    direccion = json['direccion'];
    ruc = json['ruc'];
    ubigeo = json['ubigeo'];
    userId = json['userId'];
  }

  factory EmpresaModelo.fromJsonModelo(Map<String, dynamic> json) {
    return EmpresaModelo(
        id: json['id'],
        nombre: json['nombre'],
        nombreCorto: json['nombreCorto'],
        direccion: json['direccion'],
        ruc: json['ruc'],
        ubigeo: json['ubigeo'],
        userId: json['userId']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['nombre'] = nombre;
    data['nombreCorto'] = nombreCorto;
    data['direccion'] = direccion;
    data['ruc'] = ruc;
    data['ubigeo'] = ubigeo;
    data['userId'] = userId;
    return data;
  }
}
