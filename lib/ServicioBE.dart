import 'dart:convert';

class ServicioBE {

  int? CodigoServicio;
  String? NombreCliente;
  String? NumeroOrdenServicio;
  String? FechaProgramada;
  String? Linea;
  String? Estado;
  String? Observaciones;
  bool? Eliminado;
  int? CodigoError;
  String? DescripcionError;
  String? MensajeError;

  void inicializar(){
    this.CodigoServicio = 0;
    this.NombreCliente = "";
    this.NumeroOrdenServicio = "";
    this.FechaProgramada = "";
    this.Linea = "";
    this.Estado = "";
    this.Observaciones = "";
    this.Eliminado = false;
    this.CodigoError = 0;
    this.DescripcionError = "";
    this.MensajeError = "";
  }

  ServicioBE({
    this.CodigoServicio,
    this.NombreCliente,
    this.NumeroOrdenServicio,
    this.FechaProgramada,
    this.Linea,
    this.Estado,
    this.Observaciones,
    this.Eliminado,
    this.CodigoError,
    this.DescripcionError,
    this.MensajeError
  });

  factory ServicioBE.fromJson(Map<String, dynamic> json){
    return ServicioBE(
      CodigoServicio: json["CodigoServicio"],
      NombreCliente: json["NombreCliente"],
      NumeroOrdenServicio: json["NumeroOrdenServicio"],
      FechaProgramada: json["FechaProgramada"],
      Linea: json["Linea"],
      Estado: json["Estado"],
      Observaciones: json["Observaciones"],
      Eliminado: json["Eliminado"],
      CodigoError: json["CodigoError"],
      DescripcionError: json["DescripcionError"],
      MensajeError: json["MensajeError"],
    );
  }

}