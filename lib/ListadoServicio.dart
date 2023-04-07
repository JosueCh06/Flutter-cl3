import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_servicio/ServicioBE.dart';
import 'NuevoServicio.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart' show Future;
import 'package:json_table/json_table.dart';

class ListadoServicios extends StatefulWidget {
  String titulo;
  List<ServicioBE> oListaServicios = [];
  int codigoServicioSeleccionado = 0;
  String urlGeneral = 'http://wscibertec2022.somee.com';
  String urlController = "/Servicio/";
  String urlListado = "/Listar?NombreCliente=";
  ListadoServicios(this.titulo);

  String jsonServicios =
      '[{"CodigoServicio": 0,"NombreCliente": "","NumeroOrdenServicio": "","FechaProgramada": "","Linea": "","Estado": "","Observaciones": "","Eliminado": false,"CodigoError": 0,"DescripcionError": "","MensajeError": null}]';

  @override
  State<StatefulWidget> createState() => _ListadoServicios();
}

class _ListadoServicios extends State<ListadoServicios> {
  final _tfCliente = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<String> _consultarServicios() async {
    String urlListaServicios = widget.urlGeneral +
        widget.urlController +
        widget.urlListado +
        _tfCliente.text.toString();
    var respuesta = await http.get(Uri.parse(urlListaServicios));
    var data = respuesta.body;
    var oListarServiciosTemp = List<ServicioBE>.from(
        jsonDecode(data).map((x) => ServicioBE.fromJson(x)));
    setState(() {
      widget.oListaServicios = oListarServiciosTemp;
      widget.jsonServicios = data;
      if (widget.oListaServicios.length == 0) {
        widget.jsonServicios =
            '[{"CodigoServicio": 0,"NombreCliente": "","NumeroOrdenServicio": "","FechaProgramada": "","Linea": "","Estado": "","Observaciones": "","Eliminado": false,"CodigoError": 0,"DescripcionError": "","MensajeError": null}]';
      }
    });
    return "Procesando";
  }

  void _nuevoServicio() {
        Navigator.of(context).push(
      new MaterialPageRoute<Null>(builder: (BuildContext pContexto){
        return new NuevoServicio("", widget.codigoServicioSeleccionado);
      }));
  }

  void _verRegistroServicio() {}

  @override
  Widget build(BuildContext context) {
    var json = jsonDecode(widget.jsonServicios);
    return Scaffold(
      appBar: AppBar(
        title: Text("Consulta de Servicios"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
                controller: _tfCliente,
                decoration: InputDecoration(
                  hintText: "Ingrese Nombre del Cliente",
                  labelText: "Cliente",
                )),
            Text(
              "Se encontraron " +
                  widget.oListaServicios.length.toString() +
                  " Servicios",
              style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
            ),
            new Table(
              children: [
                TableRow(children: [
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: RaisedButton(
                      color: Colors.lightGreen[400],
                      child: Text(
                        "Consultar",
                        style: TextStyle(fontFamily: "rbold"),
                      ),
                      onPressed: _consultarServicios,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: RaisedButton(
                      color: Colors.lightGreen[400],
                      child: Text(
                        "Nuevo",
                        style: TextStyle(fontFamily: "rbold"),
                      ),
                      onPressed: _nuevoServicio,
                    ),
                  )
                ]),
              ],
            ),
            JsonTable(
              json,
              showColumnToggle: true,
              allowRowHighlight: true,
              rowHighlightColor: Colors.lightGreen[200],
              paginationRowCount: 10,
              onRowSelect: (index, map) {
                widget.codigoServicioSeleccionado =
                    int.parse(map["CodigoServicio"].toString());
                    Navigator.of(context).push(
                    new MaterialPageRoute<Null>(builder: (BuildContext pContexto){
                       return new NuevoServicio("", widget.codigoServicioSeleccionado);
                    }));
                _verRegistroServicio();
              },
            )
          ],
        ),
      ),
    );
  }
}
