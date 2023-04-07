import 'dart:convert';
import 'ListadoServicio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_servicio/ServicioBE.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart' show Future;
import 'package:json_table/json_table.dart';

class NuevoServicio extends StatefulWidget {
  String titulo;
  ServicioBE oServicio = ServicioBE();
  int codigoServicioSeleccionado = 0;
  String urlGeneral = 'http://wscibertec2022.somee.com';
  String urlController = "/Servicio";
  String urlListarKey = "/ListarKey?pCodigoServicio=";
  String urlRegistrModificia = "/RegistraModifica?";

  String mensaje = "";
  bool validacion = false;

  NuevoServicio(this.titulo, this.codigoServicioSeleccionado);

  @override
  _NuevoServicio createState() => _NuevoServicio();
}

class _NuevoServicio extends State<NuevoServicio> {
  final _tfCliente = TextEditingController();
  final _tfOrden = TextEditingController();
  final _tfFecha = TextEditingController();
  final _tfLinea = TextEditingController();
  final _tfEstado = TextEditingController();
  final _tfObservacion = TextEditingController();
  String mValidacion = "Falta completar datos";

  @override
  void initState() {
    super.initState();
    widget.oServicio.inicializar();
    if (widget.codigoServicioSeleccionado > 0) {
       listarKey();
    }
  }

  Future<String> listarKey() async{
    String urlListaServicios = widget.urlGeneral +
      widget.urlController +
      widget.urlListarKey +
      widget.codigoServicioSeleccionado.toString();
    var respuesta = await http.get(Uri.parse(urlListaServicios));
    setState(() {
      widget.oServicio = ServicioBE.fromJson(
        json.decode(respuesta.body)
      );
      if (widget.oServicio.CodigoServicio !> 0) {
        widget.mensaje = "Estás actualizando los datos";
        _mostrarDatos();
      }
    });
    return "Procesando";
  }

    void _mostrarDatos(){
     _tfCliente.text = widget.oServicio.NombreCliente.toString();
     _tfOrden.text = widget.oServicio.NumeroOrdenServicio.toString();
     _tfFecha.text = widget.oServicio.FechaProgramada.toString();
     _tfLinea.text = widget.oServicio.Linea.toString();
     _tfEstado.text = widget.oServicio.Estado.toString();
     _tfObservacion.text = widget.oServicio.Observaciones.toString();
  }

    bool _validarRegistro() {
    if (_tfCliente.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = mValidacion;
      });
      return false;
    }
    if (_tfOrden.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = mValidacion;
      });
      return false;
    }
    if (_tfFecha.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = mValidacion;
      });
      return false;
    }
    if (_tfLinea.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = mValidacion;
      });
      return false;
    }
    if (_tfEstado.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = mValidacion;
      });
      return false;
    }
    if (_tfObservacion.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = mValidacion;
      });
      return false;
    }
    return true;
  }
  
  void _grabarRegistro(){
     if(_validarRegistro()){
      _ejecutarServicioGrabar();
      widget.oServicio.inicializar();
     }
  }

  Future<String> _ejecutarServicioGrabar() async {
    String accion = "N";
    if (widget.oServicio.CodigoServicio !> 0) {
      accion = "A";
    }

    // http://wscibertec2022.somee.com/Servicio/
    // RegistraModifica?Accion=N&CodigoServicio=
    // 0&NombreCliente=UNMA2Q%20S.A.&NumeroOrdenServicio
    // =ORD-2016-001&Fechaprogramada=20161104&Linea=
    // KING%20OCEAN%20SERVICES&Estado=Aprobado&Observaciones
    // =Ninguno

    String strParametros = "";
    strParametros+="CodigoServicio="+widget.oServicio.CodigoServicio.toString();
    strParametros+="&NombreCliente="+_tfCliente.text;
    strParametros+="&NumeroOrdenServicio="+_tfOrden.text;
    strParametros+="&Fechaprogramada="+_tfFecha.text;
    strParametros+="&Linea="+_tfLinea.text;
    strParametros+="&Estado="+_tfEstado.text;
    strParametros+="&Observaciones="+_tfObservacion.text;
    strParametros+="&Accion="+accion;

    String urlRegistroServicio = "";
    urlRegistroServicio = 
    widget.urlGeneral + 
    widget.urlController +
    widget.urlRegistrModificia +
    strParametros;

    var respuesta = await http.get(Uri.parse(urlRegistroServicio));
    var data = respuesta.body;
    setState(() {
      widget.oServicio = ServicioBE.fromJson(
        json.decode(data)
      );
      if(widget.oServicio.CodigoServicio !> 0){
        widget.mensaje = "Grabado Correctamente";
      }
    });
    return "procesado";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Registro de Servicio " + widget.titulo),
        ),
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(" Código de Servicio:" +
                  widget.oServicio.CodigoServicio.toString()),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                children: <Widget>[
                  TextField(
                      controller: _tfCliente,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Cliente",
                        labelText: "Cliente",
                      )),
                  TextField(
                      controller: _tfOrden,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Nro Orden",
                        labelText: "Nro Orden",
                      )),
                  TextField(
                      controller: _tfFecha,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Fecha",
                        labelText: "Fecha",
                      )),
                  TextField(
                      controller: _tfLinea,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Línea",
                        labelText: "Línea",
                      )),
                  TextField(
                      controller: _tfEstado,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Estado",
                        labelText: "Estado",
                      )),
                  TextField(
                      controller: _tfObservacion,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Observaciones",
                        labelText: "Observaciones",
                      )),
                  RaisedButton(
                    color: Colors.lightGreen[400],
                    child: Text("Grabar"),
                    onPressed: _grabarRegistro
                    ),
                  Text("Mensaje:" + widget.mensaje),
                ],
              ),
            )
          ],
        ));
  }
}
