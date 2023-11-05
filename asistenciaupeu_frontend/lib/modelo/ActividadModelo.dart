// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ActividadModelo {
  ActividadModelo({
    required this.id,
    required this.nombreActividad,
    required this.fecha,
    required this.horai,
    required this.minToler,
    required this.latitud,
    required this.longitud,
    required this.estado,
    required this.evaluar,
    required this.userCreate,
    required this.mater,
    required this.validInsc,
    required this.asisSubact,
    required this.entsal,
    required this.offlinex,
    required this.asistenciaxs,
  });

  ActividadModelo.unlaunched();

  late int id = 0;
  late final String nombreActividad;
  late final String fecha;
  late final String horai;
  late final String minToler;
  late final String latitud;
  late final String longitud;
  late final String estado;
  late final String evaluar;
  late final String userCreate;
  late final String mater;
  late final String validInsc;
  late final String asisSubact;
  late final String entsal;
  late final String offlinex;
  late List<AsistenciaxRModelo> asistenciaxs;

  ActividadModelo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombreActividad = json['nombreActividad'];
    fecha = json['fecha'];
    horai = json['horai'];
    minToler = json['minToler'];
    latitud = json['latitud'];
    longitud = json['longitud'];
    estado = json['estado'];
    evaluar = json['evaluar'];
    userCreate = json['userCreate'];
    mater = json['mater'];
    validInsc = json['validInsc'];
    asisSubact = json['asisSubact'];
    entsal = json['entsal'];
    offlinex = json['offlinex'];
    if (json['asistenciaxs'] != null) {
      asistenciaxs = (json['asistenciaxs'] as List)
          .map((e) => AsistenciaxRModelo.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      asistenciaxs = [];
    }
  }

  factory ActividadModelo.fromJsonModelo(Map<String, dynamic> json) {
    return ActividadModelo(
        id: json['id'],
        nombreActividad: json['nombreActividad'],
        fecha: json['fecha'],
        horai: json['horai'],
        minToler: json['minToler'],
        latitud: json['latitud'],
        longitud: json['longitud'],
        estado: json['estado'],
        evaluar: json['evaluar'],
        userCreate: json['userCreate'],
        mater: json['mater'],
        validInsc: json['validInsc'],
        asisSubact: json['asisSubact'],
        entsal: json['entsal'],
        offlinex: json['offlinex'],
        asistenciaxs: []);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['nombreActividad'] = nombreActividad;
    data['fecha'] = fecha;
    data['horai'] = horai;
    data['minToler'] = minToler;
    data['latitud'] = latitud;
    data['longitud'] = longitud;
    data['estado'] = estado;
    data['evaluar'] = evaluar;
    data['userCreate'] = userCreate;
    data['mater'] = mater;
    data['validInsc'] = validInsc;
    data['asisSubact'] = asisSubact;
    data['entsal'] = entsal;
    data['offlinex'] = offlinex;
    data['asistenciaxs'] = asistenciaxs.map((v) => v.toJson()).toList();
    return data;
  }
}

class AsistenciaxRModelo {
  late int id = 0;
  late final DateTime fecha;
  late final String horaReg;
  late final String latituda;
  late final String longituda;
  late final String tipo;
  late final int calificacion;
  late final String cui;
  late final String tipoCui;
  late final String entsal;
  late final int subactasisId;
  late final String offlinex;

  AsistenciaxRModelo({
    required this.id,
    required this.fecha,
    required this.horaReg,
    required this.latituda,
    required this.longituda,
    required this.tipo,
    required this.calificacion,
    required this.cui,
    required this.tipoCui,
    required this.entsal,
    required this.subactasisId,
    required this.offlinex,
  });

  factory AsistenciaxRModelo.fromJson(Map<String, dynamic> json) {
    return AsistenciaxRModelo(
      id: json["id"],
      fecha: DateTime.parse(json["fecha"]),
      horaReg: json["horaReg"],
      latituda: json["latituda"],
      longituda: json["longituda"],
      tipo: json["tipo"],
      calificacion: json["calificacion"],
      cui: json["cui"],
      tipoCui: json["tipoCui"],
      entsal: json["entsal"],
      subactasisId: json["subactasisId"],
      offlinex: json["offlinex"],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    //final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['fecha'] = fecha;
    data['horaReg'] = horaReg;
    data['latituda'] = latituda;
    data['longituda'] = longituda;
    data['tipo'] = tipo;
    data['calificacion'] = calificacion;
    data['cui'] = cui;
    data['tipoCui'] = tipoCui;
    data['entsal'] = entsal;
    data['subactasisId'] = subactasisId;
    data['offlinex'] = offlinex;
    return data;
  }
}
